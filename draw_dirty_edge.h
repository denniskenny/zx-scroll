#ifndef DRAW_DIRTY_EDGE_H
#define DRAW_DIRTY_EDGE_H

// Dirty-edge scrolling system for 32x16 character viewport (256x128 pixels)
// Centered on ZX Spectrum screen at row 4 (Y=32 to Y=159)

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
#define DIRTY_VIEWPORT_WIDTH    32   // columns (256 pixels)
#define DIRTY_VIEWPORT_HEIGHT   12   // rows (96 pixels)
#define DIRTY_VIEWPORT_WIDTH_PX  256
#define DIRTY_VIEWPORT_HEIGHT_PX 96
#define DIRTY_BUFFER_SIZE       3072 // 32 bytes * 96 scanlines

// Initialize the dirty-edge system (full redraw required after this)
void dirty_edge_init(void);

// Full redraw of viewport (call when camera jumps or on init)
void dirty_edge_full_redraw(
    const unsigned char *map_data,
    const unsigned char *tiles,
    unsigned char *buffer,
    int camera_x,
    int camera_y,
    int map_width
);

// Scroll by stride pixels in direction and draw only the new edges
// Returns 1 if scroll was applied, 0 if blocked (e.g., at map edge)
// stride_x: horizontal scroll speed (pixels per frame)
// stride_y: vertical scroll speed (pixels per frame)
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
);

// Assembly routines for fast buffer manipulation (1-pixel shifts)
extern void shift_buffer_left_1px(unsigned char *buffer);   // For x+1 scroll
extern void shift_buffer_right_1px(unsigned char *buffer);  // For x-1 scroll
extern void shift_buffer_up_1row(unsigned char *buffer);    // For y+1 scroll
extern void shift_buffer_down_1row(unsigned char *buffer);  // For y-1 scroll

// Parameterized row-count variants (used for ring-buffer segments)
extern void shift_buffer_left_1px_rows(unsigned char *buffer, unsigned char rows);
extern void shift_buffer_right_1px_rows(unsigned char *buffer, unsigned char rows);

// Dedicated 2px and 4px shift routines (faster than calling 1px multiple times)
extern void shift_buffer_left_2px(unsigned char *buffer);
extern void shift_buffer_right_2px(unsigned char *buffer);
extern void shift_buffer_left_4px(unsigned char *buffer);
extern void shift_buffer_right_4px(unsigned char *buffer);

// Fast 8-pixel scroll (byte-aligned, no bit shifts needed)
extern void shift_buffer_left_8px(unsigned char *buffer);   // For x+8 scroll
extern void shift_buffer_right_8px(unsigned char *buffer);  // For x-8 scroll
extern void shift_buffer_up_8rows(unsigned char *buffer);   // For y+8 scroll
extern void shift_buffer_down_8rows(unsigned char *buffer); // For y-8 scroll

// Copy the 32x16 viewport buffer to screen (centered)
extern void copy_viewport_32x16_to_screen(unsigned char *buffer);

#endif // DRAW_DIRTY_EDGE_H
