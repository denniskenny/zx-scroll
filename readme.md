# ZX Spectrum Tilemap Scroller

A simple tilemap scroller for the ZX Spectrum, written in C using Z88DK.

## Controls

### Keyboard
- **O**: Scroll left
- **P**: Scroll right
- **Q**: Scroll up
- **A**: Scroll down
- Diagonal movement supported (e.g., Q+P for up-right)

### Kempston Joystick
- Fully supported via z88dk's `in_stick_kempston()` function
- Keyboard takes priority when both inputs are active

## Building

1. Make sure you have Z88DK installed
2. Run `make` to build the project
3. Load the resulting `.tap` file in your ZX Spectrum emulator

### Make parameters

- **CONFIG_MK**
  Selects the build configuration `.mk` file.
  Example:
  `make CONFIG_MK=config/basic_config.mk`

- **USER_CFLAGS**
  Extra flags appended to the Z88DK `zcc` invocation.
  Useful for passing assembler defines.
  Examples:
  `make USER_CFLAGS="-Ca-DOFFSCREEN_BUFFER_ORG=0xF000"`
  `make USER_CFLAGS="-DSHIFT_SPECIALISE=1"`

### Config file keys

Build configs live under `config/*.mk` and can define:

- `MAP_CSV`
- `TILES_ZXP`
- `MAP_WIDTH_TILES`, `MAP_HEIGHT_TILES`
- `TILE_WIDTH_PX`, `TILE_HEIGHT_PX`
- `USER_CFLAGS` (optional)

### Offscreen buffer placement

The offscreen buffer (`_offscreen_buffer`) is placed by the assembler using the
`OFFSCREEN_BUFFER_ORG` define.

- Default: `0xD000`
- Aggressive (more space for CODE/data): `0xF000`

Example:
`make CONFIG_MK=config/basic_config.mk USER_CFLAGS="-Ca-DOFFSCREEN_BUFFER_ORG=0xF000"`

## Memory map (48K Spectrum)

```
0xFFFF  +-------------------------------+
        | Stack (grows downward)        |
        |                               |
0x8000  +-------------------------------+
        | Program CODE/RODATA/BSS       |  (scroll_CODE.bin, org=0x8000)
        |                               |
0x7FFF  +-------------------------------+
        | Contended RAM (free)          |
0x7A00  +-------------------------------+
        | Map data (4608 bytes)         |  (_map_data = 0x6800)
0x6800  +-------------------------------+
        | Tile data (2048 bytes)        |  (_tiles = 0x6000)
0x6000  +-------------------------------+
        | BASIC workspace (loader)      |  (CLEAR 24575 / 0x5FFF)
0x5C00  +-------------------------------+
        | System vars                   |
0x5B00  +-------------------------------+
        | Attributes (768 bytes)        |
0x5800  +-------------------------------+
        | Screen pixels (6144 bytes)    |
0x4000  +-------------------------------+
        | ROM                           |
0x0000  +-------------------------------+

Notes:
- The `scroll.tap` image is built from 3 concatenated tape blocks:
  - `loader.tap` (BASIC loader)
  - `contended_data.tap` (tiles + map loaded to 0x6000)
  - `scroll_code.tap` (main program loaded to 0x8000)
- `tiles` and `map_data` are loaded into contended RAM at fixed addresses.
- The HUD (`hud.scr`) remains linked into the main program image.
```

## Linker section summary (scroll.map)

Built with `zcc ... -m`, the main program image (loaded at `0x8000`) uses:

- **CODE (C compiler)**
  - `__code_compiler_head = 0x80FB`
  - `__code_compiler_size = 0x0896` (2198 bytes)
  - `__code_compiler_tail = 0x8991`
- **CODE (user asm)**
  - `__code_user_head = 0x8991`
  - `__code_user_size = 0x07C1` (1985 bytes)
  - `__code_user_tail = 0x9152`
- **RODATA (user)**
  - `__rodata_user_head = 0x915B`
  - `__rodata_user_size = 0x1B00` (6912 bytes)  (`hud.scr`)
  - `__rodata_user_tail = 0xAC5B`
- **BSS (user)**
  - `__bss_user_head = 0xAD6F`
  - `__bss_user_size = 0x0C00` (3072 bytes)  (`offscreen_buffer_32x16`)
  - `__bss_user_tail = 0xB96F`

