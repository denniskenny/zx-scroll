#include <input.h>
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>

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

// Larger map data (generated at runtime)
unsigned char map_data[MAP_WIDTH * MAP_HEIGHT];

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

// Function to draw the visible portion of the map
void draw_map(void) {
    const unsigned char view_tiles_x = 16;
    const unsigned char view_tiles_y = 16;
    const unsigned char view_offset_x = (unsigned char)(((32 - 16) / 2) * 8);
    const unsigned char view_offset_y = (unsigned char)(((24 - 16) / 2) * 8);

    int cam_tile_x = camera_x >> 3;
    unsigned char in_tile_x = (unsigned char)(camera_x & 7);

    int tile_y = camera_y >> 3;
    unsigned char in_tile_y = (unsigned char)(camera_y & 7);

    if (in_tile_x == 0) {
        // Fast path: aligned (no blending needed)
        for (int py = 0; py < (int)(view_tiles_y * 8); py++) {
            unsigned char *row = zx_pxy2saddr(view_offset_x, (unsigned char)(view_offset_y + py));
            unsigned char *map_row = &map_data[tile_y * MAP_WIDTH + cam_tile_x];
            const unsigned char *tiles_row = &tiles[in_tile_y];

            for (unsigned char bx = 0; bx < view_tiles_x; bx++) {
                unsigned char t0 = map_row[bx];
                if (t0) {
                    row[bx] = tiles_row[(t0 << 3)];
                } else {
                    row[bx] = 0;
                }
            }

            in_tile_y++;
            if (in_tile_y == 8) {
                in_tile_y = 0;
                tile_y++;
            }
        }
    } else {
        // Shifted path: blend two tiles (optimized)
        unsigned char shift = in_tile_x;
        unsigned char rshift = (unsigned char)(8 - shift);
        int next_tile_x = cam_tile_x + 1;

        for (int py = 0; py < (int)(view_tiles_y * 8); py++) {
            unsigned char *row = zx_pxy2saddr(view_offset_x, (unsigned char)(view_offset_y + py));
            unsigned char *map_row = &map_data[tile_y * MAP_WIDTH + cam_tile_x];
            const unsigned char *tiles_row = &tiles[in_tile_y];

            // Unrolled inner loop for 16 tiles
            unsigned char t0 = map_row[0];
            unsigned char t1 = (next_tile_x < MAP_WIDTH) ? map_row[1] : 0;
            row[0] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[1];
            t1 = (next_tile_x + 1 < MAP_WIDTH) ? map_row[2] : 0;
            row[1] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[2];
            t1 = (next_tile_x + 2 < MAP_WIDTH) ? map_row[3] : 0;
            row[2] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[3];
            t1 = (next_tile_x + 3 < MAP_WIDTH) ? map_row[4] : 0;
            row[3] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[4];
            t1 = (next_tile_x + 4 < MAP_WIDTH) ? map_row[5] : 0;
            row[4] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[5];
            t1 = (next_tile_x + 5 < MAP_WIDTH) ? map_row[6] : 0;
            row[5] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[6];
            t1 = (next_tile_x + 6 < MAP_WIDTH) ? map_row[7] : 0;
            row[6] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[7];
            t1 = (next_tile_x + 7 < MAP_WIDTH) ? map_row[8] : 0;
            row[7] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[8];
            t1 = (next_tile_x + 8 < MAP_WIDTH) ? map_row[9] : 0;
            row[8] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[9];
            t1 = (next_tile_x + 9 < MAP_WIDTH) ? map_row[10] : 0;
            row[9] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[10];
            t1 = (next_tile_x + 10 < MAP_WIDTH) ? map_row[11] : 0;
            row[10] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[11];
            t1 = (next_tile_x + 11 < MAP_WIDTH) ? map_row[12] : 0;
            row[11] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[12];
            t1 = (next_tile_x + 12 < MAP_WIDTH) ? map_row[13] : 0;
            row[12] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[13];
            t1 = (next_tile_x + 13 < MAP_WIDTH) ? map_row[14] : 0;
            row[13] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[14];
            t1 = (next_tile_x + 14 < MAP_WIDTH) ? map_row[15] : 0;
            row[14] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            t0 = map_row[15];
            t1 = (next_tile_x + 15 < MAP_WIDTH) ? map_row[16] : 0;
            row[15] = (unsigned char)((tiles_row[(t0 << 3)] << shift) | (tiles_row[(t1 << 3)] >> rshift));

            in_tile_y++;
            if (in_tile_y == 8) {
                in_tile_y = 0;
                tile_y++;
            }
        }
    }
}

int main(void) {
    // Set up the display
    zx_border(INK_BLACK);
    zx_cls(PAPER_WHITE | INK_BLACK);

    init_map();

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

        if (input_active) {
            zx_border(INK_RED);
        } else {
            zx_border(INK_BLACK);
        }

        int prev_x = camera_x;
        int prev_y = camera_y;

        camera_x += dx;
        camera_y += dy;

        if (camera_x < 0) {
            camera_x = 0;
        }
        if (camera_y < 0) {
            camera_y = 0;
        }

        int visible_tiles_x = 16 + ((camera_x & 7) ? 1 : 0);
        int visible_tiles_y = 16 + ((camera_y & 7) ? 1 : 0);
        int max_x = (MAP_WIDTH - visible_tiles_x) * TILE_WIDTH;
        int max_y = (MAP_HEIGHT - visible_tiles_y) * TILE_HEIGHT;

        if (camera_x > max_x) {
            camera_x = max_x;
        }
        if (camera_y > max_y) {
            camera_y = max_y;
        }

        // Debug: show max_x low bits when left/right input detected
        if (dx != 0) {
            zx_border((unsigned char)(max_x & 0x07));
            for (volatile unsigned int i = 0; i < 1000; i++) {}
            zx_border(INK_BLACK);
        }

        // Debug: show visible_tiles_x low bits when left/right input detected
        if (dx != 0) {
            zx_border((unsigned char)(visible_tiles_x & 0x07));
            for (volatile unsigned int i = 0; i < 1000; i++) {}
            zx_border(INK_BLACK);
        }

        // Debug: force draw every frame to test draw routine
        draw_map();
    }
}