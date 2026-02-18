#include "draw_dirty_edge.h"

static void scroll_x_plus_ring(unsigned char *buffer, unsigned char head_row, unsigned char *head_col,
                               unsigned char *fine_x, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width);
static void scroll_x_minus_ring(unsigned char *buffer, unsigned char head_row, unsigned char *head_col,
                                unsigned char *fine_x, const unsigned char *map_data,
                                const unsigned char *tiles, int camera_x, int camera_y, int map_width);
static void scroll_y_plus_ring(unsigned char *buffer, unsigned char *head_row, unsigned char head_col,
                               unsigned char fine_x, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width);
static void scroll_y_minus_ring(unsigned char *buffer, unsigned char *head_row, unsigned char head_col,
                                unsigned char fine_x, const unsigned char *map_data,
                                const unsigned char *tiles, int camera_x, int camera_y, int map_width);

// Unified scroll handler with stride support
unsigned char dirty_edge_scroll(
    unsigned char direction,
    const unsigned char *map_data,
    const unsigned char *tiles,
    unsigned char *buffer,
    unsigned char *head_row,
    unsigned char *head_col,
    unsigned char *fine_x,
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
    unsigned char h_row = *head_row;
    unsigned char h_col = *head_col;
    unsigned char f_x = *fine_x;
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
    
    // Two-pass approach: do ALL Y scrolls first (consistent fine_x for all scanlines),
    // then ALL X scrolls. This prevents chessboard artifacts from mixed fine_x values.
    
    // Pass 1: Y scrolls (all stride iterations)
    if (has_y) {
        int ty = cy;
        for (i = 0; i < max_stride; i++) {
            if (direction & SCROLL_Y_PLUS) {
                if (ty >= (map_height * 8) - DIRTY_VIEWPORT_HEIGHT_PX) break;
                ty++;
                scroll_y_plus_ring(buffer, &h_row, h_col, f_x, map_data, tiles, cx, ty, map_width);
            }
            if (direction & SCROLL_Y_MINUS) {
                if (ty <= 0) break;
                ty--;
                scroll_y_minus_ring(buffer, &h_row, h_col, f_x, map_data, tiles, cx, ty, map_width);
            }
        }
        cy = ty;
    }
    
    // Pass 2: X scrolls (all stride iterations)
    if (has_x) {
        int tx = cx;
        for (i = 0; i < max_stride; i++) {
            if (direction & SCROLL_X_PLUS) {
                if (tx >= (map_width * 8) - DIRTY_VIEWPORT_WIDTH_PX) break;
                tx++;
                scroll_x_plus_ring(buffer, h_row, &h_col, &f_x, map_data, tiles, tx, cy, map_width);
            }
            if (direction & SCROLL_X_MINUS) {
                if (tx <= 0) break;
                tx--;
                scroll_x_minus_ring(buffer, h_row, &h_col, &f_x, map_data, tiles, tx, cy, map_width);
            }
        }
        cx = tx;
    }
    
    if (cx == *camera_x && cy == *camera_y) return 0;  // No scrolling happened
    
    *camera_x = cx;
    *camera_y = cy;
    *head_row = h_row;
    *head_col = h_col;
    *fine_x = f_x;
    return 1;
}

