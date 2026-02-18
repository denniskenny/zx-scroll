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

void copy_viewport_32x16_to_screen_ring_2d(unsigned char *buffer, unsigned char head_row, unsigned char head_col, unsigned char fine_x);
void load_scr_to_screen(const unsigned char *scr);

extern const unsigned char hud_scr[];

// 32x12 viewport buffer for dirty-edge scrolling (256x96 pixels)
extern unsigned char offscreen_buffer_32x16[];

int camera_x = 0;
int camera_y = 0;
unsigned char head_row = 0;
unsigned char head_col = 0;  // Horizontal ring-buffer offset (0-32)
unsigned char fine_x = 0;   // Sub-byte pixel offset (0-7)

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

// Draw one scanline of tilemap (33 bytes: 32 visible + 1 lookahead for fine_x blending)
static void draw_scanline(unsigned char *dst, const unsigned char *map_row, unsigned char in_tile_y, unsigned char start_col) {
    unsigned char col;
    for (col = 0; col < 33; col++) {
        unsigned char map_col = start_col + col;
        if (map_col >= MAP_WIDTH) map_col = MAP_WIDTH - 1;  // Clamp to last tile
        unsigned char tile_idx = map_row[map_col];
        dst[col] = tiles[(tile_idx << 3) + in_tile_y];
    }
}

// Draw initial tilemap to buffer (33-byte rows for horizontal ring-buffer)
void draw_initial_tilemap(void) {
    unsigned char *row_ptr = offscreen_buffer_32x16;
    const unsigned char *map_row = map_data;
    unsigned char in_tile_y = 0;
    unsigned char py;
    
    for (py = 0; py < 96; py++) {
        draw_scanline(row_ptr, map_row, in_tile_y, 0);  // Start at column 0
        row_ptr += 33;  // Buffer is now 33 bytes wide (32 visible + 1 for ring-buffer)
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
    
    // Use 2D ring blitter for initial render
    copy_viewport_32x16_to_screen_ring_2d(offscreen_buffer_32x16, head_row, head_col, fine_x);
    
    // Frame-synced main loop:
    // 1. HALT to sync to frame interrupt (top border start - reliable)
    // 2. Read input (fast, during top border)
    // 3. Scroll + edge draw (during top border + lines 0-47)
    // 4. Blit to screen (beam reaches viewport Y=48 ~25000T after HALT)
    //    We race the beam: write from top of viewport downward
    
    unsigned char need_blit = 1;
    
    while (1) {
        unsigned char direction;
        
        // Step 1: Sync to frame start
        intrinsic_halt();
        
        // Step 2: Read input (fast, ~500T)
        direction = read_keys();

        // Step 3: Scroll + edge draw (during safe time before beam hits viewport)
        if (direction != SCROLL_NONE) {
            dirty_edge_scroll(direction, map_data, tiles, offscreen_buffer_32x16, &head_row, &head_col, &fine_x,
                             &camera_x, &camera_y, MAP_WIDTH, MAP_HEIGHT, 2, 2);
            need_blit = 1;
        }

        // Step 4: Blit (beam is approaching viewport - write top-down, racing it)
        // Delay until beam approaches viewport Y=48 (~25,088T after HALT)
        // Edge drawing + input uses variable time, so we burn remaining T-states
        // to start the blit just as the beam enters the viewport area.
        // This pushes any tearing to the bottom of the viewport.
        if (need_blit) {
            __asm
                ; Busy-wait: ~12,000T (calibrated for post-edge-draw timing)
                ; Each outer iteration = 13*inner + 8 ≈ 3336T, × 4 ≈ 13,344T
                ld b, 4
            _blit_delay_outer:
                ld c, 255
            _blit_delay_inner:
                dec c
                jr nz, _blit_delay_inner
                djnz _blit_delay_outer
            __endasm;
            copy_viewport_32x16_to_screen_ring_2d(offscreen_buffer_32x16, head_row, head_col, fine_x);
            need_blit = 0;
        }
    }
}