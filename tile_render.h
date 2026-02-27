#ifndef TILE_RENDER_H
#define TILE_RENDER_H

// Direct-to-screen tile renderer — Race the Beam
// LDIR shift + dirty edge: shift viewport, then draw 1 new column/row.
//
// Viewport: 20 cols × 16 char rows at Y=64..191 (char rows 8-23)
// Tiles: ≤32 unique, page-aligned at 0x6000

// Viewport parameters
#define VIEWPORT_COLS           20
#define VIEWPORT_CHAR_ROWS      16
#define VIEWPORT_START_CHAR_ROW 8
#define VIEWPORT_COL_OFFSET     6

#define VIEWPORT_WIDTH_PX       (VIEWPORT_COLS * 8)
#define VIEWPORT_HEIGHT_PX      (VIEWPORT_CHAR_ROWS * 8)

// Map dimensions
#define MAP_WIDTH  96
#define MAP_HEIGHT 48

// Assembly routines (tile_render_direct.asm)
// screen_col: physical screen byte offset (VIEWPORT_COL_OFFSET + physical_col)
// map_col_ptr: &map_data[tile_row * MAP_WIDTH + tile_col]
void render_dirty_column(unsigned char screen_col, const unsigned char *map_col_ptr);

// viewport_char_row: 0-15 (row within viewport)
// map_row_ptr: &map_data[tile_row * MAP_WIDTH + tile_col]
void render_dirty_row(unsigned char viewport_char_row, const unsigned char *map_row_ptr);

// map_top_left: &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x]
void render_full_viewport(const unsigned char *map_top_left);

// LDIR-based viewport shift routines (~49kT horizontal, ~68-71kT vertical)
void shift_viewport_left(void);   // for scroll right: cols 1..19 → 0..18
void shift_viewport_right(void);  // for scroll left:  cols 0..18 → 1..19
void shift_viewport_up(void);     // for scroll down:  rows 1..15 → 0..14
void shift_viewport_down(void);   // for scroll up:    rows 0..14 → 1..15

#endif // TILE_RENDER_H
