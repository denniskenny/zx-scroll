#ifndef DRAW_DIRTY_EDGE_H
#define DRAW_DIRTY_EDGE_H

// Dirty-edge scrolling system for 32x12 character viewport (256x96 pixels)
// Uses hybrid 2D ring-buffer: vertical (head_row) + horizontal (head_col + fine_x)
// Centered on ZX Spectrum screen at row 6 (Y=48 to Y=143)

// Direction flags for scroll operations
#define SCROLL_NONE     0x00
#define SCROLL_X_PLUS   0x01  // Right (+X)
#define SCROLL_X_MINUS  0x02  // Left (-X)
#define SCROLL_Y_PLUS   0x04  // Down (+Y)
#define SCROLL_Y_MINUS  0x08  // Up (-Y)

// Combined diagonal directions
#define SCROLL_X_PLUS_Y_PLUS    (SCROLL_X_PLUS | SCROLL_Y_PLUS)    // Right-Down
#define SCROLL_X_MINUS_Y_MINUS  (SCROLL_X_MINUS | SCROLL_Y_MINUS)  // Left-Up
#define SCROLL_X_PLUS_Y_MINUS   (SCROLL_X_PLUS | SCROLL_Y_MINUS)   // Right-Up
#define SCROLL_X_MINUS_Y_PLUS   (SCROLL_X_MINUS | SCROLL_Y_PLUS)   // Left-Down

// Viewport dimensions
#define DIRTY_VIEWPORT_WIDTH    32   // columns (256 pixels) - visible width
#define DIRTY_VIEWPORT_WIDTH_BYTES 33 // buffer width (32 visible + 1 for ring-buffer)
#define DIRTY_VIEWPORT_HEIGHT   12   // rows (96 pixels)
#define DIRTY_VIEWPORT_WIDTH_PX  256
#define DIRTY_VIEWPORT_HEIGHT_PX 96

// Scroll by stride pixels in direction and draw only the new edges
// Returns 1 if scroll was applied, 0 if blocked (e.g., at map edge)
// stride_x: horizontal scroll speed (pixels per frame)
// stride_y: vertical scroll speed (pixels per frame)
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
);


#endif // DRAW_DIRTY_EDGE_H
