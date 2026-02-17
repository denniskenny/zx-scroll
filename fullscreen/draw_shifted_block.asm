; draw_shifted_block.asm - Draw 8 scanlines per call for shifted scrolling
;
; void draw_shifted_block_asm(unsigned char *row, unsigned char *map_row,
;                             const unsigned char *tiles_base, unsigned char in_tile_y,
;                             unsigned char shift, unsigned char map_stride)

    SECTION code_user

    PUBLIC _draw_shifted_block_asm

_draw_shifted_block_asm:
    push ix
    ld ix, 0
    add ix, sp

    ; Compute lshift table address from shift value (1-7)
    ld a, (ix+11)        ; shift (1-7)
    dec a                ; 0-6
    add a, a             ; *2
    ld hl, lshift_table_addrs
    add a, l
    ld l, a
    jr nc, no_carry_l_b
    inc h
no_carry_l_b:
    ld a, (hl)
    inc hl
    ld h, (hl)
    ld l, a
    ld (block_lshift_addr), hl

    ; Compute rshift table address (rshift = 8 - shift)
    ld a, (ix+11)
    ld c, a
    ld a, 8
    sub c
    dec a
    add a, a
    ld hl, rshift_table_addrs
    add a, l
    ld l, a
    jr nc, no_carry_r_b
    inc h
no_carry_r_b:
    ld a, (hl)
    inc hl
    ld h, (hl)
    ld l, a
    ld (block_rshift_addr), hl

    ; DE = output row
    ld e, (ix+4)
    ld d, (ix+5)

    ; HL = map_row base
    ld l, (ix+6)
    ld h, (ix+7)
    ld (block_map_row0), hl

    ; map_stride
    ld a, (ix+12)
    ld (block_map_stride), a

    ; compute map_row1 = map_row0 + map_stride
    ld a, l
    add a, (ix+12)
    ld l, a
    jr nc, no_carry_m1
    inc h
no_carry_m1:
    ld (block_map_row1), hl

    ; tiles_base
    ld a, (ix+8)
    ld (block_tiles_base_lo), a
    ld a, (ix+9)
    ld (block_tiles_base_hi), a

    ; in_tile_y start
    ld a, (ix+10)
    ld (block_y), a

    ; use_next = 0
    xor a
    ld (block_use_next), a

    ld b, 8

block_line_loop:
    ; Select map row pointer based on use_next flag
    ld a, (block_use_next)
    or a
    jr z, use_row0
    ld hl, (block_map_row1)
    jr row_selected
use_row0:
    ld hl, (block_map_row0)
row_selected:

    ; tiles_row = tiles_base + y
    ld a, (block_tiles_base_lo)
    ld c, a
    ld a, (block_tiles_base_hi)
    ld h, a
    ld a, (block_y)
    add a, c
    ld l, a
    jr nc, no_carry_t
    inc h
no_carry_t:
    ld a, l
    ld (block_tiles_row_lo), a
    ld a, h
    ld (block_tiles_row_hi), a

    ; Restore HL map row pointer for line core
    ld a, (block_use_next)
    or a
    jr z, use_row0b
    ld hl, (block_map_row1)
    jr row_selected_b
use_row0b:
    ld hl, (block_map_row0)
row_selected_b:

    push bc
    call block_draw_shifted_line
    pop bc

    ; advance y, handle wrap and use_next
    ld a, (block_y)
    inc a
    cp 8
    jr nz, store_y
    xor a
    inc a
    ld (block_use_next), a
    xor a
store_y:
    ld (block_y), a

    dec b
    jp nz, block_line_loop

    pop ix
    ret

; Draw a single shifted scanline using precomputed block_lshift_addr/block_rshift_addr
; Inputs:
;   DE = output row pointer (advanced by 16)
;   HL = map_row pointer (not preserved)
block_draw_shifted_line:
    ; Cache tiles_row pointer bytes
    ld a, (block_tiles_row_lo)
    ld (block_tiles_row_lo_cached), a
    ld a, (block_tiles_row_hi)
    ld (block_tiles_row_hi_cached), a

    ld b, 8

block_tile_loop:
    ld a, (hl)
    inc hl
    ld c, (hl)
    dec hl
    ld a, c
    or (hl)
    jr nz, block_do_byte1
    inc hl
    xor a
    ld (de), a
    inc de
    jr block_byte1_done

block_do_byte1:
    ld a, (hl)
    inc hl
    ex af, af'
    ld a, (hl)
    push hl
    ex af, af'

    add a, a
    add a, a
    add a, a
    ld l, a
    ld a, (block_tiles_row_lo_cached)
    add a, l
    ld l, a
    ld a, (block_tiles_row_hi_cached)
    adc a, 0
    ld h, a
    ld a, (hl)

    ld hl, (block_lshift_addr)
    add a, l
    ld l, a
    jr nc, block_no_carry_left
    inc h
block_no_carry_left:
    ld a, (hl)
    ld c, a

    ex af, af'
    add a, a
    add a, a
    add a, a
    ld l, a
    ld a, (block_tiles_row_lo_cached)
    add a, l
    ld l, a
    ld a, (block_tiles_row_hi_cached)
    adc a, 0
    ld h, a
    ld a, (hl)

    ld hl, (block_rshift_addr)
    add a, l
    ld l, a
    jr nc, block_no_carry_right
    inc h
block_no_carry_right:
    ld a, (hl)

    or c
    ld (de), a
    inc de

    pop hl

block_byte1_done:

    ld a, (hl)
    inc hl
    ld c, (hl)
    dec hl
    ld a, c
    or (hl)
    jr nz, block_do_byte2
    inc hl
    xor a
    ld (de), a
    inc de
    jr block_byte2_done

block_do_byte2:
    ld a, (hl)
    inc hl
    ex af, af'
    ld a, (hl)
    push hl
    ex af, af'

    add a, a
    add a, a
    add a, a
    ld l, a
    ld a, (block_tiles_row_lo_cached)
    add a, l
    ld l, a
    ld a, (block_tiles_row_hi_cached)
    adc a, 0
    ld h, a
    ld a, (hl)

    ld hl, (block_lshift_addr)
    add a, l
    ld l, a
    jr nc, block_no_carry_left2
    inc h
block_no_carry_left2:
    ld a, (hl)
    ld c, a

    ex af, af'
    add a, a
    add a, a
    add a, a
    ld l, a
    ld a, (block_tiles_row_lo_cached)
    add a, l
    ld l, a
    ld a, (block_tiles_row_hi_cached)
    adc a, 0
    ld h, a
    ld a, (hl)

    ld hl, (block_rshift_addr)
    add a, l
    ld l, a
    jr nc, block_no_carry_right2
    inc h
block_no_carry_right2:
    ld a, (hl)

    or c
    ld (de), a
    inc de

    pop hl

block_byte2_done:

    dec b
    jp nz, block_tile_loop

    ret

    SECTION bss_user
block_tiles_base_lo: DEFS 1
block_tiles_base_hi: DEFS 1
block_tiles_row_lo:  DEFS 1
block_tiles_row_hi:  DEFS 1
block_tiles_row_lo_cached: DEFS 1
block_tiles_row_hi_cached: DEFS 1
block_y: DEFS 1
block_use_next: DEFS 1
block_map_stride: DEFS 1
block_map_row0: DEFS 2
block_map_row1: DEFS 2
block_lshift_addr: DEFS 2
block_rshift_addr: DEFS 2

    SECTION rodata_user
; Reuse tables from draw_shifted.asm
    EXTERN lshift_table_addrs
    EXTERN rshift_table_addrs