// Draw a full byte column at a specific buffer column for a given pixel X position.
// Used by horizontal ring-buffer to fill edge bytes and lookahead bytes.
static void draw_byte_column(unsigned char *buffer, const unsigned char *map_data,
                             const unsigned char *tiles, int pixel_x, int camera_y, int map_width,
                             unsigned char head_row, unsigned char buf_col) {
    int tile_x = pixel_x >> 3;
    unsigned char in_tile_x = pixel_x & 7;
    
    // Clamp to map bounds and adjust in_tile_x if we're beyond the map
    if (tile_x < 0) {
        tile_x = 0;
        in_tile_x = 0;
    }
    if (tile_x >= map_width) {
        tile_x = map_width - 1;
        in_tile_x = 0;  // At map edge, use byte-aligned position
    }
    
    int tile_y = camera_y >> 3;
    if (tile_y < 0) tile_y = 0;
    unsigned char in_tile_y = camera_y & 7;
    
    unsigned char row_index = head_row;
    unsigned char *row_ptr = buffer + ((unsigned int)row_index * 33) + buf_col;
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    int current_tile_y = tile_y;
    for (int py = 0; py < DIRTY_VIEWPORT_HEIGHT_PX; py++) {
        if (in_tile_x == 0) {
            unsigned char tile_idx = *map_ptr;
            *row_ptr = tiles[tile_idx * 8 + in_tile_y];
        } else {
            unsigned char left_tile = *map_ptr;
            unsigned char right_tile = (tile_x + 1 < map_width) ? map_ptr[1] : left_tile;
            unsigned char left_byte = tiles[left_tile * 8 + in_tile_y];
            unsigned char right_byte = tiles[right_tile * 8 + in_tile_y];
            *row_ptr = (left_byte << in_tile_x) | (right_byte >> (8 - in_tile_x));
        }
        
        if (++in_tile_y == 8) {
            in_tile_y = 0;
            current_tile_y++;
            if (current_tile_y < 48) {
                map_ptr += map_width;
            }
        }

        if (++row_index == DIRTY_VIEWPORT_HEIGHT_PX) {
            row_index = 0;
            row_ptr = buffer + buf_col;
        } else {
            row_ptr += 33;
        }
    }
}

// Draw bottom edge: bottom scanline (33 bytes: 32 visible + 1 lookahead)
// Buffer stores byte-aligned tile data; the blitter handles fine_x sub-pixel shifting.
static void draw_edge_bottom_c(unsigned char *buffer, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width,
                               unsigned char head_row, unsigned char head_col, unsigned char fine_x) {
    // Bottom pixel Y = camera_y + (DIRTY_VIEWPORT_HEIGHT_PX - 1)
    int bottom_y = camera_y + (DIRTY_VIEWPORT_HEIGHT_PX - 1);
    int tile_y = bottom_y >> 3;
    if (tile_y < 0) tile_y = 0;
    unsigned char in_tile_y = bottom_y & 7;
    
    // Byte-aligned base: (camera_x - fine_x) gives the pixel X of buffer column head_col
    int base_x = camera_x - fine_x;
    int tile_x = base_x >> 3;
    if (tile_x < 0) tile_x = 0;
    
    unsigned char bottom_row = head_row + (DIRTY_VIEWPORT_HEIGHT_PX - 1);
    if (bottom_row >= DIRTY_VIEWPORT_HEIGHT_PX) bottom_row -= DIRTY_VIEWPORT_HEIGHT_PX;
    unsigned char *row_ptr = buffer + ((unsigned int)bottom_row * 33);
    const unsigned char *map_ptr = &map_data[tile_y * map_width + tile_x];
    
    // Draw 33 bytes (32 visible + 1 lookahead) with column wrapping via head_col
    for (unsigned char col = 0; col < 33; col++) {
        unsigned char buf_col = head_col + col;
        if (buf_col >= DIRTY_VIEWPORT_WIDTH_BYTES) buf_col -= DIRTY_VIEWPORT_WIDTH_BYTES;
        
        int src_tile = tile_x + col;
        if (src_tile >= map_width) src_tile = map_width - 1;
        unsigned char tile_idx = map_data[tile_y * map_width + src_tile];
        row_ptr[buf_col] = tiles[tile_idx * 8 + in_tile_y];
    }
}

// Draw top edge: top scanline (33 bytes: 32 visible + 1 lookahead)
// Buffer stores byte-aligned tile data; the blitter handles fine_x sub-pixel shifting.
static void draw_edge_top_c(unsigned char *buffer, const unsigned char *map_data,
                            const unsigned char *tiles, int camera_x, int camera_y, int map_width,
                            unsigned char head_row, unsigned char head_col, unsigned char fine_x) {
    int tile_y = camera_y >> 3;
    if (tile_y < 0) tile_y = 0;
    unsigned char in_tile_y = camera_y & 7;
    
    // Byte-aligned base: (camera_x - fine_x) gives the pixel X of buffer column head_col
    int base_x = camera_x - fine_x;
    int tile_x = base_x >> 3;
    if (tile_x < 0) tile_x = 0;
    
    unsigned char *row_ptr = buffer + ((unsigned int)head_row * 33);
    
    // Draw 33 bytes (32 visible + 1 lookahead) with column wrapping via head_col
    for (unsigned char col = 0; col < 33; col++) {
        unsigned char buf_col = head_col + col;
        if (buf_col >= DIRTY_VIEWPORT_WIDTH_BYTES) buf_col -= DIRTY_VIEWPORT_WIDTH_BYTES;
        
        int src_tile = tile_x + col;
        if (src_tile >= map_width) src_tile = map_width - 1;
        unsigned char tile_idx = map_data[tile_y * map_width + src_tile];
        row_ptr[buf_col] = tiles[tile_idx * 8 + in_tile_y];
    }
}

