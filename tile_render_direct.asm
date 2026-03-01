; tile_render_direct.asm - Direct-to-screen tile renderer
; Race-the-beam: renders dirty tiles directly to screen memory.
; Screen ring buffer model: caller passes physical screen column offset.
;
; Viewport: 20 cols × 16 char rows at Y=64..191 (char rows 8-23)
; Tiles: ≤32 unique tiles, page-aligned at 0x6000 (256 bytes)
;
; Public routines:
;   _render_dirty_column  - render 1 column of 16 tiles (128 scanlines)
;   _render_dirty_row     - render 1 row of 20 tiles (8 scanlines)
;   _render_full_viewport - render all 320 tiles (startup only)
;   _shift_viewport_left  - LDIR shift 19 bytes left per scanline (scroll right)
;   _shift_viewport_right - LDD shift 19 bytes right per scanline (scroll left)
;   _shift_viewport_up    - LDIR copy 15 rows upward (scroll down)
;   _shift_viewport_down  - LDIR copy 15 rows downward (scroll up)

    SECTION code_user

    PUBLIC _render_dirty_column
    PUBLIC _render_dirty_row
    PUBLIC _render_full_viewport
    PUBLIC _scr_addr_table_direct
    PUBLIC _shift_viewport_left
    PUBLIC _shift_viewport_right
    PUBLIC _shift_viewport_up
    PUBLIC _shift_viewport_down

; Viewport parameters (must match tile_render.h)
VIEWPORT_COLS           EQU 20
VIEWPORT_CHAR_ROWS      EQU 16
VIEWPORT_COL_OFFSET     EQU 6
VIEWPORT_START_CHAR_ROW EQU 8
VIEWPORT_HEIGHT         EQU VIEWPORT_CHAR_ROWS * 8  ; 128 scanlines

; Tile data at 0x6000, page-aligned (≤32 tiles × 8 bytes = 256 bytes)
TILE_PAGE               EQU 0x60

; Map dimensions
MAP_WIDTH               EQU 96

;----------------------------------------------------------------------
; _render_dirty_column
; Render 1 column of 16 tiles (128 scanlines) directly to screen.
; Uses SP trick to read screen addresses from LUT.
;
; void render_dirty_column(unsigned char screen_col, const unsigned char *map_col_ptr)
;   screen_col:   physical screen byte offset (VIEWPORT_COL_OFFSET + ring_col)
;   map_col_ptr:  &map_data[camera_tile_y * MAP_WIDTH + map_tile_col]
;
; T-states: ~6,400 uncontended (16 tiles × ~400T)
;----------------------------------------------------------------------
_render_dirty_column:
    ; Read params from stack (SDCC sdcc_iy: char is 1 byte on stack)
    ; SP+0,1 = return addr
    ; SP+2   = screen_col (1 byte, pushed via push af / inc sp)
    ; SP+3,4 = map_col_ptr
    ld hl, 2
    add hl, sp
    ld c, (hl)              ; C = screen_col byte offset
    inc hl
    ld e, (hl)
    inc hl
    ld d, (hl)              ; DE = map_col_ptr

    ; Setup alt regs: HL' = map pointer, BC' = MAP_WIDTH stride
    push de
    exx
    pop hl                  ; HL' = map_col_ptr
    ld bc, MAP_WIDTH        ; BC' = stride to next map row
    exx

    di
    ld (_rdc_save_sp+1), sp ; save SP (self-modifying)
    ld sp, _scr_addr_table_direct  ; SP = screen address LUT
    ld b, VIEWPORT_CHAR_ROWS      ; B = 16 tile rows (D is clobbered by pop de)

