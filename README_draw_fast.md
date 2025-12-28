# Optimized Tile Drawing Routines

## Overview

Two highly optimized Z80 assembly modules for drawing tiles to an off-screen buffer on the ZX Spectrum:

| File | Function | Purpose |
|------|----------|---------|
| `draw_aligned.asm` | `draw_aligned_asm` | Aligned drawing (camera_x % 8 == 0) |
| `draw_shifted.asm` | `draw_shifted_asm` | Shifted drawing with pixel blending |

Both are designed for smooth pixel-scrolling applications.

### File Contents

**`draw_aligned.asm`**
- `_draw_aligned_asm` - Fast aligned tile drawing function
- `_offscreen_buffer` - 2KB buffer at 0xC000 (uncontended RAM)

**`draw_shifted.asm`**
- `_draw_shifted_asm` - Fast shifted tile drawing with blending
- 14 shift lookup tables (7 left + 7 right, 256 bytes each)

---

## draw_aligned_asm

### Function Signature

```c
void draw_aligned_asm(
    unsigned char *row,           // Destination row in offscreen buffer
    unsigned char *map_row,       // Source map data (16 tile indices)
    const unsigned char *tiles_base,  // Base address of tile graphics
    unsigned char in_tile_y       // Y offset within tile (0-7)
);
```

### Usage
Called when `camera_x & 7 == 0` (aligned to 8-pixel boundary). No blending required.

---

## draw_shifted_asm

### Function Signature

```c
void draw_shifted_asm(
    unsigned char *row,           // Destination row in offscreen buffer
    unsigned char *map_row,       // Source map data (17 tile indices needed)
    const unsigned char *tiles_row,   // tiles_base + in_tile_y (precomputed)
    unsigned char shift           // Pixel shift amount (1-7)
);
```

### Usage
Called when `camera_x & 7 != 0` (not aligned). Blends adjacent tiles.

### Algorithm
For each output byte:
```c
row[i] = (tiles_row[map[i] * 8] << shift) | (tiles_row[map[i+1] * 8] >> rshift)
```
Where `rshift = 8 - shift`.

### Register Usage

| Register | Purpose |
|----------|---------|
| HL | Map row pointer (main) |
| DE | Output buffer pointer (main) |
| C | Temporary shifted left byte (main) |
| BC' | tiles_row base address (alternate) |
| D' | Left shift table high byte (alternate) |
| E' | Right shift table high byte (alternate) |
| HL' | Tile/table address calculation (alternate) |

### Optimizations

#### 1. Fully Unrolled (16 tiles)
All 16 tiles processed inline - no loop overhead.
**Saves**: ~450 T-states per row

#### 2. Shift Lookup Tables
Instead of shift loops, uses 256-byte precomputed tables for instant shifts:
```asm
; Old method (variable loop):
ld l, d          ; shift count
shift_loop:
    add a, a     ; or srl a for right shift
    dec l
    jr nz, shift_loop

; New method (table lookup - constant time):
ld l, (hl)       ; L = byte to shift
ld h, d          ; H = lshift_N table high byte
ld a, (hl)       ; A = shifted result (instant!)
```
**Saves**: ~20 T-states per shift (avg 4 iterations × 15T = 60T → 14T)

#### 3. Table Structure
14 tables total (7 left + 7 right), each 256 bytes, page-aligned:
- `_lshift_1` to `_lshift_7`: `table[x] = (x << N) & 0xFF`
- `_rshift_1` to `_rshift_7`: `table[x] = x >> N`

High bytes stored in lookup tables for fast access:
```asm
_lshift_table_hi:
    DEFB _lshift_1 / 256, _lshift_2 / 256, ... _lshift_7 / 256
_rshift_table_hi:
    DEFB _rshift_1 / 256, _rshift_2 / 256, ... _rshift_7 / 256
```

#### 4. No Push/Pop in Tile Code
BC' holds tiles_row permanently, D'/E' hold table high bytes.
**Saves**: ~480 T-states (32 push/pop eliminated)

#### 5. Efficient Address Calculation
```asm
add a, c         ; tiles_row_low + (tile * 8)
ld l, a
ld a, b
adc a, 0
ld h, a          ; HL' = tiles_row + tile*8
```

### Performance

#### Per-Tile Timing (with lookup tables)
| Operation | T-states |
|-----------|----------|
| ld a, (hl) | 7 |
| add a,a ×3 | 12 |
| address calc | 18 |
| ld l, (hl) | 7 |
| ld h, d | 4 |
| ld a, (hl) | 7 |
| exx ×2 | 8 |
| **Left tile** | **~63** |
| **Right tile** | **~63** |
| or c, ld (de), a | 11 |
| **Total per tile** | **~74** |

#### Per-Row Estimate
- 16 tiles × ~74 T = **~1184 T-states per row**
- Previous loop-shift version: ~1600 T-states
- **Speedup: ~26% faster**

#### Memory Cost
- 14 tables × 256 bytes = **3,584 bytes**
- Table high byte arrays: 14 bytes
- **Total: ~3.5 KB**

---

## draw_aligned_asm (Details)

## How It Works

### Algorithm

