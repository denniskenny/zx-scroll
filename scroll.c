#include <input.h>
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>
#include "map_data.h"
#include "draw_map.h"

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
// Defined in draw_fast.asm with 256-byte alignment for safe inc e
extern unsigned char offscreen_buffer[16 * 16 * 8];

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

// Assembly-optimized screen copy (in copy_viewport.asm)
extern void copy_viewport_to_screen(void);


// Load map data from embedded array
void load_map(void) {
    memcpy(map_data, map_bin, MAP_WIDTH * MAP_HEIGHT);
}

int main(void) {
    // Set up the display
    zx_border(INK_BLACK);
    zx_cls(PAPER_BLACK | INK_WHITE);

    load_map();
    draw_map(map_data, tiles, offscreen_buffer, camera_x, camera_y, MAP_WIDTH);
    copy_viewport_to_screen();
    
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
            draw_map(map_data, tiles, offscreen_buffer, camera_x, camera_y, MAP_WIDTH);
            copy_viewport_to_screen();
        }
    }
}