# Full-Screen Tile Renderer

A high-performance full-screen tile map renderer for the ZX Spectrum, written in optimised Z80 assembly with a C driver. Renders a 128×128 pixel (16×16 tile) viewport with pixel-level scrolling in all directions.

## Files

| File | Description |
|------|-------------|
| `draw_map.c` | C driver — calls the appropriate assembly routine based on camera alignment |
| `draw_map.h` | Header with `draw_map()` function prototype |
| `draw_aligned.asm` | Assembly: renders 16 tiles per scanline when camera X is tile-aligned (shift=0) |
| `draw_shifted.asm` | Assembly: renders 17 tiles per scanline with sub-tile pixel shifting (shift=1–7). Includes 14× 256-byte lookup tables for fast left/right bit shifting |
| `draw_shifted_block.asm` | Assembly: renders 8 scanlines (one tile row) per call for shifted scrolling, reducing C↔asm call overhead |

## How It Works

### Tile Format

Tiles are 8×8 pixels, 1 bit per pixel (monochrome). Each tile is stored as 8 consecutive bytes, one byte per scanline row:

```
Byte 0: pixel row 0 (top)    — bits 7..0 = pixels left..right
Byte 1: pixel row 1
...
Byte 7: pixel row 7 (bottom)
```

Tile data is a flat array: `tile_index * 8 + scanline_y` gives the byte for any tile/row.

### Map Format

The map is a flat array of tile indices (1 byte each), stored row-major:

```
map_data[tile_y * map_width + tile_x] = tile_index
```

Where `map_width` is the map width in tiles. Generated from a CSV file using `generate_map`.

### Rendering Pipeline

The renderer has two paths selected automatically based on `camera_x & 7`:

1. **Aligned path** (`shift == 0`): Each output byte comes from exactly one tile. Uses `draw_aligned_asm()` which is fully unrolled for 16 tiles — no loops, no branches.

2. **Shifted path** (`shift == 1–7`): Each output byte is a blend of two adjacent tiles. The left tile is shifted left by `shift` bits, the right tile shifted right by `8 - shift` bits, and they are OR'd together. Uses 256-byte lookup tables for single-instruction shift operations (indexed load instead of multi-cycle rotate chains).

### Offscreen Buffer

The renderer writes to an offscreen buffer (not directly to screen memory) because:
- ZX Spectrum screen memory has a non-linear layout
- Writing to screen during beam scan causes flicker
- The buffer allows double-buffering with a separate blit routine

The buffer is 16 bytes wide × 128 scanlines = 2048 bytes, stored linearly (one scanline per 16-byte row).

If using the offscreen buffer defined in `draw_aligned.asm`, define `INCLUDE_OFFSCREEN_BUFFER` at assembly time. It will be placed at `0xD000` by default (uncontended RAM, 256-byte aligned).

## API

### `draw_map()`

```c
#include "draw_map.h"

void draw_map(
    const unsigned char *map_data,   // Tile map indices (flat array, row-major)
    const unsigned char *tiles,      // Tile pixel data (8 bytes per tile)
    unsigned char *buffer,           // Output buffer (2048 bytes, 16 bytes/row)
    int camera_x,                    // Camera X in pixels (0 to map_width*8 - 128)
    int camera_y,                    // Camera Y in pixels (0 to map_height*8 - 128)
    int map_width                    // Map width in tiles
);
```

### Parameters

- **`map_data`**: Pointer to the tile map. Each byte is a tile index (0–255). Row-major order, `map_width` bytes per row.
- **`tiles`**: Pointer to tile graphics. 8 bytes per tile, stored sequentially. Tile N starts at offset `N * 8`.
- **`buffer`**: Pointer to a 2048-byte output buffer. Must be in uncontended RAM for best performance. 256-byte alignment recommended (allows `inc e` instead of `inc de` for column advance).
- **`camera_x`**: Horizontal scroll position in pixels. Range: `0` to `(map_width * 8) - 128`.
- **`camera_y`**: Vertical scroll position in pixels. Range: `0` to `(map_height * 8) - 128`.
- **`map_width`**: Width of the map in tiles.

### Example Main Loop

```c
#include "draw_map.h"

extern unsigned char offscreen_buffer[];  // 2048 bytes
extern const unsigned char map_data[];    // from map_data.h
extern const unsigned char tiles[];       // from tiles_data.h

#define MAP_WIDTH 96

int camera_x = 0, camera_y = 0;

while (1) {
    // 1. Read input and update camera_x, camera_y
    // ...

    // 2. Render tilemap to offscreen buffer
    draw_map(map_data, tiles, offscreen_buffer,
             camera_x, camera_y, MAP_WIDTH);

    // 3. Blit offscreen buffer to screen
    // (use your own copy routine for the Spectrum's non-linear screen layout)
    copy_buffer_to_screen(offscreen_buffer);

    // 4. Wait for vsync
    intrinsic_halt();
}
```

## Adding to Your Build

Add these files to your z88dk compilation command:

```makefile
ZCC_SOURCES = your_main.c draw_map.c draw_aligned.asm draw_shifted.asm draw_shifted_block.asm
```

The assembly files depend on the shift lookup tables defined in `draw_shifted.asm` (`lshift_table_addrs`, `rshift_table_addrs`). All three `.asm` files must be linked together.

## Memory Cost

| Component | Size |
|-----------|------|
| `draw_aligned.asm` (code) | ~550 bytes |
| `draw_shifted.asm` (code) | ~300 bytes |
| `draw_shifted.asm` (lookup tables) | ~3584 bytes (14 × 256) |
| `draw_shifted_block.asm` (code) | ~400 bytes |
| `draw_map.c` (compiled) | ~300 bytes |
| Offscreen buffer | 2048 bytes |
| **Total** | **~7.2KB** |

The lookup tables dominate the memory cost but provide a significant speed advantage over runtime bit-shifting.

## Performance Notes

- The aligned path is ~2× faster than the shifted path
- `draw_shifted_block_asm` processes 8 scanlines per call, reducing C→asm overhead for the shifted path
- All tile lookups use `add hl,hl` chains (3 shifts = ×8) which is faster than multiplication
- The alternate register set (`exx`) is used to hold the tile base pointer, avoiding repeated stack access
