#include "draw_dirty_edge.h"
#include <string.h>

// External assembly functions for fast drawing
extern void draw_aligned_asm(unsigned char *row, unsigned char *map_row, 
                             const unsigned char *tiles_base, unsigned char in_tile_y);
extern void draw_shifted_asm(unsigned char *row, unsigned char *map_row, 
                             const unsigned char *tiles_row, unsigned char shift);

// 32-column drawing functions (defined in draw_dirty_edge.asm)
extern void draw_aligned_32col_asm(unsigned char *row, unsigned char *map_row,
                                   const unsigned char *tiles, unsigned char in_tile_y);
extern void draw_shifted_32col_asm(unsigned char *row, unsigned char *map_row,
                                   const unsigned char *tiles, unsigned char in_tile_y,
                                   unsigned char shift);

void dirty_edge_init(void) {
    // Nothing to initialize currently - state is implicit in camera position
}

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
    int *camera_x,
    int *camera_y,
    int map_width,
    int map_height,
    unsigned char stride
) {
    int cx = *camera_x;
    int cy = *camera_y;
    unsigned char i;
    
    if (stride == 0) stride = 1;
    
    // Perform stride iterations of single-pixel scrolls
    for (i = 0; i < stride; i++) {
        // Check bounds for this iteration
        if (direction & SCROLL_X_PLUS) {
            if (cx >= (map_width * 8) - DIRTY_VIEWPORT_WIDTH_PX) break;
            cx++;
        }
        if (direction & SCROLL_X_MINUS) {
            if (cx <= 0) break;
            cx--;
        }
        if (direction & SCROLL_Y_PLUS) {
            if (cy >= (map_height * 8) - DIRTY_VIEWPORT_HEIGHT_PX) break;
            cy++;
        }
        if (direction & SCROLL_Y_MINUS) {
            if (cy <= 0) break;
            cy--;
        }
        
        // Apply the scroll operations
        if (direction & SCROLL_X_PLUS) {
            scroll_x_plus(buffer, map_data, tiles, cx, cy, map_width);
        }
        if (direction & SCROLL_X_MINUS) {
            scroll_x_minus(buffer, map_data, tiles, cx, cy, map_width);
        }
        if (direction & SCROLL_Y_PLUS) {
            scroll_y_plus(buffer, map_data, tiles, cx, cy, map_width);
        }
        if (direction & SCROLL_Y_MINUS) {
            scroll_y_minus(buffer, map_data, tiles, cx, cy, map_width);
        }
    }
    
    if (i == 0) return 0;  // No scrolling happened
    
    *camera_x = cx;
    *camera_y = cy;
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
                              const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    int right_pixel_x = camera_x + 255;
    int tile_x = right_pixel_x >> 3;
    unsigned char in_tile_x = right_pixel_x & 7;
    
    int tile_y = camera_y >> 3;
    unsigned char in_tile_y = camera_y & 7;
    
    unsigned char *row_ptr = buffer + 31;
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    for (int py = 0; py < DIRTY_VIEWPORT_HEIGHT_PX; py++) {
        unsigned char tile_idx = *map_ptr;
        unsigned char pixel = get_tile_pixel(tiles, tile_idx, in_tile_x, in_tile_y);
        
        if (pixel)
            *row_ptr |= 0x01;
        else
            *row_ptr &= 0xFE;
        
        if (++in_tile_y == 8) {
            in_tile_y = 0;
            map_ptr += map_width;
        }
        row_ptr += 32;
    }
}

// Draw left edge: leftmost pixel column (bit 7 of byte 0 in each row)
static void draw_edge_left_c(unsigned char *buffer, const unsigned char *map_data,
                             const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    int tile_x = camera_x >> 3;
    unsigned char in_tile_x = camera_x & 7;
    
    int tile_y = camera_y >> 3;
    unsigned char in_tile_y = camera_y & 7;
    
    unsigned char *row_ptr = buffer;  // Leftmost byte of each row
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    unsigned char py = DIRTY_VIEWPORT_HEIGHT_PX;
    do {
        unsigned char tile_idx = *map_ptr;
        unsigned char pixel = get_tile_pixel(tiles, tile_idx, in_tile_x, in_tile_y);
        
        // Set or clear bit 7 of leftmost byte
        if (pixel)
            *row_ptr |= 0x80;
        else
            *row_ptr &= 0x7F;
        
        if (++in_tile_y == 8) {
            in_tile_y = 0;
            map_ptr += map_width;
        }
        row_ptr += 32;
    } while (--py);
}

