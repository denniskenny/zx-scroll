// test_scroll.c - Performance tests for dirty-edge scrolling
#include <arch/spectrum.h>
#include <intrinsic.h>
#include <string.h>
#include <stdio.h>
#include "draw_dirty_edge.h"
#include "tiles_data.h"
#include "map_data.h"

#define MAP_WIDTH 96
#define MAP_HEIGHT 48

extern unsigned char offscreen_buffer_32x16[];
unsigned char map_data[MAP_WIDTH * MAP_HEIGHT];

// Frame counter for timing
static unsigned int frame_count;

// Simple frame counter using HALT
static void count_frames(unsigned int count) {
    frame_count = 0;
    while (frame_count < count) {
        intrinsic_halt();
        frame_count++;
    }
}

// Test horizontal scroll (left shift) performance
static void test_scroll_left(unsigned int iterations) {
    unsigned int i;
    int camera_x = 100;
    int camera_y = 100;
    
    zx_border(INK_RED);
    
    for (i = 0; i < iterations; i++) {
        dirty_edge_scroll(SCROLL_X_PLUS, map_data, tiles, offscreen_buffer_32x16,
                         &camera_x, &camera_y, MAP_WIDTH, MAP_HEIGHT, 1);
    }
    
    zx_border(INK_BLACK);
}

// Test horizontal scroll (right shift) performance
static void test_scroll_right(unsigned int iterations) {
    unsigned int i;
    int camera_x = 100;
    int camera_y = 100;
    
    zx_border(INK_GREEN);
    
    for (i = 0; i < iterations; i++) {
        dirty_edge_scroll(SCROLL_X_MINUS, map_data, tiles, offscreen_buffer_32x16,
                         &camera_x, &camera_y, MAP_WIDTH, MAP_HEIGHT, 1);
    }
    
    zx_border(INK_BLACK);
}

// Test vertical scroll (up) performance
static void test_scroll_up(unsigned int iterations) {
    unsigned int i;
    int camera_x = 100;
    int camera_y = 100;
    
    zx_border(INK_BLUE);
    
    for (i = 0; i < iterations; i++) {
        dirty_edge_scroll(SCROLL_Y_PLUS, map_data, tiles, offscreen_buffer_32x16,
                         &camera_x, &camera_y, MAP_WIDTH, MAP_HEIGHT, 1);
    }
    
    zx_border(INK_BLACK);
}

// Test vertical scroll (down) performance
static void test_scroll_down(unsigned int iterations) {
    unsigned int i;
    int camera_x = 100;
    int camera_y = 100;
    
    zx_border(INK_CYAN);
    
    for (i = 0; i < iterations; i++) {
        dirty_edge_scroll(SCROLL_Y_MINUS, map_data, tiles, offscreen_buffer_32x16,
                         &camera_x, &camera_y, MAP_WIDTH, MAP_HEIGHT, 1);
    }
    
    zx_border(INK_BLACK);
}

// Test diagonal scroll performance
static void test_scroll_diagonal(unsigned int iterations) {
    unsigned int i;
    int camera_x = 50;
    int camera_y = 50;
    
    zx_border(INK_MAGENTA);
    
    for (i = 0; i < iterations; i++) {
        dirty_edge_scroll(SCROLL_X_PLUS | SCROLL_Y_PLUS, map_data, tiles, offscreen_buffer_32x16,
                         &camera_x, &camera_y, MAP_WIDTH, MAP_HEIGHT, 1);
    }
    
    zx_border(INK_BLACK);
}

// Test viewport blit performance
static void test_viewport_blit(unsigned int iterations) {
    unsigned int i;
    
    zx_border(INK_YELLOW);
    
    for (i = 0; i < iterations; i++) {
        copy_viewport_32x16_to_screen(offscreen_buffer_32x16);
    }
    
    zx_border(INK_BLACK);
}

int main(void) {
    // Initialize
    zx_border(INK_BLACK);
    zx_cls(PAPER_BLACK | INK_WHITE);
    memcpy(map_data, map_bin, MAP_WIDTH * MAP_HEIGHT);
    memset(offscreen_buffer_32x16, 0x55, DIRTY_BUFFER_SIZE);
    
    // Run tests - 50 iterations each
    // Watch border color to see which test is running
    // RED = scroll left, GREEN = scroll right
    // BLUE = scroll up, CYAN = scroll down
    // MAGENTA = diagonal, YELLOW = blit
    
    while (1) {
        test_scroll_left(50);
        count_frames(25);
        
        test_scroll_right(50);
        count_frames(25);
        
        test_scroll_up(50);
        count_frames(25);
        
        test_scroll_down(50);
        count_frames(25);
        
        test_scroll_diagonal(50);
        count_frames(25);
        
        test_viewport_blit(50);
        count_frames(25);
    }
    
    return 0;
}
