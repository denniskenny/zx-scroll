#include <input.h>
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>
#include "draw_dirty_edge.h"

extern const unsigned char tiles[];
extern unsigned char map_data[];

// Input reader using z88dk's input library (keyboard + Kempston joystick)
static unsigned char read_keys(void) {
    unsigned char key_dir = SCROLL_NONE;
    unsigned char joy_dir = SCROLL_NONE;
    
    // Read keyboard
    if (in_key_pressed(IN_KEY_SCANCODE_q)) key_dir |= SCROLL_Y_MINUS;  // Q = up
    if (in_key_pressed(IN_KEY_SCANCODE_a)) key_dir |= SCROLL_Y_PLUS;   // A = down
    if (in_key_pressed(IN_KEY_SCANCODE_o)) key_dir |= SCROLL_X_MINUS;  // O = left
    if (in_key_pressed(IN_KEY_SCANCODE_p)) key_dir |= SCROLL_X_PLUS;   // P = right
    
    // Read Kempston joystick (returns bit flags: UP=0x01, DOWN=0x02, LEFT=0x04, RIGHT=0x08)
    uint16_t joy = in_stick_kempston();
    if (joy & IN_STICK_UP)    joy_dir |= SCROLL_Y_MINUS;
    if (joy & IN_STICK_DOWN)  joy_dir |= SCROLL_Y_PLUS;
    if (joy & IN_STICK_LEFT)  joy_dir |= SCROLL_X_MINUS;
    if (joy & IN_STICK_RIGHT) joy_dir |= SCROLL_X_PLUS;
    
    // Prefer keyboard if any key is pressed, otherwise use joystick
    if (key_dir != SCROLL_NONE) {
        return key_dir;
    }
    
    return joy_dir;
}

// Tile definitions (4x4 tiles, 8x8 pixels each)
#define TILE_WIDTH 8
#define TILE_HEIGHT 8
#define MAP_WIDTH 96
#define MAP_HEIGHT 48

void copy_viewport_32x16_to_screen(unsigned char *buffer);
void copy_viewport_32x16_to_screen_ring(unsigned char *buffer, unsigned char head_row);
void load_scr_to_screen(const unsigned char *scr);

extern const unsigned char hud_scr[];

// 32x16 viewport buffer for dirty-edge scrolling (256x128 pixels)
extern unsigned char offscreen_buffer_32x16[];

int camera_x = 0;
int camera_y = 0;
unsigned char head_row = 0;

static unsigned char floating_bus_wait(void) __naked {
    __asm
        ld b, #0x09
        ld c, #0x80
    _fb_wt:
        in a, (#0xFF)
        cp b
        jr z, _fb_ok
        dec c
        jr nz, _fb_wt
        ld l, #0x00
        jr _fb_dn
    _fb_ok:
        ld l, #0x01
    _fb_dn:
        ret
    __endasm;
}

void load_scr_to_screen(const unsigned char *scr) {
    __asm
        di
    __endasm;

    memcpy((void *)0x4000, scr, 6912);

    __asm
        ei
    __endasm;
}

// Clear attributes in the 32x12 viewport area (rows 6-17)
void clear_viewport_attrs(void) {
    // Viewport starts at char row 6, spans 12 rows
    // Attribute address = 0x5800 + row*32
    unsigned char *attr = (unsigned char *)(0x5800 + 6 * 32);
    memset(attr, PAPER_BLACK | INK_WHITE, 12 * 32);
}

// Draw one scanline of tilemap
static void draw_scanline(unsigned char *dst, const unsigned char *map_row, unsigned char in_tile_y) {
    unsigned char col;
    for (col = 0; col < 32; col++) {
        unsigned char tile_idx = map_row[col];
        dst[col] = tiles[(tile_idx << 3) + in_tile_y];
    }
}

// Draw initial tilemap to buffer
void draw_initial_tilemap(void) {
    unsigned char *row_ptr = offscreen_buffer_32x16;
    const unsigned char *map_row = map_data;
    unsigned char in_tile_y = 0;
    unsigned char py;
    
    for (py = 0; py < 96; py++) {
        draw_scanline(row_ptr, map_row, in_tile_y);
        row_ptr += 32;
        if (++in_tile_y == 8) {
            in_tile_y = 0;
            map_row += MAP_WIDTH;
        }
    }
}

int main(void) {
    zx_border(INK_BLACK);
    
    load_scr_to_screen(hud_scr);
    clear_viewport_attrs();
    draw_initial_tilemap();
    
    // Floating bus: set unique attribute at row 23 for sync detection
    *((unsigned char *)0x5AE0) = 0x09;
    
    // Beam-chasing main loop:
    // 1. Wait for beam past viewport (floating bus sync)
    // 2. Blit to screen (beam in bottom border/HUD - safe zone)
    // 3. Read input (free time while beam in border)
    // 4. Scroll + edge draw (free time while beam in top border/HUD)
    // 5. Loop (no HALT needed if floating bus syncs; HALT as fallback)
    
    // First frame always needs blit
    unsigned char need_blit = 1;
    
    while (1) {
        unsigned char direction = SCROLL_NONE;
        unsigned char fb_ok = 0;
        
        // Step 3: Read input (beam in bottom border - free time)
        direction = read_keys();

        // Idle fast-path: if nothing changed and no input, sleep (lowest CPU)
        if (!need_blit && direction == SCROLL_NONE) {
            intrinsic_halt();
            continue;
        }

        // Step 4: Scroll + edge draw (beam in border/top HUD - free time)
        if (direction != SCROLL_NONE) {
            dirty_edge_scroll(direction, map_data, tiles, offscreen_buffer_32x16, &head_row,
                             &camera_x, &camera_y, MAP_WIDTH, MAP_HEIGHT, 4, 2);  // stride_x=4, stride_y=2
            need_blit = 1;
        }

        // Step 1+2: Sync immediately before blit to minimize tearing
        if (need_blit) {
            fb_ok = floating_bus_wait();
            copy_viewport_32x16_to_screen_ring(offscreen_buffer_32x16, head_row);
            need_blit = 0;
        }
        
        // HALT as frame sync fallback
        if (!fb_ok) {
            intrinsic_halt();
        }
    }
}