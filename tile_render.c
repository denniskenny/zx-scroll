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

static void flash_border_red(void) {
    __asm
        ld a, 2
        out (0xFE), a
    __endasm;
}

static void reset_border(void) {
    __asm
        xor a
        out (0xFE), a
    __endasm;
}

// Handle a single tile under the man. Returns 1 if solid (blocks movement).
static unsigned char handle_tile(unsigned char tile) {
    switch (tile) {
        case 1: return 1;  // solid wall
        case 3: flash_border_red(); return 0;
        default: return 0;
    }
}

// Check the 2x2 tile area under the man for collisions and triggers.
// Off-map tiles are treated as passable (empty).
static unsigned char man_can_move(int cam_x, int cam_y) {
    int mx = cam_x + MAN_VIEWPORT_COL;
    int my = cam_y + MAN_VIEWPORT_ROW;
    unsigned int off;

    if (mx < 0 || mx + 1 >= MAP_WIDTH || my < 0 || my + 1 >= MAP_HEIGHT)
        return 1;

    reset_border();
    off = (unsigned int)my * MAP_WIDTH + mx;

    if (handle_tile(map_data[off]) || handle_tile(map_data[off + 1])
      || handle_tile(map_data[off + MAP_WIDTH]) || handle_tile(map_data[off + MAP_WIDTH + 1]))
        return 0;
    return 1;
}

// Update camera based on input direction
// Returns nonzero if camera moved
static unsigned char update_camera(unsigned char input) {
    int new_x = camera_tile_x;
    int new_y = camera_tile_y;

    prev_tile_x = camera_tile_x;
    prev_tile_y = camera_tile_y;

    // Horizontal axis (no edge-of-map limits)
    if (input & 0x01) new_x++;  // right
    if (input & 0x02) new_x--;  // left
    if (!man_can_move(new_x, new_y)) new_x = camera_tile_x;

    // Vertical axis (no edge-of-map limits)
    if (input & 0x04) new_y++;  // down
    if (input & 0x08) new_y--;  // up
    if (!man_can_move(new_x, new_y)) new_y = camera_tile_y;

    camera_tile_x = new_x;
    camera_tile_y = new_y;

    return (camera_tile_x != prev_tile_x) || (camera_tile_y != prev_tile_y);
}

// Safe tile read: returns 0 for out-of-bounds
static unsigned char safe_tile(int x, int y) {
    if ((unsigned int)x >= MAP_WIDTH || (unsigned int)y >= MAP_HEIGHT)
        return 0;
    return map_data[y * MAP_WIDTH + x];
}

// Render a single tile to screen (0 = empty pixels)
static void render_tile_at(unsigned char tile, unsigned char vp_row, unsigned char screen_col) {
    unsigned char s;
    unsigned int base = (unsigned int)vp_row * 8;
    for (s = 0; s < 8; s++) {
        unsigned char *p = (unsigned char *)(scr_addr_table_direct[base + s] + screen_col);
        *p = tile ? tiles[tile * 8 + s] : 0;
    }
}

// Render a column tile-by-tile with bounds checking (C fallback)
static void safe_render_column(unsigned char screen_col, int map_x) {
    unsigned char row;
    __asm di __endasm;
    for (row = 0; row < VIEWPORT_CHAR_ROWS; row++)
        render_tile_at(safe_tile(map_x, camera_tile_y + row), row, screen_col);
    __asm ei __endasm;
}

// Render a row tile-by-tile with bounds checking (C fallback)
static void safe_render_row(unsigned char viewport_row, int map_y) {
    unsigned char col;
    __asm di __endasm;
    for (col = 0; col < VIEWPORT_COLS; col++)
        render_tile_at(safe_tile(camera_tile_x + col, map_y), viewport_row, VIEWPORT_COL_OFFSET + col);
    __asm ei __endasm;
}

// Render a dirty column: assembly when fully in bounds, C per-tile otherwise
static void draw_column(unsigned char screen_col, int map_x) {
    if (map_x >= 0 && map_x < MAP_WIDTH
        && camera_tile_y >= 0 && camera_tile_y + VIEWPORT_CHAR_ROWS <= MAP_HEIGHT)
        render_dirty_column(screen_col, &map_data[camera_tile_y * MAP_WIDTH + map_x]);
    else
        safe_render_column(screen_col, map_x);
}

