; copy_viewport_32x16.asm - Blit 32x12 character (256x96 pixel) viewport to screen
; Viewport is centered: starts at screen row 6 (Y=48)
; Buffer layout: 33 bytes per scanline, 96 scanlines = 3168 bytes
; Uses 2D ring-buffer: head_row (vertical) + head_col/fine_x (horizontal)

    SECTION code_user

    PUBLIC _copy_viewport_32x16_to_screen_ring_2d
    EXTERN _offscreen_buffer_32x16

; Screen constants
SCREEN_BASE     EQU 0x4000
VIEWPORT_START_Y EQU 48          ; Centered: (192-96)/2 = 48

;------------------------------------------------------------------------------
; copy_viewport_32x16_to_screen_ring_2d - 2D ring-buffer blitter
; void copy_viewport_32x16_to_screen_ring_2d(
;     unsigned char *buffer,    ; ix+4,5
;     unsigned char head_row,   ; ix+6
;     unsigned char head_col,   ; ix+7
;     unsigned char fine_x      ; ix+8
; )
; Reads 33 bytes per row from head_col with column wrapping.
; When fine_x==0: direct copy (fast path)
; When fine_x>0:  output[i] = (src[i] << fine_x) | (src[i+1] >> (8-fine_x))
;------------------------------------------------------------------------------
_copy_viewport_32x16_to_screen_ring_2d:
    di

    push ix
    ld ix, 0
    add ix, sp

    ; Check fine_x: if 0, use fast path (no shifting)
    ld a, (ix+8)
    or a
    jp nz, _ring2d_fine        ; fine_x > 0: use shifting blitter

    ; === FAST PATH: fine_x == 0 (identical to previous 2D blitter) ===
    ld l, (ix+4)
    ld h, (ix+5)             ; HL = base buffer
    ld c, (ix+7)             ; C = head_col

    ; Compute first_bytes = min(33 - head_col, 32)
    ld a, 33
    sub c
    cp 32
    jr c, _r2d_fb_ok
    ld a, 32
_r2d_fb_ok:
    ld (_r2d_first), a
    ld b, a
    ld a, 32
    sub b
    ld (_r2d_second), a

    ; Compute buffer + head_row * 33 + head_col
    push hl                   ; save base buffer for segment B
    push hl
    ld a, (ix+6)
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld d, 0
    ld e, a
    add hl, de
    ld d, 0
    ld e, (ix+7)
    add hl, de
    ex de, hl
    pop hl
    add hl, de                ; HL = buffer + head_row*33 + head_col

    exx
    ld hl, scr_addr_table_32x16
    exx

    ; Segment A
    ld a, (ix+6)
    ld c, a
    ld a, 96
    sub c
    ld b, a
    jr z, _r2d_segb

_r2d_la:
    push bc
    exx
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push de
    exx
    pop de

    ld a, (_r2d_first)
    ld b, a
_r2d_c1a:
    ld a, (hl)
    ld (de), a
    inc hl
    inc de
    djnz _r2d_c1a

    ld a, (_r2d_second)
    or a
    jr z, _r2d_nwa

    push de
    ld de, -33
    add hl, de
    pop de
    ld b, a
_r2d_c2a:
    ld a, (hl)
    ld (de), a
    inc hl
    inc de
    djnz _r2d_c2a

    push de
    ld a, (_r2d_first)
    inc a
    ld e, a
    ld d, 0
    ld a, (ix+7)
    add a, e
    ld e, a
    add hl, de
    pop de
    jr _r2d_na

_r2d_nwa:
    inc hl

_r2d_na:
    pop bc
    djnz _r2d_la

_r2d_segb:
    pop hl
    ld d, 0
    ld e, (ix+7)
    add hl, de

    ld a, (ix+6)
    ld b, a
    or a
    jr z, _r2d_done

_r2d_lb:
    push bc
    exx
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push de
    exx
    pop de

    ld a, (_r2d_first)
    ld b, a
_r2d_c1b:
    ld a, (hl)
    ld (de), a
    inc hl
    inc de
    djnz _r2d_c1b

    ld a, (_r2d_second)
    or a
    jr z, _r2d_nwb

    push de
    ld de, -33
    add hl, de
    pop de
    ld b, a
_r2d_c2b:
    ld a, (hl)
    ld (de), a
    inc hl
    inc de
    djnz _r2d_c2b

    push de
    ld a, (_r2d_first)
    inc a
    ld e, a
    ld d, 0
    ld a, (ix+7)
    add a, e
    ld e, a
    add hl, de
    pop de
    jr _r2d_nb

_r2d_nwb:
    inc hl

