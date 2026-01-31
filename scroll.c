#include <input.h>
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>
#include "map_data.h"
#include "draw_map.h"
#include "draw_dirty_edge.h"
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
void copy_viewport_32x16_to_screen(unsigned char *buffer);
void load_map(void);
void init_map(void);
void load_scr_to_screen(const unsigned char *scr);

extern const unsigned char hud_scr[];

// Map data from external file (embedded)
unsigned char map_data[MAP_WIDTH * MAP_HEIGHT];

// Off-screen buffer for double buffering (16x16 tiles = 128x128 pixels)
// Defined in draw_fast.asm with 256-byte alignment for safe inc e
extern unsigned char offscreen_buffer[16 * 16 * 8];

// 32x16 viewport buffer for dirty-edge scrolling (256x128 pixels)
extern unsigned char offscreen_buffer_32x16[];

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
    load_map();
    clear_viewport_attrs();
    draw_initial_tilemap();
    
    while (1) {
        unsigned char direction = SCROLL_NONE;

        unsigned char joy = kempston_read();
        if (joy & KEMPSTON_LEFT)  direction |= SCROLL_X_MINUS;
        if (joy & KEMPSTON_RIGHT) direction |= SCROLL_X_PLUS;
        if (joy & KEMPSTON_UP)    direction |= SCROLL_Y_MINUS;
        if (joy & KEMPSTON_DOWN)  direction |= SCROLL_Y_PLUS;

        if (!joy) {
            unsigned char row_qwert = kbd_read_row(0xFEFE);
            unsigned char row_asdfg = kbd_read_row(0xFDFE);
            unsigned char row_poiuy = kbd_read_row(0xF7FE);

            if ((row_qwert & 0x01) == 0) direction |= SCROLL_Y_MINUS;
            if ((row_asdfg & 0x01) == 0) direction |= SCROLL_Y_PLUS;
            if ((row_poiuy & 0x01) == 0) direction |= SCROLL_X_MINUS;
            if ((row_poiuy & 0x02) == 0) direction |= SCROLL_X_PLUS;
        }

        if (direction != SCROLL_NONE) {
            dirty_edge_scroll(direction, map_data, tiles, offscreen_buffer_32x16,
                             &camera_x, &camera_y, MAP_WIDTH, MAP_HEIGHT, 1);
        }

        copy_viewport_32x16_to_screen(offscreen_buffer_32x16);
        intrinsic_halt();
    }
}