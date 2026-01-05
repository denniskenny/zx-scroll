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

all: scroll

.PHONY: all run clean test testFuse
.PHONY: bench benchRun

run: scroll
	$(FUSE_RUN)

bench: bench_scroll

benchRun: bench_scroll
	$(FUSE) bench_scroll.tap

scroll: scroll.c draw_map.c tiles_data.c draw_aligned.asm draw_shifted.asm draw_shifted_block.asm copy_viewport.asm hud_data.asm hud.scr
	PATH=$(Z88DK)/bin:$$PATH Z88DK=$(Z88DK) ZCCCFG=$(ZCCCFG) $(ZCC) $(CFLAGS) $(USER_CFLAGS) -o scroll scroll.c draw_map.c tiles_data.c draw_aligned.asm draw_shifted.asm draw_shifted_block.asm copy_viewport.asm hud_data.asm $(LDFLAGS)

bench_scroll: map_data.h tiles_data.h

bench_scroll: bench_scroll.c draw_map.c tiles_data.c draw_aligned.asm draw_shifted.asm draw_shifted_block.asm copy_viewport.asm
	PATH=$(Z88DK)/bin:$$PATH Z88DK=$(Z88DK) ZCCCFG=$(ZCCCFG) $(ZCC) $(CFLAGS) $(USER_CFLAGS) -o bench_scroll bench_scroll.c draw_map.c tiles_data.c draw_aligned.asm draw_shifted.asm draw_shifted_block.asm copy_viewport.asm $(LDFLAGS)

scroll: map_data.h

scroll: tiles_data.h

generate_tiles: generate_tiles.c
	$(HOSTCC) -O2 -o $@ $<

tiles_data.h: $(CONFIG_MK) $(TILES_ZXP) generate_tiles
	./generate_tiles $(TILES_ZXP) tiles_data.h $(TILE_WIDTH_PX) $(TILE_HEIGHT_PX)

generate_map: generate_map.c
	$(HOSTCC) -O2 -o $@ $<

map.bin: $(CONFIG_MK) $(MAP_CSV) generate_map
	./generate_map $(MAP_CSV) $(MAP_WIDTH_TILES) $(MAP_HEIGHT_TILES)

map_data.h: map.bin
	xxd -i map.bin > map_data.h

test: test_draw_fast.c draw_aligned.asm draw_shifted.asm
	PATH=$(Z88DK)/bin:$$PATH Z88DK=$(Z88DK) ZCCCFG=$(ZCCCFG) $(ZCC) +zx -vn -SO3 -startup=31 -clib=sdcc_iy -mz80 $(USER_CFLAGS) test_draw_fast.c draw_aligned.asm draw_shifted.asm -o test_draw -create-app

testFuse: test
	$(FUSE_TEST)

clean:
	rm -f scroll scroll.tap scroll_CODE.bin scroll_data_user.bin test_draw test_draw.tap test_draw_CODE.bin test_draw_data_user.bin *.o *.map map.bin map_data.h tiles_data.h hud_data.h
