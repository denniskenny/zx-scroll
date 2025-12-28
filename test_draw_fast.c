/*
 * test_draw_fast.c - Regression tests for draw_fast.asm
 * 
 * Tests draw_aligned_asm and draw_shifted_asm functions to ensure:
 * - Correct tile rendering
 * - Proper handling of empty tiles
 * - No corruption at 8-pixel boundaries
 * - Correct pixel blending for shifted drawing
 * - Buffer alignment safety
 *
 * Compile: zcc +zx -vn -SO3 -startup=31 -clib=sdcc_iy test_draw_fast.c draw_fast.asm -o test_draw -create-app
 * Run in emulator and check border colors for pass/fail
 */

#include <arch/zx.h>
#include <string.h>
#include <stdint.h>

// External assembly functions
extern void draw_aligned_asm(unsigned char *row, unsigned char *map_row, const unsigned char *tiles_base, unsigned char in_tile_y);
extern void draw_shifted_asm(unsigned char *row, unsigned char *map_row, const unsigned char *tiles_row, unsigned char shift);

// External aligned buffer from draw_fast.asm
extern unsigned char offscreen_buffer[];

// Test tile data (4 tiles, 8 bytes each)
static const unsigned char test_tiles[] = {
    // Tile 0: Empty (all zeros)
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    // Tile 1: Solid (all ones)
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    // Tile 2: Alternating rows
    0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
    // Tile 3: Gradient pattern
    0x01, 0x03, 0x07, 0x0F, 0x1F, 0x3F, 0x7F, 0xFF
};

// Test map data (17 tiles for shifted - need one extra for blending)
static unsigned char test_map[17];

// Reference buffer for comparison
static unsigned char reference_buffer[16];

// Test result tracking
static int tests_passed = 0;
static int tests_failed = 0;

// Clear the output row
static void clear_row(unsigned char *row) {
    memset(row, 0, 16);
}

// Compare two buffers
static int buffers_equal(const unsigned char *a, const unsigned char *b, int len) {
    for (int i = 0; i < len; i++) {
        if (a[i] != b[i]) return 0;
    }
    return 1;
}

// Generate reference output for aligned drawing (C implementation)
static void generate_reference(unsigned char *out, unsigned char *map_row, const unsigned char *tiles_base, unsigned char in_tile_y) {
    for (int i = 0; i < 16; i++) {
        unsigned char tile = map_row[i];
        if (tile) {
            out[i] = tiles_base[tile * 8 + in_tile_y];
        }
        // Empty tiles leave buffer unchanged (should be pre-cleared)
    }
}

// Generate reference output for shifted drawing (C implementation)
static void generate_shifted_reference(unsigned char *out, unsigned char *map_row, const unsigned char *tiles_row, unsigned char shift) {
    unsigned char rshift = 8 - shift;
    for (int i = 0; i < 16; i++) {
        unsigned char t0 = map_row[i];
        unsigned char t1 = map_row[i + 1];
        unsigned char left = tiles_row[t0 * 8];
        unsigned char right = tiles_row[t1 * 8];
        out[i] = (left << shift) | (right >> rshift);
    }
}

// Flash border to indicate test result
static void indicate_result(int passed) {
    if (passed) {
        zx_border(INK_GREEN);
    } else {
        zx_border(INK_RED);
    }
    // Brief delay
    for (volatile int i = 0; i < 10000; i++);
}

// Run a single aligned test case
static int run_test(const char *name, unsigned char *map, unsigned char in_tile_y) {
    unsigned char *asm_out = offscreen_buffer;
    
    // Clear buffers
    clear_row(asm_out);
    clear_row(reference_buffer);
    
    // Generate reference output
    generate_reference(reference_buffer, map, test_tiles, in_tile_y);
    
    // Run assembly function
    draw_aligned_asm(asm_out, map, test_tiles, in_tile_y);
    
    // Compare results
    int passed = buffers_equal(asm_out, reference_buffer, 16);
    
    if (passed) {
        tests_passed++;
    } else {
        tests_failed++;
    }
    
    indicate_result(passed);
    return passed;
}

