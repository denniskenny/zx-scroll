#include <input.h>
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>
#include "map_data.h"

#define KEMPSTON_PORT 0x1F
#define KEMPSTON_RIGHT 0x01
#define KEMPSTON_LEFT 0x02
#define KEMPSTON_DOWN 0x04
#define KEMPSTON_UP 0x08

static unsigned char kempston_read(void) __naked {
    __asm
        push bc
        ld bc, #KEMPSTON_PORT
        in a, (c)
        pop bc
        ld l, a
        ret
    __endasm;
}

static unsigned char kbd_read_row(unsigned int port) __naked {
    port;
    __asm
        push bc
        ld b, h
        ld c, l
        in a, (c)
        pop bc
        ld l, a
        ret
    __endasm;
}

// Tile definitions (4x4 tiles, 8x8 pixels each)
#define TILE_WIDTH 8
#define TILE_HEIGHT 8
#define MAP_WIDTH 96
#define MAP_HEIGHT 48
#define TILE_COUNT 4

void draw_map(void);
void clear_offscreen_buffer(void);
void copy_viewport_to_screen(void);
void load_map(void);
void init_map(void);

// Simple 2-color tile graphics (8 bytes per tile)
const unsigned char tiles[] = {
    // Tile 0: Empty
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    // Tile 1: Solid block
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    // Tile 2: Checkerboard
    0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
    // Tile 3: Border
    0xFF, 0x81, 0x81, 0x81, 0x81, 0x81, 0x81, 0xFF
};

// Map data from external file (embedded)
unsigned char map_data[MAP_WIDTH * MAP_HEIGHT];

// Off-screen buffer for double buffering (16x16 tiles = 128x128 pixels)
unsigned char offscreen_buffer[16 * 16 * 8];

// Fast empty detection using bitwise OR
static inline int fast_empty_check(const unsigned char *map_row) {
    // Check 4 chunks of 4 bytes using bitwise OR
    return !(map_row[0] | map_row[1] | map_row[2] | map_row[3] |
             map_row[4] | map_row[5] | map_row[6] | map_row[7] |
             map_row[8] | map_row[9] | map_row[10] | map_row[11] |
             map_row[12] | map_row[13] | map_row[14] | map_row[15]);
}

int camera_x = 0;
int camera_y = 0;

void init_map(void) {
    for (int y = 0; y < MAP_HEIGHT; y++) {
        for (int x = 0; x < MAP_WIDTH; x++) {
            unsigned char t = 0;

            if (x == 0 || y == 0 || x == (MAP_WIDTH - 1) || y == (MAP_HEIGHT - 1)) {
                t = 3;
            } else if (((x >> 2) + (y >> 2)) & 1) {
                t = 2;
            } else if ((x & 7) == 0 || (y & 7) == 0) {
                t = 1;
            } else {
                t = 0;
            }

            map_data[y * MAP_WIDTH + x] = t;
        }
    }
}

// Fast optimized inner loop for aligned drawing
static inline void draw_aligned_fast(unsigned char *row, unsigned char *map_row, const unsigned char *tiles_row, unsigned char in_tile_y) {
    // Draw non-empty tiles (main loop already checked for emptiness)
    for (int i = 0; i < 16; i++) {
        unsigned char tile = map_row[i];
        if (tile) {
            row[i] = tiles_row[tile * 8 + in_tile_y];
        }
    }
}

// Function to draw the visible portion of the map to off-screen buffer
void draw_map(void) {
    int cam_tile_x = camera_x >> 3;
    unsigned char in_tile_x = (unsigned char)(camera_x & 7);

    int tile_y = camera_y >> 3;
    unsigned char in_tile_y = (unsigned char)(camera_y & 7);

    // Clear entire buffer first to prevent trails
    memset(offscreen_buffer, 0, 16 * 16 * 8);

    unsigned char *row_ptr = offscreen_buffer; // Use incremental pointer
    unsigned char *map_ptr = &map_data[tile_y * MAP_WIDTH + cam_tile_x]; // Incremental map pointer
    const unsigned char *tiles_base = tiles; // Cached tiles base pointer
    int map_stride = MAP_WIDTH; // Cache for faster access

    if (in_tile_x == 0) {
        // Fast path: aligned (no blending needed)
        for (int py = 0; py < 128; py++) {
            // tiles_row should point to the start of tiles array, not offset
            const unsigned char *tiles_row = tiles_base; // Start of tiles array

            // Ultra-fast empty detection using bitwise OR (4 operations)
            // Check if any tile in the row is non-empty
            int row_has_tiles = 0;
            for (int check_i = 0; check_i < 16; check_i++) {
                if (map_ptr[check_i]) {
                    row_has_tiles = 1;
                    break;
                }
            }
            if (!row_has_tiles) {
                goto next_row_aligned; // Skip to next row
            }

            // Use assembly-optimized inner loop
            draw_aligned_fast(row_ptr, map_ptr, tiles_row, in_tile_y);

next_row_aligned:
            // Optimized tile y increment with modulo
            if (++in_tile_y == 8) {
                in_tile_y = 0;
                tile_y++;
                map_ptr += map_stride; // Move to next map row only on tile row change
            }
            row_ptr += 16; // Move to next row
        }
    } else {
        // Shifted path: blend two tiles (optimized)
        unsigned char shift = in_tile_x;
        unsigned char rshift = (unsigned char)(8 - shift);
        int next_tile_x = cam_tile_x + 1;
        int max_valid_tile = MAP_WIDTH - 1; // Precompute boundary

        for (int py = 0; py < 128; py++) {
            // tiles_row should point to the start of tiles array, not offset
            const unsigned char *tiles_row = tiles_base; // Start of tiles array

            // In shifted path, always check for potential blended tiles
            // Skip empty check for shifted path to ensure rightmost tiles are drawn

            // Compact loop for shifted drawing with optimized boundary checks
            int next_tile_pos = next_tile_x;
            for (int i = 0; i < 16; i++) {
                unsigned char t0 = map_ptr[i];
                unsigned char t1 = (next_tile_pos < MAP_WIDTH) ? map_ptr[i + 1] : 0;
                
                if (t0 || t1) {
                    if (t0 && t1) {
                        // Correct tile indexing: tile * 8 + in_tile_y
                        row_ptr[i] = (unsigned char)((tiles_row[t0 * 8 + in_tile_y] << shift) | (tiles_row[t1 * 8 + in_tile_y] >> rshift));
                    } else if (t0) {
                        row_ptr[i] = tiles_row[t0 * 8 + in_tile_y] << shift;
                    } else {
                        row_ptr[i] = tiles_row[t1 * 8 + in_tile_y] >> rshift;
                    }
                }
                next_tile_pos++; // Increment for next iteration
            }

next_row_shifted:
            // Optimized tile y increment with modulo
            if (++in_tile_y == 8) {
                in_tile_y = 0;
                tile_y++;
                map_ptr += map_stride; // Move to next map row only on tile row change
            }
            row_ptr += 16; // Move to next row
        }
    }
}

