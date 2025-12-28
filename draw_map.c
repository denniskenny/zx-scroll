#include "draw_map.h"
#include <string.h>

// External assembly functions for fast drawing
extern void draw_aligned_asm(unsigned char *row, unsigned char *map_row, const unsigned char *tiles_base, unsigned char in_tile_y);
extern void draw_shifted_asm(unsigned char *row, unsigned char *map_row, const unsigned char *tiles_row, unsigned char shift);

// Draw map to offscreen buffer with pixel-level scrolling
void draw_map(
    const unsigned char *map_data,
    const unsigned char *tiles,
    unsigned char *buffer,
    int camera_x,
    int camera_y,
    int map_width
) {
    int cam_tile_x = camera_x >> 3;
    unsigned char in_tile_x = (unsigned char)(camera_x & 7);

    int tile_y = camera_y >> 3;
    register unsigned char in_tile_y = (unsigned char)(camera_y & 7);

    register unsigned char *row_ptr = buffer;
    register unsigned char *map_ptr = (unsigned char *)&map_data[tile_y * map_width + cam_tile_x];
    register const unsigned char *tiles_base = tiles;
    int map_stride = map_width;

    if (in_tile_x == 0) {
        // Fast path: aligned (no blending needed)
        unsigned char py = 128;
        do {
            // Ultra-fast empty detection using bitwise OR
            if (!(map_ptr[0] | map_ptr[1] | map_ptr[2] | map_ptr[3] |
                  map_ptr[4] | map_ptr[5] | map_ptr[6] | map_ptr[7] |
                  map_ptr[8] | map_ptr[9] | map_ptr[10] | map_ptr[11] |
                  map_ptr[12] | map_ptr[13] | map_ptr[14] | map_ptr[15])) {
                // Row is empty: clear just this 16-byte scanline
                memset(row_ptr, 0, 16);
                goto next_row_aligned;
            }

            // Use assembly-optimized inner loop
            draw_aligned_asm(row_ptr, map_ptr, tiles_base, in_tile_y);

next_row_aligned:
            if (++in_tile_y == 8) {
                in_tile_y = 0;
                map_ptr += map_stride;
            }
            row_ptr += 16;
        } while (--py);
    } else {
        // Shifted path: blend two tiles using assembly
        register unsigned char shift = in_tile_x;

        unsigned char py = 128;
        do {
            // Compute tiles_row for this scanline
            const unsigned char *tiles_row = tiles_base + in_tile_y;
            
            if (!(map_ptr[0] | map_ptr[1] | map_ptr[2] | map_ptr[3] |
                  map_ptr[4] | map_ptr[5] | map_ptr[6] | map_ptr[7] |
                  map_ptr[8] | map_ptr[9] | map_ptr[10] | map_ptr[11] |
                  map_ptr[12] | map_ptr[13] | map_ptr[14] | map_ptr[15] |
                  map_ptr[16])) {
                memset(row_ptr, 0, 16);
                goto next_row_shifted;
            }
            
            // Use assembly-optimized shifted drawing
            draw_shifted_asm(row_ptr, map_ptr, tiles_row, shift);

next_row_shifted:
            if (++in_tile_y == 8) {
                in_tile_y = 0;
                map_ptr += map_stride;
            }
            row_ptr += 16;
        } while (--py);
    }
}
