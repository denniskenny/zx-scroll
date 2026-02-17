#include "draw_dirty_edge.h"
#include <string.h>

void dirty_edge_init(void) {
    // Nothing to initialize currently - state is implicit in camera position
}

static void scroll_x_plus_ring(unsigned char *buffer, unsigned char head_row, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width);
static void scroll_x_minus_ring(unsigned char *buffer, unsigned char head_row, const unsigned char *map_data,
                                const unsigned char *tiles, int camera_x, int camera_y, int map_width);
static void scroll_y_plus_ring(unsigned char *buffer, unsigned char *head_row, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width);
static void scroll_y_minus_ring(unsigned char *buffer, unsigned char *head_row, const unsigned char *map_data,
                                const unsigned char *tiles, int camera_x, int camera_y, int map_width);

// Full redraw of the 32x12 viewport (256x96 pixels)
// NOTE: Using memset - scrolling fills in actual tiles
void dirty_edge_full_redraw(
    const unsigned char *map_data,
    const unsigned char *tiles,
    unsigned char *buffer,
    int camera_x,
    int camera_y,
    int map_width
) {
    memset(buffer, 0x00, DIRTY_BUFFER_SIZE);
}

// Unified scroll handler with stride support
unsigned char dirty_edge_scroll(
    unsigned char direction,
    const unsigned char *map_data,
    const unsigned char *tiles,
    unsigned char *buffer,
    unsigned char *head,
    int *camera_x,
    int *camera_y,
    int map_width,
    int map_height,
    unsigned char stride_x,
    unsigned char stride_y
) {
    int cx = *camera_x;
    int cy = *camera_y;
    unsigned char i;
    unsigned char h = *head;
    unsigned char max_stride;
    
    if (stride_x == 0) stride_x = 1;
    if (stride_y == 0) stride_y = 1;
    
    // Determine stride based on which directions are active
    // For diagonals, use minimum stride to keep X and Y synchronized
    unsigned char has_x = (direction & (SCROLL_X_PLUS | SCROLL_X_MINUS)) ? 1 : 0;
    unsigned char has_y = (direction & (SCROLL_Y_PLUS | SCROLL_Y_MINUS)) ? 1 : 0;
    
    if (has_x && has_y) {
        // Diagonal: use minimum stride to keep movements synchronized
        max_stride = (stride_x < stride_y) ? stride_x : stride_y;
    } else if (has_x) {
        // Pure horizontal
        max_stride = stride_x;
    } else if (has_y) {
        // Pure vertical
        max_stride = stride_y;
    } else {
        return 0;
    }
    
    // Perform stride iterations of single-pixel scrolls
    for (i = 0; i < max_stride; i++) {
        unsigned char active_dir = direction;
        
        // Check bounds and update camera position, masking out blocked directions
        if (active_dir & SCROLL_X_PLUS) {
            if (cx >= (map_width * 8) - DIRTY_VIEWPORT_WIDTH_PX) {
                active_dir &= ~SCROLL_X_PLUS;
            } else {
                cx++;
            }
        }
        if (active_dir & SCROLL_X_MINUS) {
            if (cx <= 0) {
                active_dir &= ~SCROLL_X_MINUS;
            } else {
                cx--;
            }
        }
        if (active_dir & SCROLL_Y_PLUS) {
            if (cy >= (map_height * 8) - DIRTY_VIEWPORT_HEIGHT_PX) {
                active_dir &= ~SCROLL_Y_PLUS;
            } else {
                cy++;
            }
        }
        if (active_dir & SCROLL_Y_MINUS) {
            if (cy <= 0) {
                active_dir &= ~SCROLL_Y_MINUS;
            } else {
                cy--;
            }
        }
        
        // If no valid direction remains, stop
        if (active_dir == SCROLL_NONE) break;
        
        // Apply the scroll operations for valid directions only
        if (active_dir & SCROLL_X_PLUS) {
            scroll_x_plus_ring(buffer, h, map_data, tiles, cx, cy, map_width);
        }
        if (active_dir & SCROLL_X_MINUS) {
            scroll_x_minus_ring(buffer, h, map_data, tiles, cx, cy, map_width);
        }
        if (active_dir & SCROLL_Y_PLUS) {
            scroll_y_plus_ring(buffer, &h, map_data, tiles, cx, cy, map_width);
        }
        if (active_dir & SCROLL_Y_MINUS) {
            scroll_y_minus_ring(buffer, &h, map_data, tiles, cx, cy, map_width);
        }
    }
    
    if (i == 0) return 0;  // No scrolling happened
    
    *camera_x = cx;
    *camera_y = cy;
    *head = h;
    return 1;
}