1. **Setup**: Load parameters from stack, precompute `tiles_base + in_tile_y`
2. **For each of 16 tiles**:
   - Read tile index from map_row
   - Skip if tile is empty (index 0)
   - Calculate tile address: `tiles_base + in_tile_y + (tile_index * 8)`
   - Copy single byte from tile to output buffer
3. **Cleanup**: Restore registers and return

### Register Usage

| Register | Purpose |
|----------|---------|
| HL | Map row pointer (main) |
| DE | Output buffer pointer (main) |
| HL' | Tile address calculation (alternate) |
| DE' | tiles_base + in_tile_y (alternate) |
| B' | Constant 0 for fast H' reset |
| A | Tile index / tile byte data |

## Optimizations

### 1. DI/EI Instead of Register Save/Restore
```asm
di                   ; Disable interrupts
; ... drawing code ...
ei                   ; Re-enable interrupts
```
**Saves**: ~69 T-states (avoids 6 push/pop + 4 exx)

### 2. Alternate Register Set (EXX)
Uses Z80's alternate register set to avoid push/pop within the tile loop.
```asm
exx                  ; Switch to HL', DE', BC'
; ... calculate tile address ...
exx                  ; Switch back
```
**Saves**: ~58 T-states per tile vs push/pop approach

### 3. Precomputed tiles_base + in_tile_y
```asm
; At setup:
add a, c             ; tiles_base_low + in_tile_y
; Store in DE' for all 16 tiles
```
**Saves**: 8 instructions per tile (128 total)

### 4. B' = 0 for Fast H' Reset
```asm
ld h, b              ; H' = 0 (B' is always 0)
```
**Reason**: After `add hl, de`, H' is corrupted. Using B' = 0 allows fast reset.

### 5. Unrolled Loop (16 tiles)
All 16 tiles are processed inline without loop overhead.
**Saves**: ~50 T-states (no loop counter, no conditional jump)

### 6. Fast 8-bit Increment (inc e)
```asm
inc e                ; 4 T-states vs inc de (6 T-states)
```
**Requires**: Buffer aligned to 256-byte boundary
**Saves**: 2 T-states per tile (30 total per row)

### 7. 256-Byte Aligned Buffer at 0xC000
```asm
ORG 0xC000
_offscreen_buffer:
    DEFS 2048
```
**Benefits**:
- E register never overflows (stays 0x00-0x0F per row)
- Uncontended RAM (no ULA wait states)

## Performance

### Per-Tile Timing (non-empty tile)
| Operation | T-states |
|-----------|----------|
| ld a, (hl) | 7 |
| or a | 4 |
| jr z, skip | 7 |
| exx | 4 |
| ld l, a | 4 |
| ld h, b | 4 |
| add hl, hl (x3) | 33 |
| add hl, de | 11 |
| ld a, (hl) | 7 |
| exx | 4 |
| ld (de), a | 7 |
| inc hl | 6 |
| inc e | 4 |
| **Total** | **~102** |

### Per-Frame Estimate
- 128 rows × 16 tiles = 2048 tile operations
- Assuming 50% non-empty: ~1024 × 102 T + 1024 × 25 T ≈ 130,000 T-states
- At 3.5 MHz: ~37ms per frame (achievable at ~27 FPS)

## Critical Notes

### 8-Pixel Boundary Bug Prevention

The following must be maintained to prevent rendering bugs at 8-pixel scroll boundaries:

1. **H' must be reset before each tile**: Use `ld h, b` where B' = 0
2. **Buffer must be 256-byte aligned**: Otherwise `inc e` overflows
3. **Alternate registers must not be corrupted**: DI/EI protects from interrupts

### Memory Map
```
0x8000 - Code start (ORG 32768)
0xC000 - offscreen_buffer (2048 bytes, aligned)
0xC800 - End of buffer
```

## Testing

See `test_draw_fast.c` for regression tests covering:

### draw_aligned_asm Tests
- Empty tile handling
- Non-empty tile rendering
- All Y offsets (0-7)
- Last tile position (inc e overflow check)

### draw_shifted_asm Tests
- All shift values (1-7)
- 8-pixel boundary transitions (shift 1 and shift 7)
- Mixed tile patterns with blending
- Empty tile blending (verifies zero tiles produce zeros)
- Gradient tile verification at all shift values

### 8-Pixel Boundary Tests
These tests are critical for catching rendering bugs that only appear when crossing 8-pixel scroll boundaries:
- `test_shift_boundary_1` - Shift by 1 pixel (7 pixels from next boundary)
- `test_shift_boundary_7` - Shift by 7 pixels (1 pixel from next boundary)
- `test_all_shifts` - Tests all 7 shift values systematically

### Running Tests
```bash
# Compile and run
make testFuse

# Or compile only:
make test

# Or manually:
zcc +zx -vn -SO3 -startup=31 -clib=sdcc_iy test_draw_fast.c draw_aligned.asm draw_shifted.asm -o test_draw -create-app

# Run in emulator
open -a Fuse test_draw.tap
```

### Test Results
- **Green border** = All tests passed
- **Red border** = Test(s) failed
- Border flashes during individual tests
