; input.asm - Simple keyboard reader for Q/A/O/P
; Returns direction flags in L (SDCC return convention)
; Supports simultaneous keypresses for diagonals

    SECTION code_user

    PUBLIC _read_keys

; Direction flag values (must match draw_dirty_edge.h)
SCROLL_X_PLUS   EQU 0x01   ; P = right
SCROLL_X_MINUS  EQU 0x02   ; O = left
SCROLL_Y_PLUS   EQU 0x04   ; A = down
SCROLL_Y_MINUS  EQU 0x08   ; Q = up

_read_keys:
    ld l, 0                 ; result = 0

    ; Q key: QWERT row, port 0xFBFE, bit 0 (active low)
    ld bc, 0xFBFE
    in a, (c)
    bit 0, a
    jr nz, _rk_no_q
    set 3, l                ; SCROLL_Y_MINUS
_rk_no_q:

    ; A key: ASDFG row, port 0xFDFE, bit 0 (active low)
    ld bc, 0xFDFE
    in a, (c)
    bit 0, a
    jr nz, _rk_no_a
    set 2, l                ; SCROLL_Y_PLUS
_rk_no_a:

    ; P and O keys: POIUY row, port 0xDFFE
    ; P = bit 0, O = bit 1 (active low)
    ld bc, 0xDFFE
    in a, (c)
    bit 0, a
    jr nz, _rk_no_p
    set 0, l                ; SCROLL_X_PLUS
_rk_no_p:
    bit 1, a
    jr nz, _rk_no_o
    set 1, l                ; SCROLL_X_MINUS
_rk_no_o:

    ret
