; dixel_scroll.asm - Direct-to-screen 2-pixel scroll using RL+SP technique
; Uses SP trick for bulk POP/PUSH, RL/RR chains for automatic carry propagation.
; 20-byte viewport split into groups of 12+6+2 bytes.
;
; Three public routines:
;   _dixel_wait_vblank  - floating bus vertical blank detection
;   _dixel_shift_right  - RR-based right shift (content moves right)
;   _dixel_shift_left   - RL-based left shift (content moves left)

    SECTION code_user

    PUBLIC _dixel_shift_right
    PUBLIC _dixel_shift_left
    PUBLIC _dixel_wait_vblank

    EXTERN scr_addr_table_32x16

; Viewport parameters (must match draw_dirty_edge.h)
VIEWPORT_COLS       EQU 20
VIEWPORT_CHAR_ROWS  EQU 16
VIEWPORT_COL_OFFSET EQU 6
VIEWPORT_HEIGHT     EQU VIEWPORT_CHAR_ROWS * 8  ; 128 scanlines

;----------------------------------------------------------------------
; _dixel_wait_vblank
; Wait for vertical border using floating bus technique.
; Three consecutive IN A,(0xFF) returning 0xFF means vertical border.
; Each IN = 11T, total 33T > horizontal blank (~24T).
;----------------------------------------------------------------------
_dixel_wait_vblank:
_dwv_wait:
    in a, (0xFF)
    inc a                   ; A+1=0 if A was 0xFF
    jr nz, _dwv_wait
    in a, (0xFF)
    inc a
    jr nz, _dwv_wait
    in a, (0xFF)
    inc a
    jr nz, _dwv_wait
    ret

;----------------------------------------------------------------------
; _dixel_shift_left
; Shift viewport content left by 2 pixels using RL+SP technique.
; Processes right-to-left: Group A (cols 8-19), B (cols 2-7), C (cols 0-1).
; SLA on first byte of Group A, RL on all others (carry auto-propagates).
; ~770T per scanline, ~98,560T total (~1.41 frames).
;----------------------------------------------------------------------
_dixel_shift_left:
    di
    ld (_dsl_sp_save + 1), sp   ; save SP (self-mod)
    ld a, VIEWPORT_HEIGHT
    ld (_dsl_count), a
    ld hl, scr_addr_table_32x16
    ld (_dsl_tbl_ptr), hl

_dsl_scanline:
    ; 1. Table lookup: read screen address
    ld hl, (_dsl_tbl_ptr)
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    ld (_dsl_tbl_ptr), hl

    ; 2. Compute Group A SP = screen_addr + VIEWPORT_COL_OFFSET + 8
    ex de, hl
    ld de, VIEWPORT_COL_OFFSET + 8
    add hl, de
    ld (_dsl_grp_a + 1), hl    ; self-modify ld sp,nn

    ; ============ Group A: 12 bytes (cols 8-19) ============
_dsl_grp_a:
    ld sp, 0                    ; self-modified
    pop bc                      ; C=col8,  B=col9
    pop de                      ; E=col10, D=col11
    pop hl                      ; L=col12, H=col13
    exx
    pop bc                      ; C'=col14, B'=col15
    pop de                      ; E'=col16, D'=col17
    pop hl                      ; L'=col18, H'=col19

    ; Shift alt set (rightmost 6 bytes) — pass 1: SLA first, RL rest
    sla h
    rl l
    rl d
    rl e
    rl b
    rl c
    rla                         ; save carry from pass 1
    ; Pass 2
    sla h
    rl l
    rl d
    rl e
    rl b
    rl c
    rra                         ; restore carry for cross-group propagation
    ; Write back cols 14-19
    push hl
    push de
    push bc

    exx                         ; back to main
    ; Shift main set (next 6 bytes) — RL throughout (carry continues from alt)
    ; Pass 1
    rl h
    rl l
    rl d
    rl e
    rl b
    rl c
    rla                         ; save carry from pass 1
    ; Pass 2
    rl h
    rl l
    rl d
    rl e
    rl b
    rl c
    rra                         ; restore carry for cross-group propagation
    ; Write back cols 8-13
    push hl
    push de
    push bc
    ; SP now back at VIEWPORT_COL_OFFSET + 8

    ; ============ Transition A->B: SP -= 6 ============
    ; Must use dec sp (not add hl,sp) to preserve carry flag
    dec sp
    dec sp
    dec sp
    dec sp
    dec sp
    dec sp
    ; SP = VIEWPORT_COL_OFFSET + 2

    ; ============ Group B: 6 bytes (cols 2-7) ============
    pop bc                      ; C=col2, B=col3
    pop de                      ; E=col4, D=col5
    pop hl                      ; L=col6, H=col7
    ; Pass 1 (carry continues from Group A)
    rl h
    rl l
    rl d
    rl e
    rl b
    rl c
    rla                         ; save carry
    ; Pass 2
    rl h
    rl l
    rl d
    rl e
    rl b
    rl c
    rra                         ; restore carry
    ; Write back cols 2-7
    push hl
    push de
    push bc
    ; SP = VIEWPORT_COL_OFFSET + 2

    ; ============ Transition B->C: SP -= 2 ============
    dec sp
    dec sp
    ; SP = VIEWPORT_COL_OFFSET

    ; ============ Group C: 2 bytes (cols 0-1) ============
    pop bc                      ; C=col0, B=col1
    ; Pass 1
    rl b
    rl c
    rla                         ; save carry
    ; Pass 2
    rl b
    rl c
    ; carry from col0 falls off left edge — no rra needed
    ; Write back cols 0-1
    push bc

    ; 3. Loop counter
    ld a, (_dsl_count)
    dec a
    ld (_dsl_count), a
    jp nz, _dsl_scanline