// Clear off-screen buffer
void clear_offscreen_buffer(void) {
    for (int i = 0; i < (16 * 16 * 8); i++) {
        offscreen_buffer[i] = 0;
    }
}

// Copy off-screen buffer to centered viewport on screen
void copy_viewport_to_screen(void) {
    const unsigned char view_offset_x = (unsigned char)(((32 - 16) / 2) * 8);
    const unsigned char view_offset_y = (unsigned char)(((24 - 16) / 2) * 8);
    
    for (int y = 0; y < 128; y++) {
        unsigned char *buffer = &offscreen_buffer[y * 16]; // Linear source
        unsigned char *screen = zx_pxy2saddr(view_offset_x, (unsigned char)(view_offset_y + y)); // ZX screen dest
        
        for (int x = 0; x < 16; x++) {
            screen[x] = buffer[x];
        }
    }
}


// Load map data from embedded array
void load_map(void) {
    memcpy(map_data, map_bin, MAP_WIDTH * MAP_HEIGHT);
}

int main(void) {
    // Set up the display
    zx_border(INK_BLACK);
    zx_cls(PAPER_BLACK | INK_WHITE);

    load_map();
    draw_map();
    
    // Main game loop
    while (1) {
       // Handle input (QAOP scrolls 1 pixel per frame)
        int dx = 0;
        int dy = 0;
        unsigned char input_active = 0;

        // Kempston joystick (support eight-way scrolling)
        unsigned char joy = kempston_read();
        if (joy & KEMPSTON_LEFT) {
            dx -= 1;
            input_active = 1;
        }
        if (joy & KEMPSTON_RIGHT) {
            dx += 1;
            input_active = 1;
        }
        if (joy & KEMPSTON_UP) {
            dy -= 1;
            input_active = 1;
        }
        if (joy & KEMPSTON_DOWN) {
            dy += 1;
            input_active = 1;
        }

        // QAOP keyboard
        unsigned char row_qwert = kbd_read_row(0xFEFE); // Q row
        unsigned char row_asdfg = kbd_read_row(0xFDFE); // A row
        unsigned char row_poiuy = kbd_read_row(0xF7FE); // O/P row

        if ((row_qwert & 0x01) == 0) { // Q
            dy -= 1;
            input_active = 1;
        }
        if ((row_asdfg & 0x01) == 0) { // A
            dy += 1;
            input_active = 1;
        }
        if ((row_poiuy & 0x01) == 0) { // O
            dx -= 1;
            input_active = 1;
        }
        if ((row_poiuy & 0x02) == 0) { // P
            dx += 1;
            input_active = 1;
        }

        int prev_x = camera_x;
        int prev_y = camera_y;

        camera_x += dx;
        camera_y += dy;

        // Cache visible tiles calculations (only when camera moves)
        if (input_active) {
            int visible_tiles_x = 16 + ((camera_x & 7) ? 1 : 0);
            int visible_tiles_y = 16 + ((camera_y & 7) ? 1 : 0);
            int max_x = (MAP_WIDTH - visible_tiles_x) * TILE_WIDTH;
            int max_y = (MAP_HEIGHT - visible_tiles_y) * TILE_HEIGHT;

            // Optimized boundary clamping
            if (camera_x < 0) camera_x = 0;
            else if (camera_x > max_x) camera_x = max_x;
            
            if (camera_y < 0) camera_y = 0;
            else if (camera_y > max_y) camera_y = max_y;
        }
        
        if (input_active) {
            draw_map();
            copy_viewport_to_screen();
        }
    }
}