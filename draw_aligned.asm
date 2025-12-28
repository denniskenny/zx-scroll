; draw_aligned.asm - Fast aligned tile drawing for ZX Spectrum scroller
; Optimized Z80 assembly for maximum performance

    SECTION code_user

    PUBLIC _draw_aligned_asm

; void draw_aligned_asm(unsigned char *row, unsigned char *map_row, const unsigned char *tiles_base, unsigned char in_tile_y)
_draw_aligned_asm:
    push ix
    ld ix, 0
    add ix, sp
    
    di                   ; Disable interrupts (no need to save alt regs)
    
    ; Load parameters into main registers
    ld e, (ix+4)         ; row low
    ld d, (ix+5)         ; row high - DE = row pointer
    ld l, (ix+6)         ; map_row low
    ld h, (ix+7)         ; map_row high - HL = map_row
    
    ; Precompute tiles_base + in_tile_y
    ld c, (ix+8)         ; tiles_base low
    ld b, (ix+9)         ; tiles_base high
    ld a, (ix+10)        ; in_tile_y
    add a, c             ; tiles_base_low + in_tile_y
    ld c, a
    jr nc, no_carry
    inc b
no_carry:
    ; Store tiles_base + in_tile_y in alternate DE'
    push bc              ; save on stack (before exx!)
    exx
    pop de               ; pop into DE' from stack
    ld b, 0              ; B' = 0 for resetting H' each tile
    exx
    
    ; Process 16 tiles (no empty check - tile 0 produces 0x00 anyway)
    ; Tile 0
    ld a, (hl)
    exx                  ; switch to alt registers
    ld l, a
    ld h, b              ; H' = 0 (B' is 0)
    add hl, hl
    add hl, hl
    add hl, hl           ; HL' = tile * 8
    add hl, de           ; HL' = tiles_base + in_tile_y + tile*8
    ld a, (hl)           ; get tile byte
    exx                  ; switch back
    ld (de), a           ; store to row
    inc hl
    inc e
    
    ; Tile 1
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 2
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 3
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 4
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 5
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 6
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 7
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 8
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 9
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 10
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 11
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 12
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 13
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 14
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    inc hl
    inc e
    
    ; Tile 15
    ld a, (hl)
    exx
    ld l, a
    ld h, b
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld a, (hl)
    exx
    ld (de), a
    
    ei                   ; Re-enable interrupts
    pop ix
    ret

; Aligned buffer for offscreen rendering
; Placed at 0xC000 (uncontended RAM, 256-byte aligned for safe inc e)
    SECTION data_user
    PUBLIC _offscreen_buffer
    
    ORG 0xC000
_offscreen_buffer:
    DEFS 2048            ; 16 * 16 * 8 bytes