Fixed-address data loaded by the BASIC loader:

- **`_tiles = 0x6000`** (2048 bytes)
- **`_map_data = 0x6800`** (4608 bytes)

## Performance / Optimisations

### Runtime (frame-time)

- **Dirty-edge scrolling**
  The viewport buffer is shifted by 1px/8px and only the newly exposed edge is drawn, avoiding a full redraw.

- **Assembly shift routines** (`draw_dirty_edge.asm`)
  - 1px horizontal shifts are fully unrolled per row.
  - 8px shifts use byte copies (`LDIR`/`LDDR`) where possible.
  - Vertical shifts use large block copies (`LDIR`/`LDDR`).

- **Optimized blit to screen** (`copy_viewport_32x16.asm`)
  - Unrolled `LDI` copies per scanline.
  - Precomputed screen address table (avoids Spectrum bitmap address arithmetic in the hot loop).

- **Beam timing / frame sync** (`scroll.c`)
  Uses floating-bus sync to time the blit and reduce tearing.
  When idle (no input and nothing to blit) the loop uses `HALT` to minimize CPU usage.

### Memory / layout

- **Multi-block TAP with contended data**
  `scroll.tap` is composed of:
  - `loader.tap` (BASIC)
  - `contended_data.tap` (loaded to `0x6000`)
  - `scroll_code.tap` (loaded to `0x8000`)

  This moves static data out of the main program image:
  - `tiles` at `0x6000`
  - `map_data` at `0x6800` (used in-place, no runtime copy)

- **Dead code removed from main build**
  Older fullscreen renderer sources are preserved under `fullscreen/` but not linked into the scrolling build.

## Requirements

- Z88DK (tested with v2.2)
- A ZX Spectrum emulator (e.g., Fuse, ZXSpin, or ZEsarUX)

## How to use it

Build default sample game:
`make`

Build using a different config:
`make CONFIG_MK=config/basic_game.mk`

Run in Fuse:
`make run CONFIG_MK=config/basic_config.mk`

## Benchmarking (Fuse profiler)

There is a standalone benchmark program (`bench_scroll.c`) which renders a fixed
number of frames and exits. This is intended for reproducible Fuse profiling.

- Build benchmark TAP:
  `make CONFIG_MK=config/basic_config.mk bench_scroll`

- Run benchmark in Fuse:
  `make benchRun`

- Save Fuse profile output to a file (for example):
  `bench_baseline.profile`, `bench_specialised.profile`, `bench_block.profile`

## Shifted drawing implementation

### 7 fixed-shift entrypoints

`draw_shifted.asm` implements the shifted tile renderer using lookup tables.

- `_draw_shifted_asm(row, map_row, tiles_row, shift)`
  Computes the left/right shift table pointers for `shift` (1..7), then jumps
  into the shared core.

- `_draw_shifted_asm_1` .. `_draw_shifted_asm_7`
  Preload the shift table pointers for a fixed shift and jump into
  `draw_shifted_common`. This avoids per-call shift-table setup when the shift
  is constant.

### Reduced call frequency (8 scanlines per call)

`draw_shifted_block.asm` adds `_draw_shifted_block_asm(...)` which renders 8
scanlines per call. `draw_map.c` uses this to reduce call overhead (fewer C/ASM
transitions) while preserving the same pixel output.

### Selecting shifted implementation with `-DSHIFT_SPECIALISE`

The `draw_map.c` shifted path can be compiled in two modes using the
`SHIFT_SPECIALISE` preprocessor flag:

- **`SHIFT_SPECIALISE=0`** (or undefined)
  Uses the original `_draw_shifted_asm(row, map_row, tiles_row, shift)` entrypoint.
  The shift value is passed as a parameter and computed per call.

- **`SHIFT_SPECIALISE=1`** (default)
  Uses the 7 fixed-shift entrypoints `_draw_shifted_asm_1.._7`. The C code
  selects the appropriate entrypoint once per frame with a `switch(shift)` and
  calls it directly, avoiding per-call shift-table setup.

#### Building with the flag

**Important:** When using `SHIFT_SPECIALISE=1`, you must also specify the offscreen
buffer placement (`OFFSCREEN_BUFFER_ORG=0xF000`). The specialized shifted drawing
adds more code, and without moving the buffer to the higher address, the CODE
section will overlap the offscreen buffer.

