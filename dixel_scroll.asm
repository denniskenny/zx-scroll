; dixel_scroll.asm - Direct-to-screen 2-pixel scroll (optimised)
; Two-pass approach: each pass shifts all 20 bytes by 1 pixel via rr/rl (hl).
; Eliminates ex af,af' interleaving; uses SP trick for fast table reads.
; DI required: SP hijacked for table reads, IM1 ISR would corrupt state.
;
; Set DIXEL_TEAR_FREE to 1 for beam-synced zero-tearing mode (~2 frames),
; or 0 for fastest single-pass mode (~1.48 frames, minor tearing).
;
; 128K safe: all floating-bus reads use IN A,(C) with BC=0x40FF so that
; bit 15 of the port address is always clear (avoids AY chip conflict).
;
; Four public routines:
;   _dixel_init_sync    - write sentinel attrs below viewport (call once)
;   _dixel_wait_vblank  - floating bus vertical blank detection
;   _dixel_shift_right  - RR-based right shift (content moves right)
;   _dixel_shift_left   - RL-based left shift (content moves left)

    SECTION code_user

    PUBLIC _dixel_shift_right
    PUBLIC _dixel_shift_left
    PUBLIC _dixel_wait_vblank
    PUBLIC _dixel_init_sync

    EXTERN scr_addr_table_32x16

; Viewport parameters (must match draw_dirty_edge.h)
VIEWPORT_COLS           EQU 20
VIEWPORT_CHAR_ROWS      EQU 16
VIEWPORT_COL_OFFSET     EQU 6
VIEWPORT_START_CHAR_ROW EQU 4
VIEWPORT_HEIGHT         EQU VIEWPORT_CHAR_ROWS * 8  ; 128 scanlines

; 128K-safe floating bus port.  IN A,(0xFF) is BROKEN on 128K because the
; current value of A bleeds onto A15; if bit 7 is set you read the AY chip
; (port 0xFFFD) instead of the floating bus.  Using IN A,(C) with B=0x40
; keeps bit 15 clear on every read.
FLOAT_PORT              EQU 0x40FF

; Beam-sync sentinel: attribute byte written to the character row
; immediately below the viewport.  Polled via floating bus between phases
; to detect the exact moment the beam exits the viewport.
; FLASH+BRIGHT on black = visually invisible (both ink & paper are black).
SENTINEL_ATTR           EQU 0xC0
SENTINEL_ROW            EQU VIEWPORT_START_CHAR_ROW + VIEWPORT_CHAR_ROWS
SENTINEL_ADDR           EQU 0x5800 + SENTINEL_ROW * 32 + VIEWPORT_COL_OFFSET

; Tear-free mode: split work across 2 frames with attribute-based beam sync.
; D register counts remaining phases; scanline body is shared.
DIXEL_TEAR_FREE         EQU 1

IF DIXEL_TEAR_FREE
; Phase 1 must complete within 1 frame including ULA contention.
; 64 scanlines × ~1,050T (807T + ~240T avg contention) ≈ 67,200T < 69,888T.
PHASE1_LINES            EQU VIEWPORT_HEIGHT / 2
PHASE2_LINES            EQU VIEWPORT_HEIGHT - PHASE1_LINES
ENDIF

;----------------------------------------------------------------------
; _dixel_init_sync
; Write SENTINEL_ATTR to VIEWPORT_COLS cells at the character row just
; below the viewport (char row 20).  Call once after loading the HUD.
; The sentinel is FLASH+BRIGHT+BLACK — visually invisible.
;----------------------------------------------------------------------
_dixel_init_sync:
    ld hl, SENTINEL_ADDR
    ld a, SENTINEL_ATTR
    ld b, VIEWPORT_COLS
_dis_loop:
    ld (hl), a
    inc hl
    djnz _dis_loop
    ret

;----------------------------------------------------------------------
; _dixel_wait_vblank
; Wait for vertical border using floating bus technique (128K safe).
; Three consecutive reads returning 0xFF means vertical border.
; Uses IN A,(C) with BC=0x40FF to avoid AY chip on 128K.
;----------------------------------------------------------------------
_dixel_wait_vblank:
    ld bc, FLOAT_PORT
_dwv_wait:
    in a, (c)
    inc a                   ; A+1=0 if A was 0xFF
    jr nz, _dwv_wait
    in a, (c)
    inc a
    jr nz, _dwv_wait
    in a, (c)
    inc a
    jr nz, _dwv_wait
    ret

;----------------------------------------------------------------------
; _dixel_shift_right
; Shift viewport right by 2 pixels using two-pass sequential rotate.
; SP reads pre-computed screen addresses from table (pop hl = 10T).
; Pass 1 & 2 each propagate an independent carry chain left-to-right.
; add a,OFFSET clears carry for free (table L values never overflow).
; ~807T per scanline.
;----------------------------------------------------------------------
_dixel_shift_right:
    di
    ld (_dsr_save_sp+1), sp         ; 20T - save SP (self-modifying)
    ld sp, scr_addr_table_32x16     ; 10T
IF DIXEL_TEAR_FREE
    ld d, 1                         ;  7T - phases remaining after this one
    ld b, PHASE1_LINES              ;  7T
