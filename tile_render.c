#include <input.h>
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>
#include "tile_render.h"

extern const unsigned char tiles[];
extern unsigned char map_data[];
extern const unsigned char hud_scr[];

// Camera state (in tile units, 8px per tile)
static int camera_tile_x = 0;
static int camera_tile_y = 0;
static int prev_tile_x = 0;
static int prev_tile_y = 0;

// Scroll throttle: only scroll every N frames for smooth feel
#define SCROLL_INTERVAL 3
static unsigned char frame_count = 0;

// Input reader (keyboard + Kempston joystick)
static unsigned char read_input(void) {
    unsigned char dir = 0;

    // Keyboard
    if (in_key_pressed(IN_KEY_SCANCODE_q)) dir |= 0x08;  // up
    if (in_key_pressed(IN_KEY_SCANCODE_a)) dir |= 0x04;  // down
    if (in_key_pressed(IN_KEY_SCANCODE_o)) dir |= 0x02;  // left
    if (in_key_pressed(IN_KEY_SCANCODE_p)) dir |= 0x01;  // right

    if (dir) return dir;

    // Kempston joystick fallback
    {
        uint16_t joy = in_stick_kempston();
        if (joy & IN_STICK_UP)    dir |= 0x08;
        if (joy & IN_STICK_DOWN)  dir |= 0x04;
        if (joy & IN_STICK_LEFT)  dir |= 0x02;
        if (joy & IN_STICK_RIGHT) dir |= 0x01;
    }

    return dir;
}

// Update camera based on input direction
// Returns nonzero if camera moved
static unsigned char update_camera(unsigned char input) {
    int max_x = MAP_WIDTH - VIEWPORT_COLS;
    int max_y = MAP_HEIGHT - VIEWPORT_CHAR_ROWS;

    prev_tile_x = camera_tile_x;
    prev_tile_y = camera_tile_y;

    if ((input & 0x01) && camera_tile_x < max_x) camera_tile_x++;  // right
    if ((input & 0x02) && camera_tile_x > 0)      camera_tile_x--;  // left
    if ((input & 0x04) && camera_tile_y < max_y)  camera_tile_y++;  // down
    if ((input & 0x08) && camera_tile_y > 0)       camera_tile_y--;  // up

    return (camera_tile_x != prev_tile_x) || (camera_tile_y != prev_tile_y);
}

// Scroll handlers: LDIR shift + dirty edge draw.
// Horizontal: ~49kT shift + ~6.4kT column = ~55kT (< 1 frame, tear-free)
// Vertical:   ~68kT shift + ~10.6kT row   = ~79kT (~1.1 frames)
// Diagonal:   full viewport redraw         = ~170kT (~2.4 frames)

static void scroll_right(void) {
    shift_viewport_left();
    render_dirty_column(
        VIEWPORT_COL_OFFSET + VIEWPORT_COLS - 1,
        &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x + VIEWPORT_COLS - 1]);
}

static void scroll_left(void) {
    shift_viewport_right();
    render_dirty_column(
        VIEWPORT_COL_OFFSET,
        &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x]);
}

static void scroll_down(void) {
    shift_viewport_up();
    render_dirty_row(
        VIEWPORT_CHAR_ROWS - 1,
        &map_data[(camera_tile_y + VIEWPORT_CHAR_ROWS - 1) * MAP_WIDTH + camera_tile_x]);
}

static void scroll_up(void) {
    shift_viewport_down();
    render_dirty_row(
        0,
        &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x]);
}

static void redraw_viewport(void) {
    render_full_viewport(&map_data[camera_tile_y * MAP_WIDTH + camera_tile_x]);
}

// Clear attributes in the viewport area (black paper, white ink)
void clear_viewport_attrs(void) {
    unsigned char row;
    for (row = 0; row < VIEWPORT_CHAR_ROWS; row++) {
        unsigned char *attr = (unsigned char *)(0x5800
            + (VIEWPORT_START_CHAR_ROW + row) * 32
            + VIEWPORT_COL_OFFSET);
        memset(attr, PAPER_BLACK | INK_WHITE, VIEWPORT_COLS);
    }
}

void load_scr_to_screen(const unsigned char *scr) {
    __asm
        di
    __endasm;
    memcpy((void *)0x4000, scr, 6912);
    __asm
        ei
    __endasm;
}

void tile_render_main(void) {
    const unsigned char *map_start;

    // Load HUD and set up attributes
    load_scr_to_screen(hud_scr);
    clear_viewport_attrs();

    // Initial full viewport render (runs ~2.4 frames with DI)
    map_start = &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x];
    render_full_viewport(map_start);

    // Main loop
    frame_count = 0;
    while (1) {
        unsigned char input;
        unsigned char moved;

        intrinsic_halt();

        input = read_input();

        frame_count++;
        if (frame_count < SCROLL_INTERVAL) continue;
        if (input == 0) { frame_count = SCROLL_INTERVAL - 1; continue; }
        frame_count = 0;

        moved = update_camera(input);
        if (moved) {
            int dx = camera_tile_x - prev_tile_x;
            int dy = camera_tile_y - prev_tile_y;

            if (dx && dy) {
                // Diagonal: full redraw (~170kT, ~2.4 frames)
                redraw_viewport();
            } else if (dx > 0) {
                scroll_right();
            } else if (dx < 0) {
                scroll_left();
            } else if (dy > 0) {
                scroll_down();
            } else {
                scroll_up();
            }
        }
    }
}