```sh
# ✅ Correct: specialized shifted drawing with buffer moved to 0xF000
make CONFIG_MK=config/basic_config.mk USER_CFLAGS="-DSHIFT_SPECIALISE=1 -Ca-DOFFSCREEN_BUFFER_ORG=0xF000"

# ❌ Incorrect: causes CODE overlap error
make CONFIG_MK=config/basic_config.mk USER_CFLAGS="-DSHIFT_SPECIALISE=1"
# Error: Section CODE overlaps section bss_offscreen by 4704 bytes
```

**Why the error occurs:** The 7-entrypoint shifted implementation increases code size.
The default offscreen buffer at 0xD000 no longer provides enough space, so the
buffer must be moved to 0xF000. The config file already sets this, but when you
override `USER_CFLAGS` from the command line, you must include both flags.

## Dirty-Edge Scrolling System

The dirty-edge scrolling system (`draw_dirty_edge.c`, `draw_dirty_edge.asm`) provides
smooth pixel-by-pixel scrolling with minimal redraw overhead.

### Overview

Instead of redrawing the entire viewport each frame, dirty-edge scrolling:
1. **Shifts** existing pixel data by 1 pixel in the scroll direction
2. **Draws only the new edge** (1 pixel column or 1 scanline) exposed by the scroll

This dramatically reduces the amount of tile rendering needed per frame.

### Ring-Buffer Optimization

The vertical scrolling uses a **ring-buffer** approach for maximum performance:
- **Vertical scrolling**: Updates `head_row` pointer instead of physically shifting 3072 bytes
- **Ring-buffer blitter**: `copy_viewport_32x16_to_screen_ring()` blits buffer in two segments based on `head_row`
- **Horizontal scrolling**: Still uses physical buffer shifts but benefits from ring-aware edge drawing

This eliminates expensive `LDIR`/`LDDR` operations for vertical movement, significantly improving performance.

### Viewport

- **Size:** 32x12 characters (256x96 pixels)
- **Position:** Centered on screen (starting at Y=48)
- **Buffer:** 3072 bytes in `bss_user` section

### API

```c
// Scroll by stride pixels in direction, draw new edges
// stride_x: horizontal scroll speed (pixels per frame)
// stride_y: vertical scroll speed (pixels per frame)
// For diagonals, uses min(stride_x, stride_y) to keep movements synchronized
unsigned char dirty_edge_scroll(
    unsigned char direction,      // SCROLL_X_PLUS, SCROLL_X_MINUS, etc.
    const unsigned char *map_data,
    const unsigned char *tiles,
    unsigned char *buffer,
    unsigned char *head,          // Ring-buffer head row pointer
    int *camera_x,
    int *camera_y,
    int map_width,
    int map_height,
    unsigned char stride_x,       // Horizontal scroll speed (e.g., 4)
    unsigned char stride_y        // Vertical scroll speed (e.g., 2)
);

// Blit buffer to screen (linear mode)
void copy_viewport_32x16_to_screen(unsigned char *buffer);

// Blit buffer to screen (ring-buffer mode - optimized)
void copy_viewport_32x16_to_screen_ring(unsigned char *buffer, unsigned char head_row);
```

### Direction Flags

```c
#define SCROLL_X_PLUS   0x01  // Right
#define SCROLL_X_MINUS  0x02  // Left
#define SCROLL_Y_PLUS   0x04  // Down
#define SCROLL_Y_MINUS  0x08  // Up
```

Diagonal scrolling is supported by combining flags (e.g., `SCROLL_X_PLUS | SCROLL_Y_PLUS`).

### Assembly Optimizations

#### Horizontal Shift Routines (Physical Buffer Shifts)
- **`shift_buffer_left_1px`** - 32x `RL (HL)` unrolled per row, EXX for row counter (~75,000 cycles)
- **`shift_buffer_right_1px`** - 32x `RR (HL)` unrolled per row, EXX for row counter (~75,000 cycles)

