Z88DK ?= $(HOME)/z88dk
ZCC ?= $(Z88DK)/bin/zcc
ZCCCFG ?= $(Z88DK)/lib/config
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

HOSTCC ?= cc
CONFIG_MK ?= config/basic_config.mk

# Load config (defines MAP_CSV and TILES_ZXP). Still overridable on make command line.
include $(CONFIG_MK)

CFLAGS=+zx -vn -SO3 -zorg=32768 -startup=31 --opt-code-speed -compiler=sdcc -clib=sdcc_iy -mz80
USER_CFLAGS ?=
LDFLAGS=-lm -create-app

all: scroll.tap

.PHONY: all run clean

run: scroll.tap
	$(FUSE_RUN)

# Assemble tile data standalone
tiles_data.bin: tiles_data.asm
	$(Z88DK)/bin/z88dk-z80asm -b tiles_data.asm

# Contended data block: tiles (2048 bytes) + map (4608 bytes) loaded at 0x6000
contended_data.bin: tiles_data.bin map.bin
	cat tiles_data.bin map.bin > contended_data.bin

# Build main program (tiles_extern.asm provides _tiles=$6000, _map_data=$6800)
scroll_CODE.bin: scroll.c draw_dirty_edge.c draw_dirty_edge.asm copy_viewport_32x16.asm tiles_extern.asm hud_data.asm hud.scr
	PATH=$(Z88DK)/bin:$$PATH Z88DK=$(Z88DK) ZCCCFG=$(ZCCCFG) $(ZCC) $(CFLAGS) $(USER_CFLAGS) -o scroll scroll.c draw_dirty_edge.c draw_dirty_edge.asm copy_viewport_32x16.asm tiles_extern.asm hud_data.asm -lm

# Build tap: BASIC loader + contended data at 0x6000 + main code at 0x8000
scroll.tap: scroll_CODE.bin contended_data.bin
	$(Z88DK)/bin/z88dk-appmake +zx -b contended_data.bin -o contended_data.tap --noloader --org 24576 --blockname data
	$(Z88DK)/bin/z88dk-appmake +zx -b scroll_CODE.bin -o scroll_code.tap --noloader --org 32768 --blockname scroll
	python3 make_loader_tap.py
	cat loader.tap contended_data.tap scroll_code.tap > scroll.tap


generate_tiles: generate_tiles.c
	$(HOSTCC) -O2 -o $@ $<

tiles_data.asm: $(CONFIG_MK) $(TILES_ZXP) generate_tiles
	./generate_tiles $(TILES_ZXP) tiles_data.asm $(TILE_WIDTH_PX) $(TILE_HEIGHT_PX)

# Also generate C header (for reference/tools only)
tiles_data.h: $(CONFIG_MK) $(TILES_ZXP) generate_tiles
	./generate_tiles $(TILES_ZXP) tiles_data.h $(TILE_WIDTH_PX) $(TILE_HEIGHT_PX)

generate_map: generate_map.c
	$(HOSTCC) -O2 -o $@ $<

map.bin: $(CONFIG_MK) $(MAP_CSV) generate_map
	./generate_map $(MAP_CSV) $(MAP_WIDTH_TILES) $(MAP_HEIGHT_TILES)

map_data.h: map.bin
	xxd -i map.bin > map_data.h

clean:
	rm -f scroll scroll.tap scroll_CODE.bin scroll_data_user.bin scroll_code.tap tiles_data.tap contended_data.tap loader.tap tiles_data.bin contended_data.bin tiles_data.o *.o *.map map.bin map_data.h tiles_data.asm tiles_data.h hud_data.h generate_tiles generate_map
