# --- Toolchain ---
Z88DK ?= $(HOME)/z88dk
ZCC ?= $(Z88DK)/bin/zcc
ZCCCFG ?= $(Z88DK)/lib/config
HOSTCC ?= cc
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
FUSE ?= open -a Fuse
FUSE_RUN = $(FUSE) scroll.tap
FUSE_TEST = $(FUSE) test_draw.tap
else
FUSE ?= fuse-sdl
FUSE_RUN = $(FUSE) scroll.tap &
FUSE_TEST = $(FUSE) test_draw.tap &
endif

# --- Config ---
CONFIG_MK ?= config/basic_config.mk
include $(CONFIG_MK)

CFLAGS=+zx -vn -SO3 -zorg=32768 -startup=31 --opt-code-speed -compiler=sdcc -clib=sdcc_iy -mz80
USER_CFLAGS ?=
LDFLAGS=-lm -create-app

# --- Top-level targets ---
all: scroll.tap

.PHONY: all run maze clean

run: scroll.tap
	$(FUSE_RUN)

# Build with 16maze TMX map (extracts CSV, then builds scroll.tap)
maze: config/16maze_map.csv
	$(MAKE) MAP_CSV=config/16maze_map.csv MAP_WIDTH_TILES=96 MAP_HEIGHT_TILES=48

# --- Host tools ---
generate_tiles: generate_tiles.c
	$(HOSTCC) -O2 -o $@ $<

generate_map: generate_map.c
	$(HOSTCC) -O2 -o $@ $<

# --- TMX-to-CSV conversion (subtract 1 from Tiled's 1-based tile IDs) ---
config/16maze_map.csv: assets/16maze.tmx
	sed -n '/<data encoding="csv">/,/<\/data>/{/<data/d;/<\/data>/d;p;}' $< | python3 -c "import sys;[print(','.join(str(int(v)-1) for v in line.strip().rstrip(',').split(',') if v.strip())) for line in sys.stdin if line.strip()]" > $@

# --- Asset generation ---
tiles_data.asm: $(CONFIG_MK) $(TILES_ZXP) generate_tiles
	./generate_tiles $(TILES_ZXP) tiles_data.asm $(TILE_WIDTH_PX) $(TILE_HEIGHT_PX)

tiles_data.h: $(CONFIG_MK) $(TILES_ZXP) generate_tiles
	./generate_tiles $(TILES_ZXP) tiles_data.h $(TILE_WIDTH_PX) $(TILE_HEIGHT_PX)

map.bin: $(CONFIG_MK) $(MAP_CSV) generate_map
	./generate_map $(MAP_CSV) $(MAP_WIDTH_TILES) $(MAP_HEIGHT_TILES)

map_data.h: map.bin
	xxd -i map.bin > map_data.h

# --- Binary assembly ---
tiles_data.bin: tiles_data.asm
	$(Z88DK)/bin/z88dk-z80asm -b tiles_data.asm

contended_data.bin: tiles_data.bin map.bin
	cat tiles_data.bin map.bin > contended_data.bin

# --- Compile & link ---
scroll_CODE.bin: scroll.c tile_render.c tile_render_direct.asm tiles_extern.asm hud_data.asm hud.scr tile_render.h
	PATH=$(Z88DK)/bin:$$PATH Z88DK=$(Z88DK) ZCCCFG=$(ZCCCFG) $(ZCC) $(CFLAGS) $(USER_CFLAGS) -o scroll scroll.c tile_render.c tile_render_direct.asm tiles_extern.asm hud_data.asm -lm

# --- TAP packaging ---
scroll.tap: scroll_CODE.bin contended_data.bin
	$(Z88DK)/bin/z88dk-appmake +zx -b contended_data.bin -o contended_data.tap --noloader --org 24576 --blockname data
	$(Z88DK)/bin/z88dk-appmake +zx -b scroll_CODE.bin -o scroll_code.tap --noloader --org 32768 --blockname scroll
	python3 make_loader_tap.py
	cat loader.tap contended_data.tap scroll_code.tap > scroll.tap

# --- Clean ---
clean:
	rm -f scroll scroll.tap scroll_CODE.bin scroll_data_user.bin scroll_code.tap tiles_data.tap contended_data.tap loader.tap tiles_data.bin contended_data.bin tiles_data.o *.o *.map map.bin map_data.h tiles_data.asm tiles_data.h hud_data.h generate_tiles generate_map config/16maze_map.csv
