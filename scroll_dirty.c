#include <input.h>
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>
#include "map_data.h"
#include "draw_dirty_edge.h"
#include "tiles_data.h"

#define KEMPSTON_PORT 0x1F
#define KEMPSTON_RIGHT 0x01
#define KEMPSTON_LEFT 0x02
#define KEMPSTON_DOWN 0x04
#define KEMPSTON_UP 0x08

static unsigned char kempston_read(void) __naked {
    __asm
        push bc
        ld bc, #KEMPSTON_PORT
        in a, (c)
        pop bc
        ld l, a
        ret
    __endasm;
}

static unsigned char kbd_read_row(unsigned int port) __naked {
    port;
    __asm
        push bc
        ld b, h
        ld c, l
        in a, (c)
        pop bc
        ld l, a
        ret
    __endasm;
}

#define TILE_WIDTH 8
#define TILE_HEIGHT 8
#define MAP_WIDTH 96
#define MAP_HEIGHT 48

void copy_viewport_32x16_to_screen(unsigned char *buffer);
void load_map(void);
void init_map(void);
void load_scr_to_screen(const unsigned char *scr);

extern const unsigned char hud_scr[];
extern unsigned char offscreen_buffer_32x16[];

unsigned char map_data[MAP_WIDTH * MAP_HEIGHT];

int camera_x = 0;
int camera_y = 0;

void load_map(void) {
    memcpy(map_data, map_bin, sizeof(map_data));
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

void main(void) {
    unsigned char joy;
    unsigned char kbd;
    unsigned char direction;
    unsigned char need_full_redraw = 1;
    
    load_map();
    load_scr_to_screen(hud_scr);
    dirty_edge_init();
    
    // Initial full redraw
    dirty_edge_full_redraw(map_data, tiles, offscreen_buffer_32x16,
                           camera_x, camera_y, MAP_WIDTH);
    copy_viewport_32x16_to_screen(offscreen_buffer_32x16);
    
    while (1) {
        direction = SCROLL_NONE;
        
        // Read Kempston joystick
        joy = kempston_read();
        
        // Read keyboard (QAOP + Space)
        // Q = up, A = down, O = left, P = right
        kbd = kbd_read_row(0xFBFE);  // Q row
        if (!(kbd & 0x01)) direction |= SCROLL_Y_MINUS;  // Q = up
        
        kbd = kbd_read_row(0xFDFE);  // A row
        if (!(kbd & 0x01)) direction |= SCROLL_Y_PLUS;   // A = down
        
        kbd = kbd_read_row(0xDFFE);  // P row
        if (!(kbd & 0x01)) direction |= SCROLL_X_PLUS;   // P = right
        
        kbd = kbd_read_row(0xBFFE);  // O row (Enter row)
        if (!(kbd & 0x02)) direction |= SCROLL_X_MINUS;  // O = left
        
        // Kempston overrides keyboard
        if (joy & KEMPSTON_RIGHT) direction |= SCROLL_X_PLUS;
        if (joy & KEMPSTON_LEFT)  direction |= SCROLL_X_MINUS;
        if (joy & KEMPSTON_DOWN)  direction |= SCROLL_Y_PLUS;
        if (joy & KEMPSTON_UP)    direction |= SCROLL_Y_MINUS;
        
        // Handle conflicting directions (cancel out)
        if ((direction & SCROLL_X_PLUS) && (direction & SCROLL_X_MINUS)) {
            direction &= ~(SCROLL_X_PLUS | SCROLL_X_MINUS);
        }
        if ((direction & SCROLL_Y_PLUS) && (direction & SCROLL_Y_MINUS)) {
            direction &= ~(SCROLL_Y_PLUS | SCROLL_Y_MINUS);
        }
        
        if (need_full_redraw) {
            dirty_edge_full_redraw(map_data, tiles, offscreen_buffer_32x16,
                                   camera_x, camera_y, MAP_WIDTH);
            need_full_redraw = 0;
        } else if (direction != SCROLL_NONE) {
            // Use dirty-edge scrolling for single-pixel movement
            dirty_edge_scroll(direction, map_data, tiles, offscreen_buffer_32x16,
                             &camera_x, &camera_y, MAP_WIDTH, MAP_HEIGHT);
        }
        
        copy_viewport_32x16_to_screen(offscreen_buffer_32x16);
        
        // Frame sync - wait for vsync
        intrinsic_halt();
    }
}
