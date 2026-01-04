; copy_viewport.asm - Fast screen copy for ZX Spectrum scroller
; Copies 128x128 pixel viewport from offscreen buffer to centered screen position
;
; Optimizations:
; - Unrolled LDI (16T each) instead of LDIR (21T each)
; - Alternate registers for table pointer
; - 2x loop unrolling (process 2 lines per iteration)

    SECTION code_user

    PUBLIC _copy_viewport_to_screen

    EXTERN _offscreen_buffer

; void copy_viewport_to_screen(void)
_copy_viewport_to_screen:
    di
    
    ld hl, _offscreen_buffer
    exx
    ld hl, scr_addr_table   ; HL' = table pointer
    exx
    ld b, 64                ; 64 iterations × 2 lines = 128 lines
    
copy_loop:
    ; === Line 1 ===
    exx
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push de
    exx
    pop de

    ld c, 16
    
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    
    ; === Line 2 ===
    exx
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push de
    exx
    pop de
    
    ld c, 16

    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    
    djnz copy_loop
    
    ei
    ret

; Screen address lookup table for Y=32..159, X_byte=8
    SECTION rodata_user

scr_addr_table:
    ; Y=32-39 (third 0, char row 4)
    DEFW 0x4088, 0x4188, 0x4288, 0x4388, 0x4488, 0x4588, 0x4688, 0x4788
    ; Y=40-47 (third 0, char row 5)
    DEFW 0x40A8, 0x41A8, 0x42A8, 0x43A8, 0x44A8, 0x45A8, 0x46A8, 0x47A8
    ; Y=48-55 (third 0, char row 6)
    DEFW 0x40C8, 0x41C8, 0x42C8, 0x43C8, 0x44C8, 0x45C8, 0x46C8, 0x47C8
    ; Y=56-63 (third 0, char row 7)
    DEFW 0x40E8, 0x41E8, 0x42E8, 0x43E8, 0x44E8, 0x45E8, 0x46E8, 0x47E8
    ; Y=64-71 (third 1, char row 0)
    DEFW 0x4808, 0x4908, 0x4A08, 0x4B08, 0x4C08, 0x4D08, 0x4E08, 0x4F08
    ; Y=72-79 (third 1, char row 1)
    DEFW 0x4828, 0x4928, 0x4A28, 0x4B28, 0x4C28, 0x4D28, 0x4E28, 0x4F28
    ; Y=80-87 (third 1, char row 2)
    DEFW 0x4848, 0x4948, 0x4A48, 0x4B48, 0x4C48, 0x4D48, 0x4E48, 0x4F48
    ; Y=88-95 (third 1, char row 3)
    DEFW 0x4868, 0x4968, 0x4A68, 0x4B68, 0x4C68, 0x4D68, 0x4E68, 0x4F68
    ; Y=96-103 (third 1, char row 4)
    DEFW 0x4888, 0x4988, 0x4A88, 0x4B88, 0x4C88, 0x4D88, 0x4E88, 0x4F88
    ; Y=104-111 (third 1, char row 5)
    DEFW 0x48A8, 0x49A8, 0x4AA8, 0x4BA8, 0x4CA8, 0x4DA8, 0x4EA8, 0x4FA8
    ; Y=112-119 (third 1, char row 6)
    DEFW 0x48C8, 0x49C8, 0x4AC8, 0x4BC8, 0x4CC8, 0x4DC8, 0x4EC8, 0x4FC8
    ; Y=120-127 (third 1, char row 7)
    DEFW 0x48E8, 0x49E8, 0x4AE8, 0x4BE8, 0x4CE8, 0x4DE8, 0x4EE8, 0x4FE8
    ; Y=128-135 (third 2, char row 0)
    DEFW 0x5008, 0x5108, 0x5208, 0x5308, 0x5408, 0x5508, 0x5608, 0x5708
    ; Y=136-143 (third 2, char row 1)
    DEFW 0x5028, 0x5128, 0x5228, 0x5328, 0x5428, 0x5528, 0x5628, 0x5728
    ; Y=144-151 (third 2, char row 2)
    DEFW 0x5048, 0x5148, 0x5248, 0x5348, 0x5448, 0x5548, 0x5648, 0x5748
    ; Y=152-159 (third 2, char row 3)
    DEFW 0x5068, 0x5168, 0x5268, 0x5368, 0x5468, 0x5568, 0x5668, 0x5768