// Run a single shifted test case
static int run_shifted_test(const char *name, unsigned char *map, unsigned char in_tile_y, unsigned char shift) {
    unsigned char *asm_out = offscreen_buffer;
    const unsigned char *tiles_row = test_tiles + in_tile_y;
    
    // Clear buffers
    clear_row(asm_out);
    clear_row(reference_buffer);
    
    // Generate reference output
    generate_shifted_reference(reference_buffer, map, tiles_row, shift);
    
    // Run assembly function
    draw_shifted_asm(asm_out, map, tiles_row, shift);
    
    // Compare results
    int passed = buffers_equal(asm_out, reference_buffer, 16);
    
    if (passed) {
        tests_passed++;
    } else {
        tests_failed++;
    }
    
    indicate_result(passed);
    return passed;
}

// Test 1: All empty tiles
static int test_all_empty(void) {
    memset(test_map, 0, 16);
    return run_test("All empty", test_map, 0);
}

// Test 2: All solid tiles (tile 1)
static int test_all_solid(void) {
    memset(test_map, 1, 16);
    return run_test("All solid", test_map, 0);
}

// Test 3: Alternating empty and solid
static int test_alternating(void) {
    for (int i = 0; i < 16; i++) {
        test_map[i] = (i & 1) ? 1 : 0;
    }
    return run_test("Alternating", test_map, 0);
}

// Test 4: Single tile at position 0
static int test_first_tile_only(void) {
    memset(test_map, 0, 16);
    test_map[0] = 1;
    return run_test("First tile only", test_map, 0);
}

// Test 5: Single tile at position 15 (last tile - critical for inc e overflow)
static int test_last_tile_only(void) {
    memset(test_map, 0, 16);
    test_map[15] = 1;
    return run_test("Last tile only", test_map, 0);
}

