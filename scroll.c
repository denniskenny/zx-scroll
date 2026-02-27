#include <arch/spectrum.h>

// Direct-to-screen tile renderer entry point (tile_render.c)
void tile_render_main(void);

int main(void) {
    zx_border(INK_BLACK);
    tile_render_main();
    return 0;
}