// Draw bottom edge: bottom scanline (row DIRTY_VIEWPORT_HEIGHT_PX-1, 32 bytes)
static void draw_edge_bottom_c(unsigned char *buffer, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    // Bottom pixel Y = camera_y + (DIRTY_VIEWPORT_HEIGHT_PX - 1)
    int bottom_y = camera_y + (DIRTY_VIEWPORT_HEIGHT_PX - 1);
    int tile_y = bottom_y >> 3;
    unsigned char in_tile_y = bottom_y & 7;
    int tile_x = camera_x >> 3;
    unsigned char in_tile_x = camera_x & 7;
    
    unsigned char *row_ptr = buffer + ((DIRTY_VIEWPORT_HEIGHT_PX - 1) * 32);  // Last row
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    // Draw 32 bytes (one scanline) using C loop
    for (unsigned char col = 0; col < 32; col++) {
        unsigned char tile_idx = map_ptr[col + (in_tile_x ? 1 : 0)];
        unsigned char prev_tile = col > 0 ? map_ptr[col - 1 + (in_tile_x ? 1 : 0)] : map_ptr[col];
        
        if (in_tile_x == 0) {
            // Aligned: just get the byte directly
            tile_idx = map_ptr[col];
            row_ptr[col] = tiles[tile_idx * 8 + in_tile_y];
        } else {
            // Shifted: blend two tiles
            unsigned char left_tile = map_ptr[col];
            unsigned char right_tile = map_ptr[col + 1];
            unsigned char left_byte = tiles[left_tile * 8 + in_tile_y];
            unsigned char right_byte = tiles[right_tile * 8 + in_tile_y];
            row_ptr[col] = (left_byte << in_tile_x) | (right_byte >> (8 - in_tile_x));
        }
    }
}

// Draw top edge: top scanline (row 0, 32 bytes)
static void draw_edge_top_c(unsigned char *buffer, const unsigned char *map_data,
                            const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    int tile_y = camera_y >> 3;
    unsigned char in_tile_y = camera_y & 7;
    int tile_x = camera_x >> 3;
    unsigned char in_tile_x = camera_x & 7;
    
    unsigned char *row_ptr = buffer;  // Row 0
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    // Draw 32 bytes (one scanline) using C loop
    for (unsigned char col = 0; col < 32; col++) {
        if (in_tile_x == 0) {
            unsigned char tile_idx = map_ptr[col];
            row_ptr[col] = tiles[tile_idx * 8 + in_tile_y];
        } else {
            unsigned char left_tile = map_ptr[col];
            unsigned char right_tile = map_ptr[col + 1];
            unsigned char left_byte = tiles[left_tile * 8 + in_tile_y];
            unsigned char right_byte = tiles[right_tile * 8 + in_tile_y];
            row_ptr[col] = (left_byte << in_tile_x) | (right_byte >> (8 - in_tile_x));
        }
    }
}

// C implementation of shift left
static void shift_buffer_left_1px_c(unsigned char *buffer) {
    unsigned char *rowptr = buffer;
    for (int row = 0; row < DIRTY_VIEWPORT_HEIGHT_PX; row++) {
        unsigned char carry = 0;
        for (int col = 31; col >= 0; col--) {
            unsigned char newcarry = rowptr[col] >> 7;
            rowptr[col] = (rowptr[col] << 1) | carry;
            carry = newcarry;
        }
        rowptr += 32;
    }
}

// C implementation of shift right
static void shift_buffer_right_1px_c(unsigned char *buffer) {
    unsigned char *rowptr = buffer;
    for (int row = 0; row < DIRTY_VIEWPORT_HEIGHT_PX; row++) {
        unsigned char carry = 0;
        for (int col = 0; col < 32; col++) {
            unsigned char newcarry = rowptr[col] & 1;
            rowptr[col] = (rowptr[col] >> 1) | (carry << 7);
            carry = newcarry;
        }
        rowptr += 32;
    }
}

// Scroll right (+X): shift buffer left, draw right edge
void scroll_x_plus(unsigned char *buffer, const unsigned char *map_data,
                   const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    shift_buffer_left_1px(buffer);  // Assembly version
    draw_edge_right_c(buffer, map_data, tiles, camera_x, camera_y, map_width);
}

// Scroll left (-X): shift buffer right, draw left edge  
void scroll_x_minus(unsigned char *buffer, const unsigned char *map_data,
                    const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    shift_buffer_right_1px(buffer);  // Assembly version
    draw_edge_left_c(buffer, map_data, tiles, camera_x, camera_y, map_width);
}

// Scroll down (+Y): shift buffer up, draw bottom edge
void scroll_y_plus(unsigned char *buffer, const unsigned char *map_data,
                   const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    shift_buffer_up_1row(buffer);
    draw_edge_bottom_c(buffer, map_data, tiles, camera_x, camera_y, map_width);
}

// Scroll up (-Y): shift buffer down, draw top edge
void scroll_y_minus(unsigned char *buffer, const unsigned char *map_data,
                    const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    shift_buffer_down_1row(buffer);
    draw_edge_top_c(buffer, map_data, tiles, camera_x, camera_y, map_width);
}
