#include <input.h>
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>
#include "map_data.h"
#include "draw_map.h"
#include "tiles_data.h"

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

void copy_viewport_to_screen(void);
void load_map(void);
void init_map(void);
void load_scr_to_screen(const unsigned char *scr);

extern const unsigned char hud_scr[];

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

void load_scr_to_screen(const unsigned char *scr) {
    __asm
        di
    __endasm;

    memcpy((void *)0x4000, scr, 6912);

    __asm
        ei
    __endasm;
}

int main(void) {
    const signed char speed = 4;
    const int max_x_aligned = (MAP_WIDTH - 16) * TILE_WIDTH;
    const int max_y_aligned = (MAP_HEIGHT - 16) * TILE_HEIGHT;
    
    // Set up the display
    zx_border(INK_BLACK);
    zx_cls(PAPER_BLACK | INK_WHITE);

    load_scr_to_screen(hud_scr);

    load_map();
    draw_map(map_data, tiles, offscreen_buffer, camera_x, camera_y, MAP_WIDTH);
    copy_viewport_to_screen();
    
    // Main game loop
    while (1) {
       // Handle input (QAOP scrolls 1 pixel per frame)
        signed char dx = 0;
        signed char dy = 0;

        // Kempston joystick (support eight-way scrolling)
        unsigned char joy = kempston_read();
        if (joy & KEMPSTON_LEFT) {
            dx -= speed;
        }
        if (joy & KEMPSTON_RIGHT) {
            dx += speed;
        }
        if (joy & KEMPSTON_UP) {
            dy -= speed;
        }
        if (joy & KEMPSTON_DOWN) {
            dy += speed;
        }

        if (!joy) {
            // QAOP keyboard
            unsigned char row_qwert = kbd_read_row(0xFEFE); // Q row
            unsigned char row_asdfg = kbd_read_row(0xFDFE); // A row
            unsigned char row_poiuy = kbd_read_row(0xF7FE); // O/P row

            if ((row_qwert & 0x01) == 0) { // Q
                dy -= speed;
            }
            if ((row_asdfg & 0x01) == 0) { // A
                dy += speed;
            }
            if ((row_poiuy & 0x01) == 0) { // O
                dx -= speed;
            }
            if ((row_poiuy & 0x02) == 0) { // P
                dx += speed;
            }
        }

        if (!dx && !dy) {
            continue;
        }

        int prev_x = camera_x;
        int prev_y = camera_y;

        camera_x += dx;
        camera_y += dy;

        // Optimized boundary clamping
        if (camera_x < 0) {
            camera_x = 0;
        } else {
            int in_tile_x = camera_x & 7;
            int max_x = max_x_aligned - (in_tile_x ? (8 - in_tile_x) : 0);
            if (camera_x > max_x) camera_x = max_x;
        }

        if (camera_y < 0) {
            camera_y = 0;
        } else {
            int in_tile_y = camera_y & 7;
            int max_y = max_y_aligned - (in_tile_y ? (8 - in_tile_y) : 0);
            if (camera_y > max_y) camera_y = max_y;
        }

        if (camera_x != prev_x || camera_y != prev_y) {
            draw_map(map_data, tiles, offscreen_buffer, camera_x, camera_y, MAP_WIDTH);
            copy_viewport_to_screen();
        }
    }
}