_r2d_nb:
    pop bc
    djnz _r2d_lb

_r2d_done:
    pop ix
    ei
    ret

_r2d_first:
    DEFB 0
_r2d_second:
    DEFB 0

; === FINE_X > 0 PATH: shift-combine blitter with lookup tables ===
; Reads from ring buffer with inline column wrapping.
; Uses precomputed 256-byte lookup tables for shifts.
; Per output byte: ~154T (table lookups + combine + write)
;
; Strategy:
;   1. Generate shift tables for current fine_x value (once per blit)
;   2. For each row: read directly from ring buffer, use table lookups, emit
;------------------------------------------------------------------------------
_ring2d_fine:
    ; Generate shift lookup tables for this fine_x value
    ld a, (ix+8)              ; A = fine_x (1-7)
    call _generate_shift_tables

    ; Setup buffer and wrapping
    ld l, (ix+4)
    ld h, (ix+5)             ; HL = base buffer
    ld c, (ix+7)             ; C = head_col

    ; first = 33 - head_col (bytes before wrap), second = head_col (after wrap)
    ld a, 33
    sub c
    ld (_r2df_first), a
    ld a, c
    ld (_r2df_second), a

    ; Compute buffer + head_row * 33 + head_col
    push hl                   ; save base buffer for segment B
    push hl
    ld a, (ix+6)
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl               ; HL = head_row * 32
    ld d, 0
    ld e, a
    add hl, de                ; HL = head_row * 33
    ld d, 0
    ld e, (ix+7)
    add hl, de                ; HL = head_row * 33 + head_col
    ex de, hl
    pop hl
    add hl, de                ; HL = buffer + head_row*33 + head_col

    ; Screen address table in alt HL'
    exx
    ld hl, scr_addr_table_32x16
    exx

    ; Segment A: rows from head_row to 95
    ld a, (ix+6)
    ld c, a
    ld a, 96
    sub c
    ld b, a
    jp z, _r2df_segb

_r2df_la:
    push bc
    push hl                   ; save source row start

    ; Get screen dest from table
    exx
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push de
    exx
    pop de                    ; DE = screen address

    ; Emit 32 output bytes reading directly from ring buffer
    ; HL = buffer row at head_col position
    ; Pass first/second in BC for wrapping
    ld a, (_r2df_first)
    ld b, a                   ; B = bytes before wrap
    ld a, (_r2df_second)
    ld c, a                   ; C = bytes after wrap
    call _r2df_emit_row

    ; Advance source to next row (add 33 to saved row start)
    pop hl
    push de
    ld de, 33
    add hl, de
    pop de

    pop bc
    djnz _r2df_la

_r2df_segb:
    pop hl                    ; HL = base buffer
    ld d, 0
    ld e, (ix+7)
    add hl, de                ; HL = base buffer + head_col

    ld a, (ix+6)
    ld b, a
    or a
    jp z, _r2df_done

_r2df_lb:
    push bc
    push hl

    exx
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push de
    exx
    pop de

    ; Pass first/second in BC for wrapping
    ld a, (_r2df_first)
    ld b, a
    ld a, (_r2df_second)
    ld c, a
    call _r2df_emit_row

    pop hl
    push de
    ld de, 33
    add hl, de
    pop de

    pop bc
    djnz _r2df_lb

_r2df_done:
    pop ix
    ei
    ret

;----------------------------------------------------------------------
; _generate_shift_tables: Generate lookup tables for current fine_x
; Input: A = fine_x (1-7)
; Generates: shl_table[i] = i << fine_x, shr_table[i] = i >> (8-fine_x)
; Cost: ~65,000T (once per blit), saves ~100,000T during emission
;----------------------------------------------------------------------
_generate_shift_tables:
    push bc
    push de
    push hl
    
    ld b, a                   ; B = fine_x
    ld a, 8
    sub b
    ld c, a                   ; C = comp_x = 8 - fine_x
    
    ; Generate shl_table: for i=0 to 255, table[i] = i << fine_x
    ld hl, _shift_shl_table
    ld d, 0                   ; D = byte value (0-255)
_gen_shl_loop:
    ld a, d                   ; A = byte value
    ld e, b                   ; E = shift count (fine_x)
_gen_shl_shift:
    or a                      ; clear carry
    jr z, _gen_shl_done_shift
    sla a
    dec e
    jr nz, _gen_shl_shift
_gen_shl_done_shift:
    ld (hl), a                ; store shifted value
    inc hl
    inc d
    jr nz, _gen_shl_loop      ; loop until D wraps to 0
    
    ; Generate shr_table: for i=0 to 255, table[i] = i >> comp_x
    ld hl, _shift_shr_table
    ld d, 0                   ; D = byte value (0-255)