_rdc_tile_loop:
    ; Read tile index from map (alt regs)
    exx                     ;  4T
    ld a, (hl)              ;  7T - tile index
    add hl, bc              ; 11T - advance map ptr by MAP_WIDTH
    exx                     ;  4T

    ; Check for blank tile (index 0)
    or a                    ;  4T
    jr z, _rdc_blank_tile   ;  7T (not taken) / 12T (taken)

    ; Compute tile data address: TILE_PAGE : (tile_index * 8)
    add a, a                ;  4T - ×2
    add a, a                ;  4T - ×4
    add a, a                ;  4T - ×8
    ld l, a                 ;  4T
    ld h, TILE_PAGE         ;  7T

    ; 8 scanlines unrolled: pop screen addr, add col offset, read tile, write
    pop de                  ; 10T - screen addr from LUT
    ld a, e                 ;  4T
    add a, c                ;  4T - + column offset
    ld e, a                 ;  4T
    ld a, (hl)              ;  7T - tile byte
    ld (de), a              ;  7T - write to screen
    inc l                   ;  4T - next scanline of tile

    pop de
    ld a, e
    add a, c
    ld e, a
    ld a, (hl)
    ld (de), a
    inc l

    pop de
    ld a, e
    add a, c
    ld e, a
    ld a, (hl)
    ld (de), a
    inc l

    pop de
    ld a, e
    add a, c
    ld e, a
    ld a, (hl)
    ld (de), a
    inc l

    pop de
    ld a, e
    add a, c
    ld e, a
    ld a, (hl)
    ld (de), a
    inc l

    pop de
    ld a, e
    add a, c
    ld e, a
    ld a, (hl)
    ld (de), a
    inc l

    pop de
    ld a, e
    add a, c
    ld e, a
    ld a, (hl)
    ld (de), a
    inc l

    pop de                  ; scanline 7 (last)
    ld a, e
    add a, c
    ld e, a
    ld a, (hl)
    ld (de), a
    ; no inc l needed for last scanline

    dec b                   ;  4T
    jp nz, _rdc_tile_loop   ; 10T
    jp _rdc_done

_rdc_blank_tile:
    ; Write 0x00 to 8 scanlines (tile index 0 = blank)
    pop de                  ; 10T
    ld a, c                 ;  4T - column offset
    add a, e                ;  4T
    ld e, a                 ;  4T
    xor a                   ;  4T
    ld (de), a              ;  7T

    pop de
    ld a, c
    add a, e
    ld e, a
    xor a
    ld (de), a

    pop de
    ld a, c
    add a, e
    ld e, a
    xor a
    ld (de), a

    pop de
    ld a, c
    add a, e
    ld e, a
    xor a
    ld (de), a

    pop de
    ld a, c
    add a, e
    ld e, a
    xor a
    ld (de), a

    pop de
    ld a, c
    add a, e
    ld e, a
    xor a
    ld (de), a

    pop de
    ld a, c
    add a, e
    ld e, a
    xor a
    ld (de), a

    pop de                  ; scanline 7
    ld a, c
    add a, e
    ld e, a
    xor a
    ld (de), a

    dec b                   ;  4T
    jp nz, _rdc_tile_loop   ; 10T

_rdc_done:
_rdc_save_sp:
    ld sp, 0                ; 10T - restore SP (self-mod patched)
    ei
    ret

;----------------------------------------------------------------------
; _shift_viewport_left
; Shift all 128 scanlines of viewport left by 1 byte (8 pixels).
; Used for scroll-right: existing cols 1..19 move to cols 0..18,
; then caller draws new rightmost column at col 19.
; Uses SP trick for screen address table + unrolled LDI.
;
; void shift_viewport_left(void)
;
; T-states: ~49,000 (128 × ~381T)
;----------------------------------------------------------------------
_shift_viewport_left:
    di
    ld (_svl_save_sp+1), sp
    ld sp, _scr_addr_table_direct
    ld a, VIEWPORT_HEIGHT           ; 128 scanlines
    ld (_svl_count), a

_svl_scanline:
    pop hl                          ; 10T - screen addr from table
    ld d, h                         ;  4T - dest H = same row
    ld a, l                         ;  4T
    add a, VIEWPORT_COL_OFFSET + 1  ;  7T - source = col 1
    ld l, a                         ;  4T
    dec a                           ;  4T
    ld e, a                         ;  4T - dest = col 0

    ; 19 × LDI (16T each = 304T) - copy cols 1..19 to cols 0..18
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI
    LDI

    ld a, (_svl_count)              ; 13T
    dec a                           ;  4T
    ld (_svl_count), a              ; 13T
    jp nz, _svl_scanline            ; 10T

_svl_save_sp:
    ld sp, 0                        ; self-mod patched
    ei
    ret

_svl_count:
    DEFB 0

;----------------------------------------------------------------------
; _shift_viewport_right
; Shift all 128 scanlines of viewport right by 1 byte (8 pixels).
; Used for scroll-left: existing cols 0..18 move to cols 1..19,
; then caller draws new leftmost column at col 0.
; Uses SP trick for screen address table + unrolled LDD.
;
; void shift_viewport_right(void)
;
; T-states: ~49,000 (128 × ~381T)
;----------------------------------------------------------------------
_shift_viewport_right:
    di
    ld (_svr_save_sp+1), sp
    ld sp, _scr_addr_table_direct
    ld a, VIEWPORT_HEIGHT           ; 128 scanlines
    ld (_svr_count), a