// Lookup table for pixel bitmasks - avoids (7-x) calculation and variable shifts
static const unsigned char pixel_mask[8] = {
    0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01
};

// Helper: get a single pixel from tile data
// Returns non-zero if pixel is set, 0 otherwise
// OPTIMIZED: Uses lookup table instead of variable shift
static unsigned char get_tile_pixel(const unsigned char *tiles, unsigned char tile_idx,
                                    unsigned char in_tile_x, unsigned char in_tile_y) {
    unsigned char tile_byte = tiles[(tile_idx << 3) + in_tile_y];
    return tile_byte & pixel_mask[in_tile_x];
}

// Draw right edge: rightmost pixel column (bit 0 of byte 31 in each row)
static void draw_edge_right_c(unsigned char *buffer, const unsigned char *map_data,
                              const unsigned char *tiles, int camera_x, int camera_y, int map_width,
                              unsigned char head_row) {
    // Right pixel X = camera_x + (DIRTY_VIEWPORT_WIDTH_PX - 1)
    int right_x = camera_x + (DIRTY_VIEWPORT_WIDTH_PX - 1);
    int tile_x = right_x >> 3;
    if (tile_x < 0) tile_x = 0;
    if (tile_x >= map_width) tile_x = map_width - 1;
    unsigned char in_tile_x = right_x & 7;
    
    int tile_y = camera_y >> 3;
    if (tile_y < 0) tile_y = 0;
    unsigned char in_tile_y = camera_y & 7;
    
    unsigned char row_index = head_row;
    unsigned char *row_ptr = buffer + ((unsigned int)row_index * 32) + 31;
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    int current_tile_y = tile_y;
    for (int py = 0; py < DIRTY_VIEWPORT_HEIGHT_PX; py++) {
        unsigned char tile_idx = *map_ptr;
        unsigned char pixel = get_tile_pixel(tiles, tile_idx, in_tile_x, in_tile_y);
        
        if (pixel)
            *row_ptr |= 0x01;
        else
            *row_ptr &= 0xFE;
        
        if (++in_tile_y == 8) {
            in_tile_y = 0;
            current_tile_y++;
            if (current_tile_y < 48) {
                map_ptr += map_width;
            }
        }

        if (++row_index == DIRTY_VIEWPORT_HEIGHT_PX) {
            row_index = 0;
            row_ptr = buffer + 31;
        } else {
            row_ptr += 32;
        }
    }
}

// Draw left edge: leftmost pixel column (bit 7 of byte 0 in each row)
static void draw_edge_left_c(unsigned char *buffer, const unsigned char *map_data,
                             const unsigned char *tiles, int camera_x, int camera_y, int map_width,
                             unsigned char head_row) {
    int tile_x = camera_x >> 3;
    if (tile_x < 0) tile_x = 0;
    if (tile_x >= map_width) tile_x = map_width - 1;
    unsigned char in_tile_x = camera_x & 7;
    
    int tile_y = camera_y >> 3;
    if (tile_y < 0) tile_y = 0;
    unsigned char in_tile_y = camera_y & 7;
    
    unsigned char row_index = head_row;
    unsigned char *row_ptr = buffer + ((unsigned int)row_index * 32);
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    int current_tile_y = tile_y;
    unsigned char py = DIRTY_VIEWPORT_HEIGHT_PX;
    do {
        unsigned char tile_idx = *map_ptr;
        unsigned char pixel = get_tile_pixel(tiles, tile_idx, in_tile_x, in_tile_y);
        
        if (pixel)
            *row_ptr |= 0x80;
        else
            *row_ptr &= 0x7F;
        
        if (++in_tile_y == 8) {
            in_tile_y = 0;
            current_tile_y++;
            if (current_tile_y < 48) {
                map_ptr += map_width;
            }
        }

        if (++row_index == DIRTY_VIEWPORT_HEIGHT_PX) {
            row_index = 0;
            row_ptr = buffer;
        } else {
            row_ptr += 32;
        }
    } while (--py);
}

