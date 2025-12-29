Z88DK_DIR=C:/Program Files/z88dk
CC=$(Z88DK_DIR)/bin/zcc
ZCCCFG=$(Z88DK_DIR)/lib/config
FUSE_APP=Fuse

CFLAGS=+zx -vn -SO3 -zorg=32768 -startup=31 --opt-code-speed -compiler=sdcc -clib=sdcc_iy -mz80
LDFLAGS=-lm -create-app

all: scrollFuse

.PHONY: all run scrollFuse clean

scrollFuse: scroll
	-powershell -Command "Start-Process '$(FUSE_APP)' -ArgumentList 'scroll.tap'"

run: scroll
	powershell -Command "Start-Process '$(FUSE_APP)' -ArgumentList 'scroll.tap'"

scroll: scroll.c draw_map.c draw_aligned.asm draw_shifted.asm copy_viewport.asm
	PATH=$(Z88DK_DIR)/bin:$$PATH Z88DK=$(Z88DK_DIR) ZCCCFG=$(ZCCCFG) $(CC) $(CFLAGS) -o scroll scroll.c draw_map.c draw_aligned.asm draw_shifted.asm copy_viewport.asm $(LDFLAGS)

test: test_draw_fast.c draw_aligned.asm draw_shifted.asm
	PATH=$(Z88DK_DIR)/bin:$$PATH Z88DK=$(Z88DK_DIR) ZCCCFG=$(ZCCCFG) $(CC) +zx -vn -SO3 -startup=31 -clib=sdcc_iy -mz80 test_draw_fast.c draw_aligned.asm draw_shifted.asm -o test_draw -create-app

testFuse: test
	powershell -Command "Start-Process '$(FUSE_APP)' -ArgumentList 'test_draw.tap'"

clean:
	-del scroll scroll.tap *.o *.bin *.map 2>nul