_dsl_sp_save:
    ld sp, 0                    ; self-modified: restore SP
    ei
    ret

; Private data for left shift
_dsl_tbl_ptr:   dw 0
_dsl_count:     db 0

;----------------------------------------------------------------------
; _dixel_shift_right
; Shift viewport content right by 2 pixels using RR+SP technique.
; Processes left-to-right: Group C (cols 0-1), B (cols 2-7), A (cols 8-19).
; SRL on first byte of Group C, RR on all others (carry auto-propagates).
; ~778T per scanline, ~99,584T total (~1.42 frames).
;----------------------------------------------------------------------
_dixel_shift_right:
    di
    ld (_dsr_sp_save + 1), sp   ; save SP (self-mod)
    ld a, VIEWPORT_HEIGHT
    ld (_dsr_count), a
    ld hl, scr_addr_table_32x16
    ld (_dsr_tbl_ptr), hl

_dsr_scanline:
    ; 1. Table lookup: read screen address
    ld hl, (_dsr_tbl_ptr)
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    ld (_dsr_tbl_ptr), hl

    ; 2. Compute Group C SP = screen_addr + VIEWPORT_COL_OFFSET
    ex de, hl
    ld de, VIEWPORT_COL_OFFSET
    add hl, de
    ld (_dsr_grp_c + 1), hl    ; self-modify ld sp,nn

    ; ============ Group C: 2 bytes (cols 0-1) ============
_dsr_grp_c:
    ld sp, 0                    ; self-modified
    pop bc                      ; C=col0, B=col1
    ; Pass 1: SRL first byte, RR rest
    srl c
    rr b
    rla                         ; save carry
    ; Pass 2
    srl c
    rr b
    rra                         ; restore carry for cross-group propagation
    ; Write back cols 0-1
    push bc
    ; SP = VIEWPORT_COL_OFFSET

    ; ============ Transition C->B: no adjustment needed ============
    ; SP is already at VIEWPORT_COL_OFFSET, and Group B starts at col2
    ; which is at VIEWPORT_COL_OFFSET + 2. But we just pushed BC back,
    ; so SP = VIEWPORT_COL_OFFSET. We need SP at col2 = VIEWPORT_COL_OFFSET + 2.
    inc sp
    inc sp
    ; SP = VIEWPORT_COL_OFFSET + 2

    ; ============ Group B: 6 bytes (cols 2-7) ============
    pop bc                      ; C=col2, B=col3
    pop de                      ; E=col4, D=col5
    pop hl                      ; L=col6, H=col7
    ; Pass 1 (carry continues from Group C)
    rr c
    rr b
    rr e
    rr d
    rr l
    rr h
    rla                         ; save carry
    ; Pass 2
    rr c
    rr b
    rr e
    rr d
    rr l
    rr h
    rra                         ; restore carry for cross-group propagation
    ; Write back cols 2-7 (push in reverse: HL first, then DE, then BC)
    push hl
    push de
    push bc
    ; SP = VIEWPORT_COL_OFFSET + 2

    ; ============ Transition B->A: SP += 6 ============
    ; Must use inc sp (not add hl,sp) to preserve carry flag
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    ; SP = VIEWPORT_COL_OFFSET + 8

    ; ============ Group A: 12 bytes (cols 8-19) ============
    pop bc                      ; C=col8,  B=col9
    pop de                      ; E=col10, D=col11
    pop hl                      ; L=col12, H=col13
    exx
    pop bc                      ; C'=col14, B'=col15
    pop de                      ; E'=col16, D'=col17
    pop hl                      ; L'=col18, H'=col19

    ; Right shift: need to shift main (cols 8-13) first, then alt (cols 14-19)
    exx                         ; back to main
    ; Shift main (cols 8-13) — pass 1: RR chain (carry continues from Group B)
    rr c
    rr b
    rr e
    rr d
    rr l
    rr h
    rla                         ; save carry
    ; Pass 2
    rr c
    rr b
    rr e
    rr d
    rr l
    rr h
    rra                         ; restore carry for cross-group propagation

    exx                         ; to alt
    ; Shift alt (cols 14-19) — pass 1
    rr c
    rr b
    rr e
    rr d
    rr l
    rr h
    rla                         ; save carry
    ; Pass 2
    rr c
    rr b
    rr e
    rr d
    rr l
    rr h
    ; carry from col19 falls off right edge — no rra needed
    ; Write back alt (cols 14-19) first (higher addresses)
    push hl
    push de
    push bc
    exx                         ; back to main
    ; Write back main (cols 8-13)
    push hl
    push de
    push bc
    ; SP = VIEWPORT_COL_OFFSET + 8

    ; 3. Loop counter
    ld a, (_dsr_count)
    dec a
    ld (_dsr_count), a
    jp nz, _dsr_scanline

_dsr_sp_save:
    ld sp, 0                    ; self-modified: restore SP
    ei
    ret

; Private data for right shift
_dsr_tbl_ptr:   dw 0
_dsr_count:     db 0
