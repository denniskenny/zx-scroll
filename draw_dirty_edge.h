#ifndef DRAW_DIRTY_EDGE_H
#define DRAW_DIRTY_EDGE_H

// Dirty-edge scrolling system for 30x8 character viewport (240x64 pixels)
// Uses hybrid 2D ring-buffer: vertical (head_row) + horizontal (head_col + fine_x)
// Centered on ZX Spectrum screen at row 8 (Y=64 to Y=127)

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

// Master viewport parameters - change these to resize the viewport
#define VIEWPORT_COLS           20   // visible columns (must be <= 32)
#define VIEWPORT_CHAR_ROWS      16   // visible character rows (height in 8-pixel rows)
#define VIEWPORT_START_CHAR_ROW 8    // screen char row where viewport starts
#define VIEWPORT_COL_OFFSET     6    // screen byte offset from left edge

// Derived viewport dimensions (do not change these directly)
#define DIRTY_VIEWPORT_WIDTH    VIEWPORT_COLS
#define DIRTY_VIEWPORT_WIDTH_BYTES (VIEWPORT_COLS + 1) // +1 lookahead for fine_x
#define DIRTY_VIEWPORT_HEIGHT   VIEWPORT_CHAR_ROWS
#define DIRTY_VIEWPORT_WIDTH_PX  (VIEWPORT_COLS * 8)
#define DIRTY_VIEWPORT_HEIGHT_PX (VIEWPORT_CHAR_ROWS * 8)

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


// Dixel (2-pixel) direct-to-screen scroll routines (dixel_scroll.asm)
void dixel_shift_right(void);
void dixel_shift_left(void);
void dixel_wait_vblank(void);
void dixel_init_sync(void);

#endif // DRAW_DIRTY_EDGE_H