_svr_scanline:
    pop hl                          ; 10T - screen addr from table
    ld d, h                         ;  4T
    ld a, l                         ;  4T
    add a, VIEWPORT_COL_OFFSET + VIEWPORT_COLS - 2  ; 7T - source end = col 18
    ld l, a                         ;  4T
    inc a                           ;  4T
    ld e, a                         ;  4T - dest end = col 19

    ; 19 × LDD (16T each = 304T) - copy cols 18..0 to cols 19..1
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD
    LDD

    ld a, (_svr_count)              ; 13T
    dec a                           ;  4T
    ld (_svr_count), a              ; 13T
    jp nz, _svr_scanline            ; 10T

_svr_save_sp:
    ld sp, 0                        ; self-mod patched
    ei
    ret

_svr_count:
    DEFB 0

;----------------------------------------------------------------------
; _shift_viewport_up
; Shift viewport up by 1 char row (8 pixels). Copies char rows 1..15
; to rows 0..14, top-to-bottom. Caller draws new bottom row (row 15).
; Uses SP trick for source addresses, IX for dest addresses.
; IX is saved/restored because SDCC uses it as the frame pointer
; (sdcc_iy calling convention). Without this, returning with a
; clobbered IX causes the caller's (ix-N) local variable accesses
; to read/write into the screen address table instead of the stack.
;
; void shift_viewport_up(void)
;
; T-states: ~68,000 (120 scanlines × ~563T)
;----------------------------------------------------------------------
_shift_viewport_up:
    di
    push ix                         ; save SDCC frame pointer
    ld (_svu_save_sp+1), sp
    ; Source = char row 1 onward (table entry 8 = 16 bytes offset)
    ld sp, _scr_addr_table_direct + 16
    ; Dest = char row 0 onward (table entry 0)
    ld ix, _scr_addr_table_direct
    ld a, 120                       ; 15 char rows × 8 scanlines
    ld (_svu_count), a

_svu_scanline:
    ; Source addr via SP trick
    pop hl                          ; 10T - source screen addr
    ld a, l                         ;  4T
    add a, VIEWPORT_COL_OFFSET      ;  7T
    ld l, a                         ;  4T - HL = source + offset

    ; Dest addr via IX
    ld e, (ix+0)                    ; 19T
    ld d, (ix+1)                    ; 19T
    inc ix                          ; 10T
    inc ix                          ; 10T
    ld a, e                         ;  4T
    add a, VIEWPORT_COL_OFFSET      ;  7T
    ld e, a                         ;  4T - DE = dest + offset

    ld bc, VIEWPORT_COLS            ; 10T - 20 bytes
    ldir                            ; 19×21 + 16 = 415T

    ld a, (_svu_count)              ; 13T
    dec a                           ;  4T
    ld (_svu_count), a              ; 13T
    jp nz, _svu_scanline            ; 10T

_svu_save_sp:
    ld sp, 0                        ; self-mod patched
    pop ix                          ; restore SDCC frame pointer
    ei
    ret

_svu_count:
    DEFB 0

;----------------------------------------------------------------------
; _shift_viewport_down
; Shift viewport down by 1 char row (8 pixels). Copies char rows 0..14
; to rows 1..15, bottom-to-top. Caller draws new top row (row 0).
; Uses IX for source addresses (walking backward), dest = source + 16
; bytes in table (8 entries later).
; IX is saved/restored because SDCC uses it as the frame pointer
; (sdcc_iy calling convention). See shift_viewport_up comment.
;
; void shift_viewport_down(void)
;
; T-states: ~71,000 (120 scanlines × ~591T)
;----------------------------------------------------------------------
_shift_viewport_down:
    di
    push ix                         ; save SDCC frame pointer
    ; Start from bottom: source entry 119 (char row 14 scanline 7)
    ; dest is always source + 8 entries = +16 bytes in table
    ld ix, _scr_addr_table_direct + 119 * 2
    ld a, 120                       ; 15 char rows × 8 scanlines
    ld (_svd_count), a