static void scroll_x_plus_ring(unsigned char *buffer, unsigned char head_row, unsigned char *head_col,
                               unsigned char *fine_x, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    // Hybrid: increment fine_x. When it wraps past 7, advance head_col and draw new edge bytes.
    // No buffer changes needed per-pixel - the blitter handles fine_x shifting on output.
    unsigned char fx = *fine_x;
    fx++;
    if (fx == 8) {
        fx = 0;
        // Advance head_col: the leftmost byte has scrolled fully out of view
        unsigned char h = *head_col;
        h++;
        if (h == DIRTY_VIEWPORT_WIDTH_BYTES) h = 0;
        *head_col = h;

        // Byte-aligned pixel X for the leftmost visible byte
        int base_x = camera_x & ~7;

        // Draw the new rightmost visible byte (column 31 from head_col)
        unsigned char col31 = h + 31;
        if (col31 >= DIRTY_VIEWPORT_WIDTH_BYTES) col31 -= DIRTY_VIEWPORT_WIDTH_BYTES;
        draw_byte_column(buffer, map_data, tiles, base_x + 31*8, camera_y, map_width, head_row, col31);

        // Draw the lookahead byte (column 32 from head_col) for fine_x blending
        unsigned char col32 = h + 32;
        if (col32 >= DIRTY_VIEWPORT_WIDTH_BYTES) col32 -= DIRTY_VIEWPORT_WIDTH_BYTES;
        draw_byte_column(buffer, map_data, tiles, base_x + 32*8, camera_y, map_width, head_row, col32);
    }
    *fine_x = fx;
}

static void scroll_x_minus_ring(unsigned char *buffer, unsigned char head_row, unsigned char *head_col,
                                unsigned char *fine_x, const unsigned char *map_data,
                                const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    // Hybrid: decrement fine_x. When it wraps below 0, retreat head_col and draw new edge byte.
    unsigned char fx = *fine_x;
    if (fx == 0) {
        fx = 7;
        // Retreat head_col: the rightmost byte has scrolled fully out of view
        unsigned char h = *head_col;
        if (h == 0) h = DIRTY_VIEWPORT_WIDTH_BYTES;
        h--;
        *head_col = h;

        // Byte-aligned pixel X for the buffer
        // camera_x was already decremented by 1, fine_x is now 7
        // base_x = (camera_x - fine_x) = camera_x - 7, but we need byte-aligned:
        // Actually: base_x should be (camera_x & ~7) since that's the byte boundary
        // But camera_x was decremented, so camera_x & ~7 gives the new byte-aligned base
        int base_x = camera_x & ~7;

        // Draw the new leftmost visible byte (column head_col)
        draw_byte_column(buffer, map_data, tiles, base_x, camera_y, map_width, head_row, h);
    } else {
        fx--;
    }
    *fine_x = fx;
}

static void scroll_y_plus_ring(unsigned char *buffer, unsigned char *head_row, unsigned char head_col,
                               unsigned char fine_x, const unsigned char *map_data,
                               const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    unsigned char h = *head_row;
    h++;
    if (h == DIRTY_VIEWPORT_HEIGHT_PX) h = 0;
    *head_row = h;
    draw_edge_bottom_c(buffer, map_data, tiles, camera_x, camera_y, map_width, h, head_col, fine_x);
}

static void scroll_y_minus_ring(unsigned char *buffer, unsigned char *head_row, unsigned char head_col,
                                unsigned char fine_x, const unsigned char *map_data,
                                const unsigned char *tiles, int camera_x, int camera_y, int map_width) {
    unsigned char h = *head_row;
    if (h == 0) h = DIRTY_VIEWPORT_HEIGHT_PX;
    h--;
    *head_row = h;
    draw_edge_top_c(buffer, map_data, tiles, camera_x, camera_y, map_width, h, head_col, fine_x);
}