// Test 6: All tile Y offsets (0-7) - tests 8-pixel boundary handling
static int test_all_y_offsets(void) {
    int all_passed = 1;
    memset(test_map, 2, 16);  // Use tile 2 (alternating pattern)
    
    for (unsigned char y = 0; y < 8; y++) {
        if (!run_test("Y offset", test_map, y)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// Test 7: Mixed tiles with all Y offsets
static int test_mixed_tiles_all_y(void) {
    int all_passed = 1;
    
    // Set up mixed tile pattern
    for (int i = 0; i < 16; i++) {
        test_map[i] = i % 4;  // Cycles through tiles 0, 1, 2, 3
    }
    
    for (unsigned char y = 0; y < 8; y++) {
        if (!run_test("Mixed Y", test_map, y)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// Test 8: Only rightmost tiles non-empty (boundary test)
static int test_right_edge(void) {
    int all_passed = 1;
    
    for (unsigned char y = 0; y < 8; y++) {
        memset(test_map, 0, 16);
        test_map[14] = 1;
        test_map[15] = 2;
        if (!run_test("Right edge", test_map, y)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// Test 9: Tile 3 (gradient) at all positions
static int test_gradient_tile(void) {
    int all_passed = 1;
    
    for (int pos = 0; pos < 16; pos++) {
        memset(test_map, 0, 16);
        test_map[pos] = 3;
        
        for (unsigned char y = 0; y < 8; y++) {
            if (!run_test("Gradient", test_map, y)) {
                all_passed = 0;
            }
        }
    }
    return all_passed;
}

// Test 10: Stress test - rapid consecutive calls
static int test_stress(void) {
    int all_passed = 1;
    
    for (int iter = 0; iter < 100; iter++) {
        // Randomish pattern based on iteration
        for (int i = 0; i < 16; i++) {
            test_map[i] = (iter + i) % 4;
        }
        unsigned char y = iter % 8;
        
        if (!run_test("Stress", test_map, y)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// ============================================================================
// SHIFTED DRAWING TESTS (draw_shifted_asm)
// ============================================================================

// Test 11: Shifted - all solid tiles, all shift values
static int test_shifted_all_solid(void) {
    int all_passed = 1;
    memset(test_map, 1, 17);  // Need 17 for blending
    
    for (unsigned char shift = 1; shift <= 7; shift++) {
        if (!run_shifted_test("Shifted solid", test_map, 0, shift)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// Test 12: Shifted - alternating tiles
static int test_shifted_alternating(void) {
    int all_passed = 1;
    for (int i = 0; i < 17; i++) {
        test_map[i] = (i & 1) ? 1 : 2;
    }
    
    for (unsigned char shift = 1; shift <= 7; shift++) {
        if (!run_shifted_test("Shifted alt", test_map, 0, shift)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// Test 13: Shifted - empty tiles (verifies zeros)
static int test_shifted_empty(void) {
    int all_passed = 1;
    memset(test_map, 0, 17);
    
    for (unsigned char shift = 1; shift <= 7; shift++) {
        if (!run_shifted_test("Shifted empty", test_map, 0, shift)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// Test 14: 8-pixel boundary - shift 1 (7 pixels from boundary)
static int test_shift_boundary_1(void) {
    int all_passed = 1;
    
    // Mixed pattern to catch blending errors
    for (int i = 0; i < 17; i++) {
        test_map[i] = i % 4;
    }
    
    // Test with all Y offsets at shift=1
    for (unsigned char y = 0; y < 8; y++) {
        if (!run_shifted_test("Boundary shift=1", test_map, y, 1)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// Test 15: 8-pixel boundary - shift 7 (1 pixel from boundary)
static int test_shift_boundary_7(void) {
    int all_passed = 1;
    
    // Mixed pattern
    for (int i = 0; i < 17; i++) {
        test_map[i] = i % 4;
    }
    
    // Test with all Y offsets at shift=7
    for (unsigned char y = 0; y < 8; y++) {
        if (!run_shifted_test("Boundary shift=7", test_map, y, 7)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// Test 16: All shifts with all Y offsets (comprehensive boundary test)
static int test_all_shifts_all_y(void) {
    int all_passed = 1;
    
    // Gradient pattern for maximum coverage
    for (int i = 0; i < 17; i++) {
        test_map[i] = (i * 3) % 4;
    }
    
    for (unsigned char shift = 1; shift <= 7; shift++) {
        for (unsigned char y = 0; y < 8; y++) {
            if (!run_shifted_test("All shifts", test_map, y, shift)) {
                all_passed = 0;
            }
        }
    }
    return all_passed;
}

// Test 17: Shifted with gradient tile (verifies bit patterns)
static int test_shifted_gradient(void) {
    int all_passed = 1;
    
    // Use gradient tile (tile 3) which has unique values per row
    for (int i = 0; i < 17; i++) {
        test_map[i] = 3;
    }
    
    for (unsigned char shift = 1; shift <= 7; shift++) {
        for (unsigned char y = 0; y < 8; y++) {
            if (!run_shifted_test("Shifted gradient", test_map, y, shift)) {
                all_passed = 0;
            }
        }
    }
    return all_passed;
}

// Test 18: Shifted stress test
static int test_shifted_stress(void) {
    int all_passed = 1;
    
    for (int iter = 0; iter < 50; iter++) {
        for (int i = 0; i < 17; i++) {
            test_map[i] = (iter + i * 2) % 4;
        }
        unsigned char y = iter % 8;
        unsigned char shift = (iter % 7) + 1;
        
        if (!run_shifted_test("Shifted stress", test_map, y, shift)) {
            all_passed = 0;
        }
    }
    return all_passed;
}

// Main test runner
int main(void) {
    zx_cls(PAPER_BLACK | INK_WHITE);
    zx_border(INK_BLUE);
    
    // === ALIGNED DRAWING TESTS ===
    test_all_empty();
    test_all_solid();
    test_alternating();
    test_first_tile_only();
    test_last_tile_only();
    test_all_y_offsets();
    test_mixed_tiles_all_y();
    test_right_edge();
    test_gradient_tile();
    test_stress();
    
    // === SHIFTED DRAWING TESTS ===
    test_shifted_all_solid();
    test_shifted_alternating();
    test_shifted_empty();
    test_shift_boundary_1();
    test_shift_boundary_7();
    test_all_shifts_all_y();
    test_shifted_gradient();
    test_shifted_stress();
    
    // Final result
    if (tests_failed == 0) {
        // All tests passed - solid green border
        zx_border(INK_GREEN);
    } else {
        // Some tests failed - solid red border
        zx_border(INK_RED);
    }
    
    // Halt
    while (1);
    
    return 0;
}
