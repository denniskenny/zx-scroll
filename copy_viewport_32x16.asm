; copy_viewport_32x16.asm - Copy 32x12 character (256x96 pixel) viewport to screen
; Viewport is centered: starts at screen row 6 (Y=48)
; Buffer layout: 32 bytes per scanline, 96 scanlines = 3072 bytes

    SECTION code_user

    PUBLIC _copy_viewport_32x16_to_screen
    EXTERN _offscreen_buffer_32x16

; Screen constants
SCREEN_BASE     EQU 0x4000
VIEWPORT_START_Y EQU 48          ; Centered: (192-96)/2 = 48

;------------------------------------------------------------------------------
; copy_viewport_32x16_to_screen - Blit 256x96 buffer to centered screen area
; void copy_viewport_32x16_to_screen(unsigned char *buffer)
; 
; Optimizations:
; - 32x unrolled LDI for full scanline copy (256-bit burst)
; - Precomputed screen address table for Spectrum's weird layout
; - 2-line loop unrolling
;------------------------------------------------------------------------------
_copy_viewport_32x16_to_screen:
    di                       ; disable interrupts during screen update
    
    push ix
    ld ix, 0
    add ix, sp
    
    ld l, (ix+4)
    ld h, (ix+5)             ; HL = source buffer
    
    ; Use alternate HL' for table pointer (safe with sdcc_iy)
    exx
    ld hl, scr_addr_table_32x16
    exx
    
    ld b, 96                 ; 96 lines
    
copy_loop_32x16:
    push bc
    
    ; Get screen address from table
    exx
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl                   ; DE' = screen address
    push de                  ; save screen address
    exx
    pop de                   ; DE = screen address (main regs)
    
    ; Copy 32 bytes using unrolled LDI (HL=source, DE=dest)
    REPT 32
    ldi
    ENDR
    
    ; HL now points to next source row
    
    pop bc
    djnz copy_loop_32x16
    
    pop ix
    ei
    ret

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
; Offscreen buffer for 32x12 viewport (3072 bytes)
; Let linker place it in BSS after code
;------------------------------------------------------------------------------
    SECTION bss_user
    
    PUBLIC _offscreen_buffer_32x16
_offscreen_buffer_32x16:
    DEFS 3072                ; 32 bytes * 96 scanlines

