#include <input.h>
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>
#include "tile_render.h"
#include "assets/man_sprite.h"

extern const unsigned char tiles[];
extern unsigned char map_data[];
extern const unsigned char hud_scr[];
extern unsigned int scr_addr_table_direct[];

// Camera state (in tile units, 8px per tile)
static int camera_tile_x = 10;
static int camera_tile_y = 10;
static int prev_tile_x = 0;
static int prev_tile_y = 0;

// Man sprite centred in viewport: col 9, char row 7
#define MAN_VIEWPORT_COL 9
#define MAN_VIEWPORT_ROW 7
#define MAN_SCREEN_COL   (VIEWPORT_COL_OFFSET + MAN_VIEWPORT_COL)  // 15
#define MAN_TABLE_OFFSET (MAN_VIEWPORT_ROW * 8)                    // 56

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

// Check if the 2x2 tile area under the man is all empty (tile 0)
static unsigned char man_can_move(int cam_x, int cam_y) {
    unsigned int off = (unsigned int)(cam_y + MAN_VIEWPORT_ROW) * MAP_WIDTH
                     + cam_x + MAN_VIEWPORT_COL;

    if (map_data[off] | map_data[off + 1]
      | map_data[off + MAP_WIDTH] | map_data[off + MAP_WIDTH + 1])
        return 0;
    return 1;
}

// Update camera based on input direction
// Returns nonzero if camera moved
static unsigned char update_camera(unsigned char input) {
    int max_x = MAP_WIDTH - VIEWPORT_COLS;
    int max_y = MAP_HEIGHT - VIEWPORT_CHAR_ROWS;
    int new_x = camera_tile_x;
    int new_y = camera_tile_y;

    prev_tile_x = camera_tile_x;
    prev_tile_y = camera_tile_y;

    // Horizontal axis
    if ((input & 0x01) && new_x < max_x) new_x++;  // right
    if ((input & 0x02) && new_x > 0)     new_x--;   // left
    if (!man_can_move(new_x, new_y))      new_x = camera_tile_x;

    // Vertical axis (uses accepted horizontal position for wall-sliding)
    if ((input & 0x04) && new_y < max_y) new_y++;  // down
    if ((input & 0x08) && new_y > 0)     new_y--;   // up
    if (!man_can_move(new_x, new_y))      new_y = camera_tile_y;

    camera_tile_x = new_x;
    camera_tile_y = new_y;

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

// Background save buffer: 16 scanlines x 2 bytes + 4 attribute bytes
static unsigned char man_bg[32];
static unsigned char man_bg_attr[4];

// Restore background pixels and attributes saved by draw_man()
static void erase_man(void) {
    unsigned char i;
    unsigned char *p;

    for (i = 0; i < 16; i++) {
        p = (unsigned char *)(scr_addr_table_direct[MAN_TABLE_OFFSET + i] + MAN_SCREEN_COL);
        p[0] = man_bg[i * 2];
        p[1] = man_bg[i * 2 + 1];
    }

    // Restore saved attributes
    {
        unsigned char *attr;
        attr = (unsigned char *)(0x5800 + (VIEWPORT_START_CHAR_ROW + MAN_VIEWPORT_ROW) * 32 + MAN_SCREEN_COL);
        attr[0] = man_bg_attr[0];
        attr[1] = man_bg_attr[1];
        attr = (unsigned char *)(0x5800 + (VIEWPORT_START_CHAR_ROW + MAN_VIEWPORT_ROW + 1) * 32 + MAN_SCREEN_COL);
        attr[0] = man_bg_attr[2];
        attr[1] = man_bg_attr[3];
    }
}

// Draw man sprite with mask compositing: (background & mask) | graphic
void draw_man(void) {
    unsigned char i;
    unsigned char *p;
    const unsigned char *sp;

    for (i = 0; i < 16; i++) {
        p = (unsigned char *)(scr_addr_table_direct[MAN_TABLE_OFFSET + i] + MAN_SCREEN_COL);
        sp = &man_sprite[i * 4];  // mask_l, gfx_l, mask_r, gfx_r

        // Save background
        man_bg[i * 2]     = p[0];
        man_bg[i * 2 + 1] = p[1];

        // Composite: (bg & mask) | graphic
        p[0] = (p[0] & sp[0]) | sp[1];
        p[1] = (p[1] & sp[2]) | sp[3];
    }

    // Save and set 2x2 attribute cells
    {
        unsigned char *attr;
        attr = (unsigned char *)(0x5800 + (VIEWPORT_START_CHAR_ROW + MAN_VIEWPORT_ROW) * 32 + MAN_SCREEN_COL);
        man_bg_attr[0] = attr[0];
        man_bg_attr[1] = attr[1];
        attr[0] = (attr[0] & 0xF8) | INK_GREEN;
        attr[1] = (attr[1] & 0xF8) | INK_GREEN;
        attr = (unsigned char *)(0x5800 + (VIEWPORT_START_CHAR_ROW + MAN_VIEWPORT_ROW + 1) * 32 + MAN_SCREEN_COL);
        man_bg_attr[2] = attr[0];
        man_bg_attr[3] = attr[1];
        attr[0] = (attr[0] & 0xF8) | INK_GREEN;
        attr[1] = (attr[1] & 0xF8) | INK_GREEN;
    }
}

void tile_render_main(void) {
    const unsigned char *map_start;

    // Load HUD and set up attributes
    load_scr_to_screen(hud_scr);
    clear_viewport_attrs();

    // Initial full viewport render (runs ~2.4 frames with DI)
    map_start = &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x];
    render_full_viewport(map_start);
    draw_man();

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

            erase_man();

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
            draw_man();
        }
    }
}