_svd_scanline:
    ; Source addr via IX
    ld l, (ix+0)                    ; 19T
    ld h, (ix+1)                    ; 19T
    ld a, l                         ;  4T
    add a, VIEWPORT_COL_OFFSET      ;  7T
    ld l, a                         ;  4T - HL = source + offset

    ; Dest addr via IX+16 (8 entries later in table)
    ld e, (ix+16)                   ; 19T
    ld d, (ix+17)                   ; 19T
    ld a, e                         ;  4T
    add a, VIEWPORT_COL_OFFSET      ;  7T
    ld e, a                         ;  4T - DE = dest + offset

    ld bc, VIEWPORT_COLS            ; 10T - 20 bytes
    ldir                            ; 415T

    dec ix                          ; 10T
    dec ix                          ; 10T - move to previous entry

    ld a, (_svd_count)              ; 13T
    dec a                           ;  4T
    ld (_svd_count), a              ; 13T
    jp nz, _svd_scanline            ; 10T

    pop ix                          ; restore SDCC frame pointer
    ei
    ret

_svd_count:
    DEFB 0

;----------------------------------------------------------------------
; _render_dirty_row
; Render 1 row of 20 tiles (8 scanlines × 20 bytes) directly to screen.
; Uses exx tile lookup pattern from draw_aligned.asm.
;
; void render_dirty_row(unsigned char viewport_char_row, const unsigned char *map_row_ptr)
;   viewport_char_row: 0-15 (row within viewport)
;   map_row_ptr:       &map_data[map_tile_row * MAP_WIDTH + camera_tile_x]
;
; T-states: ~10,600 uncontended (8 scanlines × 20 tiles × 65T)
;----------------------------------------------------------------------
_render_dirty_row:
    ; Read params from stack (SDCC sdcc_iy: char is 1 byte on stack)
    ; SP+2   = viewport_char_row (1 byte)
    ; SP+3,4 = map_row_ptr
    ld hl, 2
    add hl, sp
    ld a, (hl)              ; A = viewport_char_row (0-15)
    inc hl
    ld e, (hl)
    inc hl
    ld d, (hl)              ; DE = map_row_ptr

    ; Save map_row_ptr for reuse each scanline
    ld (_rdr_map_ptr+1), de

    ; Look up screen base address from table
    ; Table offset = viewport_char_row * 16 (8 entries × 2 bytes per char row)
    add a, a                ; ×2
    add a, a                ; ×4
    add a, a                ; ×8
    add a, a                ; ×16
    ld c, a
    ld b, 0
    ld hl, _scr_addr_table_direct
    add hl, bc
    ld e, (hl)
    inc hl
    ld d, (hl)              ; DE = screen addr for first scanline of row

    ; Add viewport column offset
    ld a, e
    add a, VIEWPORT_COL_OFFSET
    ld e, a

    di

    ; Setup: save screen base in self-mod location
    ; Within a char row, next scanline = +0x100 (inc D)
    ld (_rdr_scr_base), de

    ; Alt regs: D' = TILE_PAGE, E' = in_tile_y (0-7)
    exx
    ld d, TILE_PAGE
    ld e, 0                 ; in_tile_y starts at 0
    exx

    ld b, 8                 ; 8 scanlines per row

_rdr_scanline:
    push bc                 ; save scanline counter

    ; Load map pointer (reset each scanline to same row start)
_rdr_map_ptr:
    ld hl, 0                ; self-mod: map_row_ptr
    ld de, (_rdr_scr_base)  ; DE = screen address for this scanline

    ; 20 tiles unrolled: read map, exx, lookup tile, exx, write to screen
    ; Per tile: ld a,(hl)/inc hl/exx/add×3/add a,e/ld l,a/ld h,d/ld a,(hl)/exx/ld (de),a/inc e
    ; = 7+6+4+4+4+4+4+4+4+7+4+7+4 = 67T per tile (inc hl is 6T not 4T)

    REPT 20
    ld a, (hl)              ;  7T - tile index from map
    inc hl                  ;  6T - next map column
    exx                     ;  4T
    add a, a                ;  4T - ×2
    add a, a                ;  4T - ×4
    add a, a                ;  4T - ×8
    add a, e                ;  4T - + in_tile_y
    ld l, a                 ;  4T
    ld h, d                 ;  4T - H = TILE_PAGE
    ld a, (hl)              ;  7T - tile byte
    exx                     ;  4T
    ld (de), a              ;  7T - write to screen
    inc e                   ;  4T - next screen column
    ENDR

    ; Advance screen base for next scanline: D += 1 (next pixel row = +0x100)
    ld hl, _rdr_scr_base+1
    inc (hl)                ; 11T - screen H += 1

    ; Increment in_tile_y in alt regs
    exx
    inc e                   ;  4T - E' = in_tile_y++
    exx

    pop bc                  ; restore scanline counter
    dec b
    jp nz, _rdr_scanline

    ei
    ret

_rdr_scr_base:
    DEFW 0