// Render a dirty row: assembly when fully in bounds, C per-tile otherwise
static void draw_row(unsigned char viewport_row, int map_y) {
    if (map_y >= 0 && map_y < MAP_HEIGHT
        && camera_tile_x >= 0 && camera_tile_x + VIEWPORT_COLS <= MAP_WIDTH)
        render_dirty_row(viewport_row, &map_data[map_y * MAP_WIDTH + camera_tile_x]);
    else
        safe_render_row(viewport_row, map_y);
}


// Clear attributes in the viewport area (white paper, black ink)
void clear_viewport_attrs(void) {
    unsigned char row;
    for (row = 0; row < VIEWPORT_CHAR_ROWS; row++) {
        unsigned char *attr = (unsigned char *)(0x5800
            + (VIEWPORT_START_CHAR_ROW + row) * 32
            + VIEWPORT_COL_OFFSET);
        memset(attr, PAPER_BLUE | BRIGHT | INK_BLACK, VIEWPORT_COLS);
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

// Redraw tiles under the sprite + shifted ghost from the map.
// Race-the-beam: called AFTER shifts (~50-70KT), so the ULA beam
// has already passed the sprite at Y=120 (~45KT from interrupt).
// The redraw area extends 1 tile in the shift direction to cover
// the ghost left behind by the shifted composited sprite pixels.
static void redraw_sprite_tiles(int dx, int dy) {
    unsigned char r, c;
    unsigned char col0 = MAN_VIEWPORT_COL;
    unsigned char row0 = MAN_VIEWPORT_ROW;
    unsigned char col1 = MAN_VIEWPORT_COL + 2;
    unsigned char row1 = MAN_VIEWPORT_ROW + 2;
    unsigned char *attr;

    // Extend 1 tile in shift direction to cover ghost
    if (dx > 0) col0--;
    else if (dx < 0) col1++;
    if (dy > 0) row0--;
    else if (dy < 0) row1++;

    for (r = row0; r < row1; r++)
        for (c = col0; c < col1; c++)
            render_tile_at(safe_tile(camera_tile_x + c, camera_tile_y + r),
                           r, VIEWPORT_COL_OFFSET + c);

    // Restore sprite attributes to viewport default
    attr = (unsigned char *)(0x5800 + (VIEWPORT_START_CHAR_ROW + MAN_VIEWPORT_ROW) * 32 + MAN_SCREEN_COL);
    attr[0] = PAPER_BLUE | BRIGHT | INK_BLACK;
    attr[1] = PAPER_BLUE | BRIGHT | INK_BLACK;
    attr = (unsigned char *)(0x5800 + (VIEWPORT_START_CHAR_ROW + MAN_VIEWPORT_ROW + 1) * 32 + MAN_SCREEN_COL);
    attr[0] = PAPER_BLUE | BRIGHT | INK_BLACK;
    attr[1] = PAPER_BLUE | BRIGHT | INK_BLACK;
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
        attr[0] = (attr[0] & 0xF8) | INK_YELLOW;
        attr[1] = (attr[1] & 0xF8) | INK_YELLOW;
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

    // Initial full viewport render
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

            // Phase 1: shifts first (each has internal DI/EI)
            // Takes ~50-70KT; ULA passes sprite Y=120 at ~45KT
            if (dx > 0) shift_viewport_left();
            else if (dx < 0) shift_viewport_right();
            if (dy > 0) shift_viewport_up();
            else if (dy < 0) shift_viewport_down();

            // Phase 2: redraw tiles under sprite + ghost + composite (beam past sprite)
            redraw_sprite_tiles(dx, dy);
            draw_man();

            // Phase 3: fill stale edges
            if (dy > 0) draw_row(VIEWPORT_CHAR_ROWS - 1, camera_tile_y + VIEWPORT_CHAR_ROWS - 1);
            else if (dy < 0) draw_row(0, camera_tile_y);
            if (dx > 0) draw_column(VIEWPORT_COL_OFFSET + VIEWPORT_COLS - 1, camera_tile_x + VIEWPORT_COLS - 1);
            else if (dx < 0) draw_column(VIEWPORT_COL_OFFSET, camera_tile_x);
        }
    }
}
