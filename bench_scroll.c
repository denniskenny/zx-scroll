#include <arch/spectrum.h>
#include <string.h>

#include "draw_map.h"
#include "map_data.h"
#include "tiles_data.h"

#define TILE_WIDTH 8
#define TILE_HEIGHT 8
#define MAP_WIDTH 96
#define MAP_HEIGHT 48

extern void copy_viewport_to_screen(void);
extern unsigned char offscreen_buffer[16 * 16 * 8];

static unsigned char map_data_local[MAP_WIDTH * MAP_HEIGHT];

static void load_map_local(void) {
    memcpy(map_data_local, map_bin, MAP_WIDTH * MAP_HEIGHT);
}

int main(void) {
    int camera_x = 1;
    int camera_y = 0;
    const int max_x = (MAP_WIDTH - 16) * TILE_WIDTH;

    zx_border(INK_BLACK);
    zx_cls(PAPER_BLACK | INK_WHITE);

    load_map_local();

    __asm
        di
    __endasm;

    for (unsigned int frame = 0; frame < 2000; frame++) {
        draw_map(map_data_local, tiles, offscreen_buffer, camera_x, camera_y, MAP_WIDTH);
        copy_viewport_to_screen();

        camera_x++;
        if (camera_x >= max_x) {
            camera_x = 1;
        }
    }

    return 0;
}