_gen_shr_loop:
    ld a, d                   ; A = byte value
    ld e, c                   ; E = shift count (comp_x)
_gen_shr_shift:
    or a                      ; clear carry
    jr z, _gen_shr_done_shift
    srl a
    dec e
    jr nz, _gen_shr_shift
_gen_shr_done_shift:
    ld (hl), a                ; store shifted value
    inc hl
    inc d
    jr nz, _gen_shr_loop      ; loop until D wraps to 0
    
    pop hl
    pop de
    pop bc
    ret

;----------------------------------------------------------------------
; _r2df_emit_row: emit 32 shift-combined bytes reading directly from ring buffer
; Input: HL = source row at head_col, DE = screen address
;        B = bytes before wrap (first), C = bytes after wrap (second)
; Output: 32 bytes to screen with shift-combine
; Destroys: A, B, C, HL, DE
;
; Strategy: linearize 33 source bytes into temp buffer, then use SP trick.
; Linearize cost: ~430T. SP trick saves ~2,400T vs old loop. Net: ~2,000T/row.
;----------------------------------------------------------------------
_r2df_emit_row:
    ; Check if wrapping needed (B == 33 means head_col == 0, no wrap)
    ld a, b
    cp 33
    jp z, _r2df_emit_nowrap

    ; Wrapping path: linearize 33 source bytes into _r2df_temp using LDIR
    ; First B bytes from HL (head_col to end), then C bytes from column 0
    ; LDIR = 16T/byte vs djnz loop = 39T/byte. Saves ~760T/row.
    push de                   ; save screen address

    ; Copy first segment: B bytes from HL
    ld de, _r2df_temp
    ld c, b
    ld b, 0                   ; BC = first count
    ldir                      ; copy first segment (16T/byte)

    ; Wrap: HL is now past end of row, go back to column 0
    push de                   ; save temp dest position
    ld de, -33
    add hl, de
    pop de                    ; restore temp dest

    ; Copy second segment: C bytes from column 0
    ld a, (_r2df_second)
    or a
    jr z, _r2df_lin_done
    ld c, a
    ld b, 0                   ; BC = second count
    ldir                      ; copy second segment (16T/byte)

_r2df_lin_done:
    pop de                    ; restore screen address

    ; Now use SP trick on the linear temp buffer (same as no-wrap path)
    ld (_r2df_save_sp2), sp
    ld sp, _r2df_temp

    REPT 32
    pop bc                    ; 10T - C = prev, B = next (peek)
    dec sp                    ; 6T  - overlap

    ld a, c                   ; 4T
    ld hl, _shift_shl_table   ; 10T
    add a, l                  ; 4T
    ld l, a                   ; 4T
    jr nc, $ + 3              ; 7T
    inc h                     ; 4T
    ld c, (hl)                ; 7T - C = prev << fine_x

    ld a, b                   ; 4T
    ld hl, _shift_shr_table   ; 10T
    add a, l                  ; 4T
    ld l, a                   ; 4T
    jr nc, $ + 3              ; 7T
    inc h                     ; 4T
    ld a, (hl)                ; 7T - A = next >> comp_x

    or c                      ; 4T
    ld (de), a                ; 7T
    inc de                    ; 6T
    ENDR

    ld sp, (_r2df_save_sp2)
    ret

_r2df_save_sp2:
    DEFW 0
_r2df_temp:
    DEFS 33                   ; 33-byte linearization buffer

; No-wrap path: head_col == 0, fully unrolled 32 iterations
; Saves 13T per byte (djnz) = 416T per row = ~40,000T per blit
; Uses SP trick: save SP, set SP = source, use pop to read pairs
; Then HL is free for table lookups without push/pop
;
; Strategy: save real SP, point SP at source buffer.
; For each output byte:
;   pop bc -> C = prev, B = next (peek)
;   dec sp -> back up 1 byte so next pop overlaps correctly
;   shl lookup on C, shr lookup on B, combine, write to (DE)
;
; Cost per byte: pop(10) + dec sp(6) + shl lookup(21) + shr lookup(21)
;                + or(4) + ld(de),a(7) + inc de(6) = 75T
; vs old: 148T per byte = ~49% faster!
_r2df_emit_nowrap:
    ; Save real SP and set SP = source pointer (HL)
    ld (_r2df_save_sp), sp
    ld sp, hl                 ; SP = source buffer pointer

    ; DE = screen address (already set)
    ; Now HL is free for table lookups

    REPT 32
    pop bc                    ; 10T - C = prev byte, B = next byte (peek)
    dec sp                    ; 6T  - back up 1 so next pop overlaps

    ; shl lookup on C (prev << fine_x)
    ld a, c                   ; 4T
    ld hl, _shift_shl_table   ; 10T
    add a, l                  ; 4T
    ld l, a                   ; 4T
    jr nc, $ + 3              ; 7T (usually no carry)
    inc h                     ; 4T (rare)
    ld c, (hl)                ; 7T - C = prev << fine_x

    ; shr lookup on B (next >> comp_x)
    ld a, b                   ; 4T
    ld hl, _shift_shr_table   ; 10T
    add a, l                  ; 4T
    ld l, a                   ; 4T
    jr nc, $ + 3              ; 7T
    inc h                     ; 4T
    ld a, (hl)                ; 7T - A = next >> comp_x

    ; Combine and write
    or c                      ; 4T
    ld (de), a                ; 7T
    inc de                    ; 6T
    ENDR

    ; Restore real SP
    ld sp, (_r2df_save_sp)
    ret