;----------------------------------------------------------------------
; _render_full_viewport
; Render entire 20×16 tile viewport to screen. Called once at startup.
; Renders row by row (16 rows × 8 scanlines × 20 tiles).
;
; void render_full_viewport(const unsigned char *map_top_left)
;   map_top_left: &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x]
;
; T-states: ~170,000 (~2.4 frames). Run with interrupts disabled at startup.
;----------------------------------------------------------------------
_render_full_viewport:
    ; Read map_top_left from stack (before push ix changes SP)
    ld hl, 2
    add hl, sp
    ld e, (hl)
    inc hl
    ld d, (hl)              ; DE = map_top_left

    ; Save map pointer
    ld (_rfv_map_ptr), de

    push ix                 ; save SDCC frame pointer
    di

    ; Alt regs: D' = TILE_PAGE, E' = in_tile_y
    exx
    ld d, TILE_PAGE
    ld e, 0                 ; in_tile_y starts at 0
    exx

    ; Screen address table pointer
    ld ix, _scr_addr_table_direct

    ld c, VIEWPORT_CHAR_ROWS   ; C = 16 char rows
    ld b, 8                    ; B = 8 scanlines per char row

_rfv_scanline:
    push bc                 ; save counters

    ; Get screen address from table
    ld e, (ix+0)
    ld d, (ix+1)
    inc ix
    inc ix

    ; Add viewport column offset
    ld a, e
    add a, VIEWPORT_COL_OFFSET
    ld e, a

    ; Load map pointer for this row
    ld hl, (_rfv_map_ptr)

    ; Draw 20 tiles for this scanline
    REPT 20
    ld a, (hl)              ;  7T - tile index
    inc hl                  ;  6T
    exx                     ;  4T
    add a, a                ;  4T
    add a, a                ;  4T
    add a, a                ;  4T
    add a, e                ;  4T - + in_tile_y
    ld l, a                 ;  4T
    ld h, d                 ;  4T - TILE_PAGE
    ld a, (hl)              ;  7T
    exx                     ;  4T
    ld (de), a              ;  7T
    inc e                   ;  4T
    ENDR

    pop bc                  ; restore counters

    ; Advance in_tile_y
    exx
    inc e                   ;  4T
    exx

    dec b
    jp nz, _rfv_scanline    ; loop for 8 scanlines within char row

    ; B exhausted: end of char row
    ; Reset in_tile_y, advance map pointer, next char row
    exx
    ld e, 0                 ; reset in_tile_y to 0
    exx

    ld hl, (_rfv_map_ptr)
    ld de, MAP_WIDTH
    add hl, de
    ld (_rfv_map_ptr), hl   ; advance to next map row

    ld b, 8                 ; reset scanline counter
    dec c                   ; next char row
    jp nz, _rfv_scanline    ; loop for 16 char rows

    pop ix                  ; restore SDCC frame pointer
    ei
    ret

_rfv_map_ptr:
    DEFW 0

;----------------------------------------------------------------------
; Screen address lookup table for Y=64..191
; 128 entries (16 char rows × 8 scanlines each)
; ZX Spectrum: addr = 0x4000 | (Y&0xC0)<<5 | (Y&0x07)<<8 | (Y&0x38)<<2
;----------------------------------------------------------------------
_scr_addr_table_direct:
    ; Y=64-71 (third 1, char row 0 in third)
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
    ; Y=144-151 (third 2, char row 2)
    DEFW 0x5040, 0x5140, 0x5240, 0x5340, 0x5440, 0x5540, 0x5640, 0x5740
    ; Y=152-159 (third 2, char row 3)
    DEFW 0x5060, 0x5160, 0x5260, 0x5360, 0x5460, 0x5560, 0x5660, 0x5760
    ; Y=160-167 (third 2, char row 4)
    DEFW 0x5080, 0x5180, 0x5280, 0x5380, 0x5480, 0x5580, 0x5680, 0x5780
    ; Y=168-175 (third 2, char row 5)
    DEFW 0x50A0, 0x51A0, 0x52A0, 0x53A0, 0x54A0, 0x55A0, 0x56A0, 0x57A0
    ; Y=176-183 (third 2, char row 6)
    DEFW 0x50C0, 0x51C0, 0x52C0, 0x53C0, 0x54C0, 0x55C0, 0x56C0, 0x57C0
    ; Y=184-191 (third 2, char row 7)
    DEFW 0x50E0, 0x51E0, 0x52E0, 0x53E0, 0x54E0, 0x55E0, 0x56E0, 0x57E0
