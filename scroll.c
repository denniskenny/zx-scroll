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

// Clear attributes in the viewport area
void clear_viewport_attrs(void) {
    unsigned char row;
    for (row = 0; row < VIEWPORT_CHAR_ROWS; row++) {
        unsigned char *attr = (unsigned char *)(0x5800 + (VIEWPORT_START_CHAR_ROW + row) * 32 + VIEWPORT_COL_OFFSET);
        memset(attr, PAPER_BLACK | INK_WHITE, VIEWPORT_COLS);
    }
}

// Draw one scanline of tilemap (VIEWPORT_COLS+1 bytes: visible + 1 lookahead for fine_x blending)
static void draw_scanline(unsigned char *dst, const unsigned char *map_row, unsigned char in_tile_y, unsigned char start_col) {
    unsigned char col;
    for (col = 0; col < DIRTY_VIEWPORT_WIDTH_BYTES; col++) {
        unsigned char map_col = start_col + col;
        if (map_col >= MAP_WIDTH) map_col = MAP_WIDTH - 1;  // Clamp to last tile
        unsigned char tile_idx = map_row[map_col];
        dst[col] = tiles[(tile_idx << 3) + in_tile_y];
    }
}

// Draw initial tilemap to buffer
void draw_initial_tilemap(void) {
    unsigned char *row_ptr = offscreen_buffer_32x16;
    const unsigned char *map_row = map_data;
    unsigned char in_tile_y = 0;
    unsigned char py;
    
    for (py = 0; py < DIRTY_VIEWPORT_HEIGHT_PX; py++) {
        draw_scanline(row_ptr, map_row, in_tile_y, 0);
        row_ptr += DIRTY_VIEWPORT_WIDTH_BYTES;
        if (++in_tile_y == 8) {
            in_tile_y = 0;
            map_row += MAP_WIDTH;
        }
    }
}

// ZX Spectrum screen address from pixel Y coordinate
// Address = 0x4000 | (third << 11) | (char_row_in_third << 5) | (pixel_row << 8)
static unsigned char *zx_pixel_addr(unsigned char y) {
    unsigned int addr = 0x4000u
        | ((unsigned int)(y & 0xC0) << 5)
        | ((unsigned int)(y & 0x07) << 8)
        | ((unsigned int)(y & 0x38) << 2);
    return (unsigned char *)addr;
}

// After right shift: fill left 2 pixels (bits 7-6 of leftmost viewport byte)
static void dixel_draw_edge_left(const unsigned char *map, const unsigned char *til,
                                  int cam_x, int cam_y, int map_w) {
    unsigned char tile_col = cam_x >> 3;
    unsigned char in_tile_x = cam_x & 7;
    unsigned char py;

    for (py = 0; py < DIRTY_VIEWPORT_HEIGHT_PX; py++) {
        unsigned char map_y = cam_y + py;
        unsigned char tile_row = map_y >> 3;
        unsigned char in_tile_y = map_y & 7;
        unsigned char tile_idx = map[tile_row * map_w + tile_col];
        unsigned char tile_byte = til[(tile_idx << 3) + in_tile_y];

        unsigned char new_bits = (tile_byte << in_tile_x) & 0xC0;

        unsigned char *scr = zx_pixel_addr(VIEWPORT_START_CHAR_ROW * 8 + py) + VIEWPORT_COL_OFFSET;
        *scr = (*scr & 0x3F) | new_bits;
    }
}

// After left shift: fill right 2 pixels (bits 1-0 of rightmost viewport byte)
static void dixel_draw_edge_right(const unsigned char *map, const unsigned char *til,
                                   int cam_x, int cam_y, int map_w) {
    int right_px = cam_x + DIRTY_VIEWPORT_WIDTH_PX - 2;
    unsigned char tile_col = right_px >> 3;
    unsigned char in_tile_x = right_px & 7;
    unsigned char py;

    for (py = 0; py < DIRTY_VIEWPORT_HEIGHT_PX; py++) {
        unsigned char map_y = cam_y + py;
        unsigned char tile_row = map_y >> 3;
        unsigned char in_tile_y = map_y & 7;
        unsigned char tile_idx = map[tile_row * map_w + tile_col];
        unsigned char tile_byte = til[(tile_idx << 3) + in_tile_y];

        unsigned char new_bits = (tile_byte >> (6 - in_tile_x)) & 0x03;

        unsigned char *scr = zx_pixel_addr(VIEWPORT_START_CHAR_ROW * 8 + py)
                             + VIEWPORT_COL_OFFSET + VIEWPORT_COLS - 1;
        *scr = (*scr & 0xFC) | new_bits;
    }
}

int main(void) {
    zx_border(INK_BLACK);
    
    load_scr_to_screen(hud_scr);
    clear_viewport_attrs();
    
    draw_initial_tilemap();
    
    // Use 2D ring blitter for initial render
    copy_viewport_32x16_to_screen_ring_2d(offscreen_buffer_32x16, head_row, head_col, fine_x);

#if 0
    // === OLD MAIN LOOP (buffer + blitter pipeline) ===
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
                ; Busy-wait: ~10,000T (calibrated for viewport at Y=32)
                ; Beam reaches Y=32 at ~21,504T after HALT
                ; Each outer iteration = 13*inner + 8 ≈ 3336T, × 3 ≈ 10,008T
                ld b, 3
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
#endif

    // === DIXEL (2-pixel) SCROLL LOOP ===
    // Direct-to-screen shifting via SRL/SLA, no offscreen buffer needed.
    // L = shift right (camera moves left), K = shift left (camera moves right)
    {
        int dixel_camera_x = 0;
        int dixel_camera_y = 0;

        while (1) {
            intrinsic_halt();

            // L key = shift right (content moves right, camera_x decreases)
            if (in_key_pressed(IN_KEY_SCANCODE_l)) {
                if (dixel_camera_x > 0) {
                    dixel_camera_x -= 2;
                    dixel_wait_vblank();
                    dixel_shift_right();
                    dixel_draw_edge_left(map_data, tiles, dixel_camera_x, dixel_camera_y, MAP_WIDTH);
                }
            }
            // K key = shift left (content moves left, camera_x increases)
            if (in_key_pressed(IN_KEY_SCANCODE_k)) {
                if (dixel_camera_x < (MAP_WIDTH * 8) - DIRTY_VIEWPORT_WIDTH_PX) {
                    dixel_camera_x += 2;
                    dixel_wait_vblank();
                    dixel_shift_left();
                    dixel_draw_edge_right(map_data, tiles, dixel_camera_x, dixel_camera_y, MAP_WIDTH);
                }
            }
        }
    }
}