// Draw bottom edge: bottom scanline (row DIRTY_VIEWPORT_HEIGHT_PX-1, 32 bytes)
static void draw_edge_bottom_c(unsigned char *buffer, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width,
                               unsigned char head_row) {
    // Bottom pixel Y = camera_y + (DIRTY_VIEWPORT_HEIGHT_PX - 1)
    int bottom_y = camera_y + (DIRTY_VIEWPORT_HEIGHT_PX - 1);
    int tile_y = bottom_y >> 3;
    if (tile_y < 0) tile_y = 0;
    unsigned char in_tile_y = bottom_y & 7;
    
    int tile_x = camera_x >> 3;
    if (tile_x < 0) tile_x = 0;
    if (tile_x >= map_width) tile_x = map_width - 1;
    unsigned char in_tile_x = camera_x & 7;
    
    unsigned char bottom_row = head_row + (DIRTY_VIEWPORT_HEIGHT_PX - 1);
    if (bottom_row >= DIRTY_VIEWPORT_HEIGHT_PX) bottom_row -= DIRTY_VIEWPORT_HEIGHT_PX;
    unsigned char *row_ptr = buffer + ((unsigned int)bottom_row * 32);
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    // Draw 32 bytes (one scanline) using C loop
    for (unsigned char col = 0; col < 32; col++) {
        if (in_tile_x == 0) {
            // Aligned: just get the byte directly
            unsigned char tile_idx = map_ptr[col];
            row_ptr[col] = tiles[tile_idx * 8 + in_tile_y];
        } else {
            // Shifted: blend two tiles
            unsigned char left_tile = map_ptr[col];
            unsigned char right_tile = (tile_x + (int)col + 1 < map_width) ? map_ptr[col + 1] : left_tile;
            unsigned char left_byte = tiles[left_tile * 8 + in_tile_y];
            unsigned char right_byte = tiles[right_tile * 8 + in_tile_y];
            row_ptr[col] = (left_byte << in_tile_x) | (right_byte >> (8 - in_tile_x));
        }
    }
}

// Draw top edge: top scanline (row 0, 32 bytes)
static void draw_edge_top_c(unsigned char *buffer, const unsigned char *map_data,
                            const unsigned char *tiles, int camera_x, int camera_y, int map_width,
                            unsigned char head_row) {
    int tile_x = camera_x >> 3;
    if (tile_x < 0) tile_x = 0;
    if (tile_x >= map_width) tile_x = map_width - 1;
    unsigned char in_tile_x = camera_x & 7;
    
    int tile_y = camera_y >> 3;
    if (tile_y < 0) tile_y = 0;
    unsigned char in_tile_y = camera_y & 7;
    
    unsigned char *row_ptr = buffer + ((unsigned int)head_row * 32);
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    // Draw 32 bytes (one scanline) using C loop
    for (unsigned char col = 0; col < 32; col++) {
        if (in_tile_x == 0) {
            unsigned char tile_idx = map_ptr[col];
            row_ptr[col] = tiles[tile_idx * 8 + in_tile_y];
        } else {
            unsigned char left_tile = map_ptr[col];
            unsigned char right_tile = (tile_x + (int)col + 1 < map_width) ? map_ptr[col + 1] : left_tile;
            unsigned char left_byte = tiles[left_tile * 8 + in_tile_y];
            unsigned char right_byte = tiles[right_tile * 8 + in_tile_y];
            row_ptr[col] = (left_byte << in_tile_x) | (right_byte >> (8 - in_tile_x));
        }
    }
}

static void scroll_x_plus_ring(unsigned char *buffer, unsigned char head_row, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    shift_buffer_left_1px(buffer);
    draw_edge_right_c(buffer, map_data, tiles, camera_x, camera_y, map_width, head_row);
}

static void scroll_x_minus_ring(unsigned char *buffer, unsigned char head_row, const unsigned char *map_data,
                                const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    shift_buffer_right_1px(buffer);
    draw_edge_left_c(buffer, map_data, tiles, camera_x, camera_y, map_width, head_row);
}

static void scroll_y_plus_ring(unsigned char *buffer, unsigned char *head_row, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    (void)buffer;
    unsigned char h = *head_row;
    h++;
    if (h == DIRTY_VIEWPORT_HEIGHT_PX) h = 0;
    *head_row = h;
    draw_edge_bottom_c(buffer, map_data, tiles, camera_x, camera_y, map_width, h);
}

static void scroll_y_minus_ring(unsigned char *buffer, unsigned char *head_row, const unsigned char *map_data,
                                const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    (void)buffer;
    unsigned char h = *head_row;
    if (h == 0) h = DIRTY_VIEWPORT_HEIGHT_PX;
    h--;
    *head_row = h;
    draw_edge_top_c(buffer, map_data, tiles, camera_x, camera_y, map_width, h);
}
