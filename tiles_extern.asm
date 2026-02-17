; contended_data.asm - Declares data addresses in contended RAM
; The actual data is loaded separately by the BASIC loader
; Address 0x6000 is safely above ZX Spectrum system variables (0x5B00-0x5CB5)
;
; Layout:
;   0x6000 - tiles     (2048 bytes, ends at 0x6800)
;   0x6800 - map_data  (4608 bytes, ends at 0x7A00)

    SECTION code_user

    PUBLIC _tiles
    DEFC _tiles = $6000

    PUBLIC _map_data
    DEFC _map_data = $6800