ELSE
    ld b, VIEWPORT_HEIGHT           ;  7T
ENDIF

_dsr_scanline:
    pop hl                          ; 10T - HL = screen addr from table
    ld a, l                         ;  4T
    add a, VIEWPORT_COL_OFFSET      ;  7T - carry clear (no overflow)
    ld l, a                         ;  4T - HL = leftmost viewport byte
    ld e, l                         ;  4T - save start L for pass 2

    ; Pass 1: shift right by 1 pixel (left-to-right carry chain)
    ; carry already 0 from add
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)                         ; byte 19, no inc

    ; Pass 2: shift right by 1 more pixel
    ld l, e                         ;  4T - restore start
    or a                            ;  4T - clear carry for pass 2
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)
    inc l
    rr (hl)                         ; byte 19, no inc

    dec b                           ;  4T
    jp nz, _dsr_scanline            ; 10T

IF DIXEL_TEAR_FREE
    ; Phase complete — D counts remaining phases.
    ; D=1 after phase 1: dec→0 (positive), do beam sync + phase 2.
    ; D=0 after phase 2: dec→0xFF (negative), fall through to done.
    dec d                           ;  4T
    jp m, _dsr_done                 ; 10T

    ; Wait for beam to exit viewport: poll floating bus for sentinel
    ; attribute in char row 20 (just below viewport).  Double-check
    ; to reject false positives from pixel data.  128K safe.
    ; HL is free here (loaded from table in phase 2 via pop).
    ; Timeout after ~4000 iterations (~2.5 frames) to prevent hang
    ; if floating bus doesn't return attribute data.
    ld bc, FLOAT_PORT               ; 10T
    ld hl, 4000                     ; 10T - timeout counter
_dsr_mid_sync:
    in a, (c)                       ; 12T - read floating bus
    cp SENTINEL_ATTR                ;  7T
    jr nz, _dsr_no_hit              ; 12T
    in a, (c)                       ; 12T - double-check
    cp SENTINEL_ATTR                ;  7T
    jr z, _dsr_synced               ; 12T
_dsr_no_hit:
    dec hl                          ;  6T
    ld a, h                         ;  4T
    or l                            ;  4T
    jr nz, _dsr_mid_sync            ; 12T
    ; Timeout: proceed with phase 2 anyway (may tear)
_dsr_synced:
    ld b, PHASE2_LINES              ;  7T
    jp _dsr_scanline                ; 10T

_dsr_done:
ENDIF

_dsr_save_sp:
    ld sp, 0                        ; 10T - restore SP (patched)
    ei
    ret

;----------------------------------------------------------------------
; _dixel_shift_left
; Shift viewport left by 2 pixels using two-pass sequential rotate.
; ~807T per scanline.
;----------------------------------------------------------------------
_dixel_shift_left:
    di
    ld (_dsl_save_sp+1), sp         ; 20T - save SP (self-modifying)
    ld sp, scr_addr_table_32x16     ; 10T
IF DIXEL_TEAR_FREE
    ld d, 1                         ;  7T - phases remaining after this one
    ld b, PHASE1_LINES              ;  7T
ELSE
    ld b, VIEWPORT_HEIGHT           ;  7T
ENDIF

_dsl_scanline:
    pop hl                          ; 10T - HL = screen addr from table
    ld a, l                         ;  4T
    add a, VIEWPORT_COL_OFFSET + VIEWPORT_COLS - 1  ; 7T - carry clear
    ld l, a                         ;  4T - HL = rightmost viewport byte
    ld e, l                         ;  4T - save start L for pass 2

    ; Pass 1: shift left by 1 pixel (right-to-left carry chain)
    ; carry already 0 from add
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)                         ; byte 0, no dec

    ; Pass 2: shift left by 1 more pixel
    ld l, e                         ;  4T - restore start
    or a                            ;  4T - clear carry for pass 2
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)
    dec l
    rl (hl)                         ; byte 0, no dec

    dec b                           ;  4T
    jp nz, _dsl_scanline            ; 10T

IF DIXEL_TEAR_FREE
    dec d                           ;  4T
    jp m, _dsl_done                 ; 10T

    ld bc, FLOAT_PORT               ; 10T
    ld hl, 4000                     ; 10T - timeout counter
_dsl_mid_sync:
    in a, (c)                       ; 12T
    cp SENTINEL_ATTR                ;  7T
    jr nz, _dsl_no_hit              ; 12T
    in a, (c)                       ; 12T - double-check
    cp SENTINEL_ATTR                ;  7T
    jr z, _dsl_synced               ; 12T
_dsl_no_hit:
    dec hl                          ;  6T
    ld a, h                         ;  4T
    or l                            ;  4T
    jr nz, _dsl_mid_sync            ; 12T
    ; Timeout: proceed with phase 2 anyway (may tear)
_dsl_synced:
    ld b, PHASE2_LINES              ;  7T
    jp _dsl_scanline                ; 10T

_dsl_done:
ENDIF

_dsl_save_sp:
    ld sp, 0                        ; 10T - restore SP (patched)
    ei
    ret
