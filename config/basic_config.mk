# Basic sample game build config

MAP_CSV := config/basic_map.csv
TILES_ZXP := assets/basic_tiles16x16.zxp

MAP_WIDTH_TILES := 96
MAP_HEIGHT_TILES := 48

TILE_WIDTH_PX := 8
TILE_HEIGHT_PX := 8

# Note: Original 128x128 buffer stays at 0xD000 (default)
# The 32x16 dirty-edge buffer is at 0xF000