_r2df_save_sp:
    DEFW 0

_r2df_first:
    DEFB 0
_r2df_second:
    DEFB 0

;------------------------------------------------------------------------------
; Screen address lookup table for 96 lines starting at Y=48
; ZX Spectrum screen layout:
;   Address = 0x4000 + (Y/64)*0x800 + ((Y%64)/8)*0x20 + (Y%8)*0x100
; For our viewport starting at Y=48, we precompute all 96 addresses
;------------------------------------------------------------------------------
scr_addr_table_32x16:
    ; Y=48-55 (third 0, char row 6)
    DEFW 0x40C0, 0x41C0, 0x42C0, 0x43C0, 0x44C0, 0x45C0, 0x46C0, 0x47C0
    ; Y=56-63 (third 0, char row 7)
    DEFW 0x40E0, 0x41E0, 0x42E0, 0x43E0, 0x44E0, 0x45E0, 0x46E0, 0x47E0
    ; Y=64-71 (third 1, char row 0)
    DEFW 0x4800, 0x4900, 0x4A00, 0x4B00, 0x4C00, 0x4D00, 0x4E00, 0x4F00
    ; Y=72-79 (third 1, char row 1)
    DEFW 0x4820, 0x4920, 0x4A20, 0x4B20, 0x4C20, 0x4D20, 0x4E20, 0x4F20
    ; Y=80-87 (third 1, char row 2)
    DEFW 0x4840, 0x4940, 0x4A40, 0x4B40, 0x4C40, 0x4D40, 0x4E40, 0x4F40
    ; Y=88-95 (third 1, char row 3)
    DEFW 0x4860, 0x4960, 0x4A60, 0x4B60, 0x4C60, 0x4D60, 0x4E60, 0x4F60
    ; Y=96-103 (third 1, char row 4)
    DEFW 0x4880, 0x4980, 0x4A80, 0x4B80, 0x4C80, 0x4D80, 0x4E80, 0x4F80
    ; Y=104-111 (third 1, char row 5)
    DEFW 0x48A0, 0x49A0, 0x4AA0, 0x4BA0, 0x4CA0, 0x4DA0, 0x4EA0, 0x4FA0
    ; Y=112-119 (third 1, char row 6)
    DEFW 0x48C0, 0x49C0, 0x4AC0, 0x4BC0, 0x4CC0, 0x4DC0, 0x4EC0, 0x4FC0
    ; Y=120-127 (third 1, char row 7)
    DEFW 0x48E0, 0x49E0, 0x4AE0, 0x4BE0, 0x4CE0, 0x4DE0, 0x4EE0, 0x4FE0
    ; Y=128-135 (third 2, char row 0)
    DEFW 0x5000, 0x5100, 0x5200, 0x5300, 0x5400, 0x5500, 0x5600, 0x5700
    ; Y=136-143 (third 2, char row 1)
    DEFW 0x5020, 0x5120, 0x5220, 0x5320, 0x5420, 0x5520, 0x5620, 0x5720

;------------------------------------------------------------------------------
; Offscreen buffer for 32x12 viewport (3168 bytes = 33 * 96)
; 33 bytes per row: 32 visible + 1 lookahead for fine_x blending
;------------------------------------------------------------------------------
    SECTION bss_user
    
    PUBLIC _offscreen_buffer_32x16
_offscreen_buffer_32x16:
    DEFS 3168                ; 33 bytes * 96 scanlines (32 visible + 1 for horizontal ring-buffer)

; Shift lookup tables for fine_x optimization (512 bytes)
; shl_table[byte] = byte << fine_x, shr_table[byte] = byte >> (8-fine_x)
_shift_shl_table:
    DEFS 256
_shift_shr_table:
    DEFS 256

