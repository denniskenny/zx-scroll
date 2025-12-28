#ifndef DRAW_MAP_H
#define DRAW_MAP_H

#include <stdint.h>

// Draw map to offscreen buffer
// Parameters:
//   map_data    - Pointer to map tile indices
//   tiles       - Pointer to tile graphics data (8 bytes per tile)
//   buffer      - Pointer to output buffer (must be 256-byte aligned)
//   camera_x    - Camera X position in pixels
//   camera_y    - Camera Y position in pixels
//   map_width   - Width of map in tiles
void draw_map(
    const unsigned char *map_data,
    const unsigned char *tiles,
    unsigned char *buffer,
    int camera_x,
    int camera_y,
    int map_width
);

#endif // DRAW_MAP_H