#### Vertical Scrolling (Ring-Buffer Optimization)
- **Vertical scroll**: Updates `head_row` pointer only (no buffer shift) - **~100 cycles**
- **`shift_buffer_up_1row`** - Available but not used (LDIR 3040 bytes, ~61,000 cycles)
- **`shift_buffer_down_1row`** - Available but not used (LDDR 3040 bytes, ~61,000 cycles)

The ring-buffer approach makes vertical scrolling **~600x faster** than physical buffer shifts.

#### 8-Pixel Shift Routines (Byte-Aligned, No Bit Shifts)
- **`shift_buffer_left_8px`** - `LDIR` 31 bytes/row, ~8x faster than 8 single shifts
- **`shift_buffer_right_8px`** - `LDDR` 31 bytes/row
- **`shift_buffer_up_8rows`** - Single `LDIR` of 2816 bytes
- **`shift_buffer_down_8rows`** - Single `LDDR` of 2816 bytes

#### Viewport Blit (Ring-Buffer Aware)
- **`copy_viewport_32x16_to_screen_ring`** - Ring-buffer aware blitter
  - Splits buffer into two segments based on `head_row`
  - Segment A: rows from `head_row` to end of buffer
  - Segment B: rows from start of buffer to `head_row`
  - Each segment uses 32x unrolled `LDI` per scanline
- Precomputed screen address table for Spectrum's non-linear layout
- EXX for table pointer management

### Performance Comparison

| Operation | Cycles (approx) | Notes |
|-----------|-----------------|-------|
| Vertical 1-row shift | ~61,000 | LDIR 3040 bytes |
| Horizontal 1-pixel shift | ~75,000 | 96 rows × 32 unrolled rotates |
| Horizontal 8-pixel shift | ~62,000 | LDIR 31 bytes × 96 rows |
| Vertical 8-row shift | ~57,000 | LDIR 2816 bytes |

### Input System

The input system uses **z88dk's standard input library** for both keyboard and joystick:

```c
// Keyboard input via in_key_pressed()
if (in_key_pressed(IN_KEY_SCANCODE_q)) direction |= SCROLL_Y_MINUS;
if (in_key_pressed(IN_KEY_SCANCODE_a)) direction |= SCROLL_Y_PLUS;
if (in_key_pressed(IN_KEY_SCANCODE_o)) direction |= SCROLL_X_MINUS;
if (in_key_pressed(IN_KEY_SCANCODE_p)) direction |= SCROLL_X_PLUS;

// Kempston joystick via in_stick_kempston()
uint16_t joy = in_stick_kempston();
if (joy & IN_STICK_UP)    direction |= SCROLL_Y_MINUS;
if (joy & IN_STICK_DOWN)  direction |= SCROLL_Y_PLUS;
if (joy & IN_STICK_LEFT)  direction |= SCROLL_X_MINUS;
if (joy & IN_STICK_RIGHT) direction |= SCROLL_X_PLUS;
```

Benefits:
- No custom assembly keyboard routines needed
- Automatic support for multiple input devices
- Well-tested and maintained by z88dk
- Easy to add support for other joystick types (Sinclair, Cursor, etc.)

### Files

- `draw_dirty_edge.h` - API declarations and constants
- `draw_dirty_edge.c` - Scroll handlers, edge drawing functions, ring-buffer logic
- `draw_dirty_edge.asm` - Assembly shift routines (1px and 8px)
- `copy_viewport_32x16.asm` - Ring-buffer aware viewport blit and buffer allocation
- `scroll.c` - Main loop, input handling, frame timing
- `test_scroll.c` - Performance test framework

## Viewport copy (128-bit write optimization)

The viewport blit routine (`copy_viewport.asm`, `_copy_viewport_to_screen`) copies
the 128x128 pixel offscreen buffer to the Spectrum screen.

Optimization details:

- **16-byte bursts ("128-bit" writes)**
  Each screen scanline in the viewport is 16 bytes wide. The routine copies each
  scanline using 16x `LDI` (byte copy) rather than a single `LDIR`. This reduces
  per-byte overhead (unrolled `LDI` is faster than `LDIR` on Z80).

- **2-line loop unrolling**
  The main loop processes two scanlines per iteration (64 iterations total) to
  reduce loop overhead.

- **Precomputed screen address table**
  A lookup table (`scr_addr_table`) provides the destination screen address for
  each scanline, avoiding expensive address arithmetic for the Spectrum's
  non-linear bitmap layout.