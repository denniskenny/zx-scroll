;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (Mac OS X ppc)
;--------------------------------------------------------
; Processed by Z88DK
;--------------------------------------------------------

	EXTERN __divschar
	EXTERN __divschar_callee
	EXTERN __divsint
	EXTERN __divsint_callee
	EXTERN __divslong
	EXTERN __divslong_callee
	EXTERN __divslonglong
	EXTERN __divslonglong_callee
	EXTERN __divsuchar
	EXTERN __divsuchar_callee
	EXTERN __divuchar
	EXTERN __divuchar_callee
	EXTERN __divuint
	EXTERN __divuint_callee
	EXTERN __divulong
	EXTERN __divulong_callee
	EXTERN __divulonglong
	EXTERN __divulonglong_callee
	EXTERN __divuschar
	EXTERN __divuschar_callee
	EXTERN __modschar
	EXTERN __modschar_callee
	EXTERN __modsint
	EXTERN __modsint_callee
	EXTERN __modslong
	EXTERN __modslong_callee
	EXTERN __modslonglong
	EXTERN __modslonglong_callee
	EXTERN __modsuchar
	EXTERN __modsuchar_callee
	EXTERN __moduchar
	EXTERN __moduchar_callee
	EXTERN __moduint
	EXTERN __moduint_callee
	EXTERN __modulong
	EXTERN __modulong_callee
	EXTERN __modulonglong
	EXTERN __modulonglong_callee
	EXTERN __moduschar
	EXTERN __moduschar_callee
	EXTERN __mulint
	EXTERN __mulint_callee
	EXTERN __mullong
	EXTERN __mullong_callee
	EXTERN __mullonglong
	EXTERN __mullonglong_callee
	EXTERN __mulschar
	EXTERN __mulschar_callee
	EXTERN __mulsuchar
	EXTERN __mulsuchar_callee
	EXTERN __muluchar
	EXTERN __muluchar_callee
	EXTERN __muluschar
	EXTERN __muluschar_callee
	EXTERN __rlslonglong
	EXTERN __rlslonglong_callee
	EXTERN __rlulonglong
	EXTERN __rlulonglong_callee
	EXTERN __rrslonglong
	EXTERN __rrslonglong_callee
	EXTERN __rrulonglong
	EXTERN __rrulonglong_callee
	EXTERN ___mulsint2slong
	EXTERN ___mulsint2slong_callee
	EXTERN ___muluint2ulong
	EXTERN ___muluint2ulong_callee
	EXTERN ___sdcc_call_hl
	EXTERN ___sdcc_call_iy
	EXTERN ___sdcc_enter_ix
	EXTERN banked_call
	EXTERN _banked_ret
	EXTERN ___fs2schar
	EXTERN ___fs2schar_callee
	EXTERN ___fs2sint
	EXTERN ___fs2sint_callee
	EXTERN ___fs2slong
	EXTERN ___fs2slong_callee
	EXTERN ___fs2slonglong
	EXTERN ___fs2slonglong_callee
	EXTERN ___fs2uchar
	EXTERN ___fs2uchar_callee
	EXTERN ___fs2uint
	EXTERN ___fs2uint_callee
	EXTERN ___fs2ulong
	EXTERN ___fs2ulong_callee
	EXTERN ___fs2ulonglong
	EXTERN ___fs2ulonglong_callee
	EXTERN ___fsadd
	EXTERN ___fsadd_callee
	EXTERN ___fsdiv
	EXTERN ___fsdiv_callee
	EXTERN ___fseq
	EXTERN ___fseq_callee
	EXTERN ___fsgt
	EXTERN ___fsgt_callee
	EXTERN ___fslt
	EXTERN ___fslt_callee
	EXTERN ___fsmul
	EXTERN ___fsmul_callee
	EXTERN ___fsneq
	EXTERN ___fsneq_callee
	EXTERN ___fssub
	EXTERN ___fssub_callee
	EXTERN ___schar2fs
	EXTERN ___schar2fs_callee
	EXTERN ___sint2fs
	EXTERN ___sint2fs_callee
	EXTERN ___slong2fs
	EXTERN ___slong2fs_callee
	EXTERN ___slonglong2fs
	EXTERN ___slonglong2fs_callee
	EXTERN ___uchar2fs
	EXTERN ___uchar2fs_callee
	EXTERN ___uint2fs
	EXTERN ___uint2fs_callee
	EXTERN ___ulong2fs
	EXTERN ___ulong2fs_callee
	EXTERN ___ulonglong2fs
	EXTERN ___ulonglong2fs_callee
	EXTERN ____sdcc_2_copy_src_mhl_dst_deix
	EXTERN ____sdcc_2_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_deix
	EXTERN ____sdcc_4_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_mbc
	EXTERN ____sdcc_4_ldi_nosave_bc
	EXTERN ____sdcc_4_ldi_save_bc
	EXTERN ____sdcc_4_push_hlix
	EXTERN ____sdcc_4_push_mhl
	EXTERN ____sdcc_lib_setmem_hl
	EXTERN ____sdcc_ll_add_de_bc_hl
	EXTERN ____sdcc_ll_add_de_bc_hlix
	EXTERN ____sdcc_ll_add_de_hlix_bc
	EXTERN ____sdcc_ll_add_de_hlix_bcix
	EXTERN ____sdcc_ll_add_deix_bc_hl
	EXTERN ____sdcc_ll_add_deix_hlix
	EXTERN ____sdcc_ll_add_hlix_bc_deix
	EXTERN ____sdcc_ll_add_hlix_deix_bc
	EXTERN ____sdcc_ll_add_hlix_deix_bcix
	EXTERN ____sdcc_ll_asr_hlix_a
	EXTERN ____sdcc_ll_asr_mbc_a
	EXTERN ____sdcc_ll_copy_src_de_dst_hlix
	EXTERN ____sdcc_ll_copy_src_de_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_deix_dst_hl
	EXTERN ____sdcc_ll_copy_src_deix_dst_hlix
	EXTERN ____sdcc_ll_copy_src_deixm_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_desp_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_hl_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_deixm
	EXTERN ____sdcc_ll_lsl_hlix_a
	EXTERN ____sdcc_ll_lsl_mbc_a
	EXTERN ____sdcc_ll_lsr_hlix_a
	EXTERN ____sdcc_ll_lsr_mbc_a
	EXTERN ____sdcc_ll_push_hlix
	EXTERN ____sdcc_ll_push_mhl
	EXTERN ____sdcc_ll_sub_de_bc_hl
	EXTERN ____sdcc_ll_sub_de_bc_hlix
	EXTERN ____sdcc_ll_sub_de_hlix_bc
	EXTERN ____sdcc_ll_sub_de_hlix_bcix
	EXTERN ____sdcc_ll_sub_deix_bc_hl
	EXTERN ____sdcc_ll_sub_deix_hlix
	EXTERN ____sdcc_ll_sub_hlix_bc_deix
	EXTERN ____sdcc_ll_sub_hlix_deix_bc
	EXTERN ____sdcc_ll_sub_hlix_deix_bcix
	EXTERN ____sdcc_load_debc_deix
	EXTERN ____sdcc_load_dehl_deix
	EXTERN ____sdcc_load_debc_mhl
	EXTERN ____sdcc_load_hlde_mhl
	EXTERN ____sdcc_store_dehl_bcix
	EXTERN ____sdcc_store_debc_hlix
	EXTERN ____sdcc_store_debc_mhl
	EXTERN ____sdcc_cpu_pop_ei
	EXTERN ____sdcc_cpu_pop_ei_jp
	EXTERN ____sdcc_cpu_push_di
	EXTERN ____sdcc_outi
	EXTERN ____sdcc_outi_128
	EXTERN ____sdcc_outi_256
	EXTERN ____sdcc_ldi
	EXTERN ____sdcc_ldi_128
	EXTERN ____sdcc_ldi_256
	EXTERN ____sdcc_4_copy_srcd_hlix_dst_deix
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_dehl_dst_bcix
	EXTERN ____sdcc_4_and_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_cpl_src_mhl_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_or_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_hlix_dst_debc

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	GLOBAL _tile_render_main
	GLOBAL _load_scr_to_screen
	GLOBAL _clear_viewport_attrs
	GLOBAL _draw_man
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
	GLOBAL _shift_viewport_down
	GLOBAL _shift_viewport_up
	GLOBAL _shift_viewport_right
	GLOBAL _shift_viewport_left
	GLOBAL _render_full_viewport
	GLOBAL _render_dirty_row
	GLOBAL _render_dirty_column
	GLOBAL _ffsll_callee
	GLOBAL _ffsll
	GLOBAL _strxfrm_callee
	GLOBAL _strxfrm
	GLOBAL _strupr_fastcall
	GLOBAL _strupr
	GLOBAL _strtok_r_callee
	GLOBAL _strtok_r
	GLOBAL _strtok_callee
	GLOBAL _strtok
	GLOBAL _strstrip_fastcall
	GLOBAL _strstrip
	GLOBAL _strstr_callee
	GLOBAL _strstr
	GLOBAL _strspn_callee
	GLOBAL _strspn
	GLOBAL _strsep_callee
	GLOBAL _strsep
	GLOBAL _strrstrip_fastcall
	GLOBAL _strrstrip
	GLOBAL _strrstr_callee
	GLOBAL _strrstr
	GLOBAL _strrspn_callee
	GLOBAL _strrspn
	GLOBAL _strrev_fastcall
	GLOBAL _strrev
	GLOBAL _strrcspn_callee
	GLOBAL _strrcspn
	GLOBAL _strrchr_callee
	GLOBAL _strrchr
	GLOBAL _strpbrk_callee
	GLOBAL _strpbrk
	GLOBAL _strnlen_callee
	GLOBAL _strnlen
	GLOBAL _strnicmp_callee
	GLOBAL _strnicmp
	GLOBAL _strndup_callee
	GLOBAL _strndup
	GLOBAL _strncpy_callee
	GLOBAL _strncpy
	GLOBAL _strncmp_callee
	GLOBAL _strncmp
	GLOBAL _strnchr_callee
	GLOBAL _strnchr
	GLOBAL _strncat_callee
	GLOBAL _strncat
	GLOBAL _strncasecmp_callee
	GLOBAL _strncasecmp
	GLOBAL _strlwr_fastcall
	GLOBAL _strlwr
	GLOBAL _strlen_fastcall
	GLOBAL _strlen
	GLOBAL _strlcpy_callee
	GLOBAL _strlcpy
	GLOBAL _strlcat_callee
	GLOBAL _strlcat
	GLOBAL _stricmp_callee
	GLOBAL _stricmp
	GLOBAL _strerror_fastcall
	GLOBAL _strerror
	GLOBAL _strdup_fastcall
	GLOBAL _strdup
	GLOBAL _strcspn_callee
	GLOBAL _strcspn
	GLOBAL _strcpy_callee
	GLOBAL _strcpy
	GLOBAL _strcoll_callee
	GLOBAL _strcoll
	GLOBAL _strcmp_callee
	GLOBAL _strcmp
	GLOBAL _strchrnul_callee
	GLOBAL _strchrnul
	GLOBAL _strchr_callee
	GLOBAL _strchr
	GLOBAL _strcat_callee
	GLOBAL _strcat
	GLOBAL _strcasecmp_callee
	GLOBAL _strcasecmp
	GLOBAL _stpncpy_callee
	GLOBAL _stpncpy
	GLOBAL _stpcpy_callee
	GLOBAL _stpcpy
	GLOBAL _memswap_callee
	GLOBAL _memswap
	GLOBAL _memset_wr_callee
	GLOBAL _memset_wr
	GLOBAL _memset_callee
	GLOBAL _memset
	GLOBAL _memrchr_callee
	GLOBAL _memrchr
	GLOBAL _memmove_callee
	GLOBAL _memmove
	GLOBAL _memmem_callee
	GLOBAL _memmem
	GLOBAL _memcpy_callee
	GLOBAL _memcpy
	GLOBAL _memcmp_callee
	GLOBAL _memcmp
	GLOBAL _memchr_callee
	GLOBAL _memchr
	GLOBAL _memccpy_callee
	GLOBAL _memccpy
	GLOBAL _ffsl_fastcall
	GLOBAL _ffsl
	GLOBAL _ffs_fastcall
	GLOBAL _ffs
	GLOBAL __strrstrip__fastcall
	GLOBAL __strrstrip_
	GLOBAL __memupr__callee
	GLOBAL __memupr_
	GLOBAL __memstrcpy__callee
	GLOBAL __memstrcpy_
	GLOBAL __memlwr__callee
	GLOBAL __memlwr_
	GLOBAL _rawmemchr_callee
	GLOBAL _rawmemchr
	GLOBAL _strnset_callee
	GLOBAL _strnset
	GLOBAL _strset_callee
	GLOBAL _strset
	GLOBAL _rindex_callee
	GLOBAL _rindex
	GLOBAL _index_callee
	GLOBAL _index
	GLOBAL _bzero_callee
	GLOBAL _bzero
	GLOBAL _bcopy_callee
	GLOBAL _bcopy
	GLOBAL _bcmp_callee
	GLOBAL _bcmp
	GLOBAL _intrinsic_swap_word_32_fastcall
	GLOBAL _intrinsic_swap_word_32
	GLOBAL _intrinsic_swap_endian_32_fastcall
	GLOBAL _intrinsic_swap_endian_32
	GLOBAL _intrinsic_swap_endian_16_fastcall
	GLOBAL _intrinsic_swap_endian_16
	GLOBAL _intrinsic_return_de
	GLOBAL _intrinsic_return_bc
	GLOBAL _intrinsic_exx
	GLOBAL _intrinsic_ex_de_hl
	GLOBAL _intrinsic_nop
	GLOBAL _intrinsic_im_2
	GLOBAL _intrinsic_im_1
	GLOBAL _intrinsic_im_0
	GLOBAL _intrinsic_retn
	GLOBAL _intrinsic_reti
	GLOBAL _intrinsic_halt
	GLOBAL _intrinsic_ei
	GLOBAL _intrinsic_di
	GLOBAL _intrinsic_stub
	GLOBAL _intrinsic_ini
	GLOBAL _intrinsic_outi
	GLOBAL _intrinsic_ldi
	GLOBAL _zx_pattern_fill_callee
	GLOBAL _zx_pattern_fill
	GLOBAL _zx_saddrpup_fastcall
	GLOBAL _zx_saddrpup
	GLOBAL _zx_saddrpright_callee
	GLOBAL _zx_saddrpright
	GLOBAL _zx_saddrpleft_callee
	GLOBAL _zx_saddrpleft
	GLOBAL _zx_saddrpdown_fastcall
	GLOBAL _zx_saddrpdown
	GLOBAL _zx_saddrcup_fastcall
	GLOBAL _zx_saddrcup
	GLOBAL _zx_saddrcright_fastcall
	GLOBAL _zx_saddrcright
	GLOBAL _zx_saddrcleft_fastcall
	GLOBAL _zx_saddrcleft
	GLOBAL _zx_saddrcdown_fastcall
	GLOBAL _zx_saddrcdown
	GLOBAL _zx_saddr2py_fastcall
	GLOBAL _zx_saddr2py
	GLOBAL _zx_saddr2px_fastcall
	GLOBAL _zx_saddr2px
	GLOBAL _zx_saddr2cy_fastcall
	GLOBAL _zx_saddr2cy
	GLOBAL _zx_saddr2cx_fastcall
	GLOBAL _zx_saddr2cx
	GLOBAL _zx_saddr2aaddr_fastcall
	GLOBAL _zx_saddr2aaddr
	GLOBAL _zx_py2saddr_fastcall
	GLOBAL _zx_py2saddr
	GLOBAL _zx_py2aaddr_fastcall
	GLOBAL _zx_py2aaddr
	GLOBAL _zx_pxy2saddr_callee
	GLOBAL _zx_pxy2saddr
	GLOBAL _zx_pxy2aaddr_callee
	GLOBAL _zx_pxy2aaddr
	GLOBAL _zx_px2bitmask_fastcall
	GLOBAL _zx_px2bitmask
	GLOBAL _zx_cy2saddr_fastcall
	GLOBAL _zx_cy2saddr
	GLOBAL _zx_cy2aaddr_fastcall
	GLOBAL _zx_cy2aaddr
	GLOBAL _zx_cxy2saddr_callee
	GLOBAL _zx_cxy2saddr
	GLOBAL _zx_cxy2aaddr_callee
	GLOBAL _zx_cxy2aaddr
	GLOBAL _zx_bitmask2px_fastcall
	GLOBAL _zx_bitmask2px
	GLOBAL _zx_aaddrcup_fastcall
	GLOBAL _zx_aaddrcup
	GLOBAL _zx_aaddrcright_fastcall
	GLOBAL _zx_aaddrcright
	GLOBAL _zx_aaddrcleft_fastcall
	GLOBAL _zx_aaddrcleft
	GLOBAL _zx_aaddrcdown_fastcall
	GLOBAL _zx_aaddrcdown
	GLOBAL _zx_aaddr2saddr_fastcall
	GLOBAL _zx_aaddr2saddr
	GLOBAL _zx_aaddr2py_fastcall
	GLOBAL _zx_aaddr2py
	GLOBAL _zx_aaddr2px_fastcall
	GLOBAL _zx_aaddr2px
	GLOBAL _zx_aaddr2cy_fastcall
	GLOBAL _zx_aaddr2cy
	GLOBAL _zx_aaddr2cx_fastcall
	GLOBAL _zx_aaddr2cx
	GLOBAL _zx_visit_wc_pix_callee
	GLOBAL _zx_visit_wc_pix
	GLOBAL _zx_visit_wc_attr_callee
	GLOBAL _zx_visit_wc_attr
	GLOBAL _zx_scroll_wc_up_pix_callee
	GLOBAL _zx_scroll_wc_up_pix
	GLOBAL _zx_scroll_wc_up_attr_callee
	GLOBAL _zx_scroll_wc_up_attr
	GLOBAL _zx_scroll_wc_up_callee
	GLOBAL _zx_scroll_wc_up
	GLOBAL _zx_scroll_up_pix_callee
	GLOBAL _zx_scroll_up_pix
	GLOBAL _zx_scroll_up_attr_callee
	GLOBAL _zx_scroll_up_attr
	GLOBAL _zx_scroll_up_callee
	GLOBAL _zx_scroll_up
	GLOBAL _zx_cls_wc_pix_callee
	GLOBAL _zx_cls_wc_pix
	GLOBAL _zx_cls_wc_attr_callee
	GLOBAL _zx_cls_wc_attr
	GLOBAL _zx_cls_wc_callee
	GLOBAL _zx_cls_wc
	GLOBAL _zx_cls_pix_fastcall
	GLOBAL _zx_cls_pix
	GLOBAL _zx_cls_attr_fastcall
	GLOBAL _zx_cls_attr
	GLOBAL _zx_cls_fastcall
	GLOBAL _zx_cls
	GLOBAL _zx_border_fastcall
	GLOBAL _zx_border
	GLOBAL _zx_tape_verify_block_callee
	GLOBAL _zx_tape_verify_block
	GLOBAL _zx_tape_save_block_callee
	GLOBAL _zx_tape_save_block
	GLOBAL _zx_tape_load_block_callee
	GLOBAL _zx_tape_load_block
	GLOBAL _in_mouse_kempston_wheel_delta
	GLOBAL _in_mouse_kempston_wheel
	GLOBAL _in_mouse_kempston_callee
	GLOBAL _in_mouse_kempston
	GLOBAL _in_mouse_kempston_setpos_callee
	GLOBAL _in_mouse_kempston_setpos
	GLOBAL _in_mouse_kempston_reset
	GLOBAL _in_mouse_kempston_init
	GLOBAL _in_mouse_amx_wheel_delta
	GLOBAL _in_mouse_amx_wheel
	GLOBAL _in_mouse_amx_callee
	GLOBAL _in_mouse_amx
	GLOBAL _in_mouse_amx_setpos_callee
	GLOBAL _in_mouse_amx_setpos
	GLOBAL _in_mouse_amx_reset
	GLOBAL _in_mouse_amx_init_callee
	GLOBAL _in_mouse_amx_init
	GLOBAL _in_stick_sinclair2
	GLOBAL _in_stick_sinclair1
	GLOBAL _in_stick_kempston
	GLOBAL _in_stick_fuller
	GLOBAL _in_stick_cursor
	GLOBAL _in_stick_keyboard_fastcall
	GLOBAL _in_stick_keyboard
	GLOBAL _in_wait_nokey
	GLOBAL _in_wait_key
	GLOBAL _in_test_key
	GLOBAL _in_pause_fastcall
	GLOBAL _in_pause
	GLOBAL _in_key_scancode_fastcall
	GLOBAL _in_key_scancode
	GLOBAL _in_key_pressed_fastcall
	GLOBAL _in_key_pressed
	GLOBAL _in_inkey
	GLOBAL _scr_addr_table_direct
	GLOBAL _map_data
	GLOBAL _GLOBAL_ZX_PORT_7FFD
	GLOBAL _GLOBAL_ZX_PORT_1FFD
	GLOBAL _GLOBAL_ZX_PORT_FE
	GLOBAL _hud_scr
	GLOBAL _tiles
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
defc _IO_FE	=	0x00fe
defc _IO_1FFD	=	0x1ffd
defc _IO_7FFD	=	0x7ffd
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION bss_compiler
_man_bg:
	DEFS 32
_man_bg_attr:
	DEFS 4
;--------------------------------------------------------
; ram data
;--------------------------------------------------------

IF 0

; .area _INITIALIZED removed by z88dk

_camera_tile_x:
	DEFS 2
_camera_tile_y:
	DEFS 2
_prev_tile_x:
	DEFS 2
_prev_tile_y:
	DEFS 2
_frame_count:
	DEFS 1

ENDIF

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	SECTION IGNORE
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	SECTION code_crt_init
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	SECTION code_home
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION code_compiler
;	---------------------------------
; Function read_input
; ---------------------------------
_read_input:
	ld	c,0x00
	ld	hl,0x01fb
	call	_in_key_pressed_fastcall
	ld	a, h
	or	a, l
	jr	Z,l_read_input_00102
	ld	c,0x08
l_read_input_00102:
	ld	hl,0x01fd
	call	_in_key_pressed_fastcall
	ld	a, h
	or	a, l
	jr	Z,l_read_input_00104
	set	2, c
l_read_input_00104:
	ld	hl,0x02df
	call	_in_key_pressed_fastcall
	ld	a, h
	or	a, l
	jr	Z,l_read_input_00106
	set	1, c
l_read_input_00106:
	ld	hl,0x01df
	call	_in_key_pressed_fastcall
	ld	a, h
	or	a, l
	jr	Z,l_read_input_00108
	set	0, c
l_read_input_00108:
	ld	a, c
	or	a, a
	jr	Z,l_read_input_00110
	ld	l, c
	jr	l_read_input_00119
l_read_input_00110:
	call	_in_stick_kempston
	bit	0, l
	jr	Z,l_read_input_00112
	set	3, c
l_read_input_00112:
	bit	1, l
	jr	Z,l_read_input_00114
	set	2, c
l_read_input_00114:
	bit	2, l
	jr	Z,l_read_input_00116
	set	1, c
l_read_input_00116:
	bit	3, l
	jr	Z,l_read_input_00118
	set	0, c
l_read_input_00118:
	ld	l, c
l_read_input_00119:
	ret
	SECTION rodata_compiler
_man_sprite:
	DEFB +0xf0
	DEFB +0x03
	DEFB +0x0f
	DEFB +0xc0
	DEFB +0xf0
	DEFB +0x07
	DEFB +0x0f
	DEFB +0xe0
	DEFB +0xf0
	DEFB +0x06
	DEFB +0x0f
	DEFB +0x60
	DEFB +0xf0
	DEFB +0x07
	DEFB +0x0f
	DEFB +0xe0
	DEFB +0xc0
	DEFB +0x03
	DEFB +0x03
	DEFB +0xc0
	DEFB +0x80
	DEFB +0x1f
	DEFB +0x01
	DEFB +0xf8
	DEFB +0x80
	DEFB +0x3f
	DEFB +0x01
	DEFB +0xfc
	DEFB +0x80
	DEFB +0x33
	DEFB +0x01
	DEFB +0xcc
	DEFB +0x80
	DEFB +0x03
	DEFB +0x01
	DEFB +0xc0
	DEFB +0xf0
	DEFB +0x03
	DEFB +0x0f
	DEFB +0xc0
	DEFB +0xf0
	DEFB +0x07
	DEFB +0x0f
	DEFB +0xe0
	DEFB +0xe0
	DEFB +0x06
	DEFB +0x07
	DEFB +0x60
	DEFB +0xe0
	DEFB +0x0c
	DEFB +0x07
	DEFB +0x30
	DEFB +0xc1
	DEFB +0x0c
	DEFB +0x83
	DEFB +0x30
	DEFB +0x81
	DEFB +0x18
	DEFB +0x81
	DEFB +0x18
	DEFB +0x81
	DEFB +0x3c
	DEFB +0x81
	DEFB +0x3c
	SECTION code_compiler
;	---------------------------------
; Function flash_border_red
; ---------------------------------
_flash_border_red:
	ld	a, 2
	out	(0xFE), a
	ret
;	---------------------------------
; Function reset_border
; ---------------------------------
_reset_border:
	xor	a
	out	(0xFE), a
	ret
;	---------------------------------
; Function handle_tile
; ---------------------------------
_handle_tile:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	a,(ix+4)
	dec	a
	jr	Z,l_handle_tile_00101
	ld	a,(ix+4)
	sub	a,0x03
	jr	Z,l_handle_tile_00102
	jr	l_handle_tile_00103
l_handle_tile_00101:
	ld	l,0x01
	jr	l_handle_tile_00105
l_handle_tile_00102:
	call	_flash_border_red
	ld	l,0x00
	jr	l_handle_tile_00105
l_handle_tile_00103:
	ld	l,0x00
l_handle_tile_00105:
	pop	ix
	ret
;	---------------------------------
; Function man_can_move
; ---------------------------------
_man_can_move:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	a,(ix+4)
	add	a,0x09
	ld	c, a
	ld	a,(ix+5)
	adc	a,0x00
	ld	b, a
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	de,0x0007
	add	hl, de
	bit	7, b
	jr	NZ,l_man_can_move_00101
	ld	e, c
	ld	d, b
	inc	de
	ld	a, e
	sub	a,0x60
	ld	a, d
	rla
	ccf
	rra
	sbc	a,0x80
	jr	NC,l_man_can_move_00101
	bit	7, h
	jr	NZ,l_man_can_move_00101
	ld	e, l
	ld	d, h
	inc	de
	ld	a, e
	sub	a,0x30
	ld	a, d
	rla
	ccf
	rra
	sbc	a,0x80
	jr	C,l_man_can_move_00102
l_man_can_move_00101:
	ld	l,0x01
	jr	l_man_can_move_00111
l_man_can_move_00102:
	push	hl
	push	bc
	call	_reset_border
	pop	bc
	pop	hl
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ex	de, hl
	ld	hl,_map_data
	add	hl, de
	ld	a, (hl)
	push	de
	push	af
	inc	sp
	call	_handle_tile
	inc	sp
	ld	a, l
	pop	de
	or	a, a
	jr	NZ,l_man_can_move_00106
	ld	c, e
	ld	b, d
	inc	bc
	ld	hl,_map_data
	add	hl, bc
	ld	a, (hl)
	push	de
	push	af
	inc	sp
	call	_handle_tile
	inc	sp
	ld	a, l
	pop	de
	or	a, a
	jr	NZ,l_man_can_move_00106
	ld	hl,0x0060 + _map_data
	add	hl,de
	ld	a, (hl)
	push	de
	push	af
	inc	sp
	call	_handle_tile
	inc	sp
	ld	a, l
	pop	de
	or	a, a
	jr	NZ,l_man_can_move_00106
	ld	hl,0x0061
	add	hl, de
	ld	de,_map_data
	add	hl, de
	ld	a, (hl)
	push	af
	inc	sp
	call	_handle_tile
	inc	sp
	ld	a, l
	or	a, a
	jr	Z,l_man_can_move_00107
l_man_can_move_00106:
	ld	l,0x00
	jr	l_man_can_move_00111
l_man_can_move_00107:
	ld	l,0x01
l_man_can_move_00111:
	pop	ix
	ret
;	---------------------------------
; Function update_camera
; ---------------------------------
_update_camera:
	push	ix
	ld	ix,0
	add	ix,sp
	push	af
	dec	sp
	ld	hl, (_camera_tile_x)
	ld	(ix-2),l
	ld	(ix-1),h
	ld	bc, (_camera_tile_y)
	ld	e, c
	ld	d, b
	ld	(_prev_tile_x), hl
	ld	(_prev_tile_y), bc
	ld	a,(ix+4)
	ld	(ix-3),a
	bit	0,a
	jr	Z,l_update_camera_00102
	inc	hl
	ld	(ix-2),l
	ld	(ix-1),h
l_update_camera_00102:
	bit	1,(ix-3)
	jr	Z,l_update_camera_00104
	ld	l,(ix-2)
	ld	h,(ix-1)
	dec	hl
	ld	(ix-2),l
	ld	(ix-1),h
l_update_camera_00104:
	push	bc
	push	de
	push	bc
	ld	l,(ix-2)
	ld	h,(ix-1)
	push	hl
	call	_man_can_move
	pop	af
	pop	af
	ld	a, l
	pop	de
	pop	bc
	or	a, a
	jr	NZ,l_update_camera_00106
	ld	hl,(_camera_tile_x)
	ld	(ix-2),l
	ld	(ix-1),h
l_update_camera_00106:
	bit	2,(ix-3)
	jr	Z,l_update_camera_00108
	ld	e, c
	ld	d, b
	inc	de
l_update_camera_00108:
	bit	3,(ix-3)
	jr	Z,l_update_camera_00110
	dec	de
l_update_camera_00110:
	push	de
	push	de
	ld	l,(ix-2)
	ld	h,(ix-1)
	push	hl
	call	_man_can_move
	pop	af
	pop	af
	ld	a, l
	pop	de
	or	a, a
	jr	NZ,l_update_camera_00112
	ld	a, (_camera_tile_y)
	ld	e, a
	ld	hl,_camera_tile_y + 1
	ld	d, (hl)
l_update_camera_00112:
	ld	l,(ix-2)
	ld	h,(ix-1)
	ld	(_camera_tile_x),hl
	ld	(_camera_tile_y),de
	ld	a,(_camera_tile_x)
	ld	hl,_prev_tile_x
	sub	a, (hl)
	jr	NZ,l_update_camera_00116
	ld	a,(_camera_tile_x + 1)
	inc	hl
	sub	a, (hl)
	jr	NZ,l_update_camera_00116
	ld	a,(_camera_tile_y)
	ld	hl,_prev_tile_y
	sub	a, (hl)
	jr	NZ,l_update_camera_00116
	ld	a,(_camera_tile_y + 1)
	inc	hl
	sub	a,(hl)
	jr	NZ,l_update_camera_00116
	ld	l,a
	jr	l_update_camera_00117
l_update_camera_00116:
	ld	l,0x01
l_update_camera_00117:
	ld	sp, ix
	pop	ix
	ret
;	---------------------------------
; Function safe_tile
; ---------------------------------
_safe_tile:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	b,(ix+5)
	ld	a,(ix+4)
	sub	a,0x60
	ld	a, b
	sbc	a,0x00
	jr	NC,l_safe_tile_00101
	ld	b,(ix+7)
	ld	a,(ix+6)
	sub	a,0x30
	ld	a, b
	sbc	a,0x00
	jr	C,l_safe_tile_00102
l_safe_tile_00101:
	ld	l,0x00
	jr	l_safe_tile_00104
l_safe_tile_00102:
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	c,l
	ld	b,h
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e,(ix+4)
	ld	d,(ix+5)
	add	hl,de
	ld	de,_map_data
	add	hl, de
	ld	l, (hl)
l_safe_tile_00104:
	pop	ix
	ret
;	---------------------------------
; Function render_tile_at
; ---------------------------------
_render_tile_at:
	push	ix
	ld	ix,0
	add	ix,sp
	push	af
	dec	sp
	ld	l,(ix+5)
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	(sp), hl
	ld	(ix-1),0x00
l_render_tile_at_00102:
	ld	c,(ix-1)
	ld	b,0x00
	ld	e, c
	ld	d, b
	pop	hl
	push	hl
	add	hl, de
	add	hl, hl
	ld	de,_scr_addr_table_direct
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	l,(ix+6)
	ld	h,0x00
	add	hl, de
	ex	de, hl
	ld	a,(ix+4)
	or	a, a
	jr	Z,l_render_tile_at_00106
	ld	l,(ix+4)
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc,_tiles
	add	hl, bc
	ld	a, (hl)
	jr	l_render_tile_at_00107
l_render_tile_at_00106:
	xor	a, a
l_render_tile_at_00107:
	ld	(de), a
	inc	(ix-1)
	ld	a,(ix-1)
	sub	a,0x08
	jr	C,l_render_tile_at_00102
	ld	sp, ix
	pop	ix
	ret
;	---------------------------------
; Function safe_render_column
; ---------------------------------
_safe_render_column:
	push	ix
	ld	ix,0
	add	ix,sp
	di
	ld	b,0x00
l_safe_render_column_00102:
	ld	e, b
	ld	d,0x00
	ld	hl,(_camera_tile_y)
	add	hl,de
	push	bc
	push	hl
	ld	l,(ix+5)
	ld	h,(ix+6)
	push	hl
	call	_safe_tile
	pop	af
	pop	af
	ld	a, l
	pop	bc
	push	bc
	ld	h,(ix+4)
	ld	l,b
	push	hl
	push	af
	inc	sp
	call	_render_tile_at
	pop	af
	inc	sp
	pop	bc
	inc	b
	ld	a, b
	sub	a,0x10
	jr	C,l_safe_render_column_00102
	ei
	pop	ix
	ret
;	---------------------------------
; Function safe_render_row
; ---------------------------------
_safe_render_row:
	push	ix
	ld	ix,0
	add	ix,sp
	di
	ld	c,0x00
l_safe_render_row_00102:
	ld	a, c
	add	a,0x06
	ld	b, a
	ld	e, c
	ld	d,0x00
	ld	hl,(_camera_tile_x)
	add	hl,de
	ex	de,hl
	push	bc
	ld	l,(ix+5)
	ld	h,(ix+6)
	push	hl
	push	de
	call	_safe_tile
	pop	af
	pop	af
	ld	a, l
	pop	bc
	push	bc
	push	bc
	inc	sp
	ld	h,(ix+4)
	ld	l,a
	push	hl
	call	_render_tile_at
	pop	af
	inc	sp
	pop	bc
	inc	c
	ld	a, c
	sub	a,0x14
	jr	C,l_safe_render_row_00102
	ei
	pop	ix
	ret
;	---------------------------------
; Function draw_column
; ---------------------------------
_draw_column:
	push	ix
	ld	ix,0
	add	ix,sp
	bit	7,(ix+6)
	jr	NZ,l_draw_column_00102
	ld	a,(ix+5)
	sub	a,0x60
	ld	a,(ix+6)
	rla
	ccf
	rra
	sbc	a,0x80
	jr	NC,l_draw_column_00102
	ld	hl,_camera_tile_y + 1
	bit	7,(hl)
	jr	NZ,l_draw_column_00102
	dec	hl
	ld	a, (hl)
	add	a,0x10
	ld	c, a
	inc	hl
	ld	a, (hl)
	adc	a,0x00
	ld	b, a
	ld	a,0x30
	cp	a, c
	ld	a,0x00
	sbc	a, b
	jp	PO, l_draw_column_00137
	xor	a,0x80
l_draw_column_00137:
	jp	M, l_draw_column_00102
	ld	bc,_map_data+0
	ld	hl,(_camera_tile_y)
	ld	e,l
	ld	d,h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e,(ix+5)
	ld	d,(ix+6)
	add	hl,de
	add	hl, bc
	push	hl
	ld	a,(ix+4)
	push	af
	inc	sp
	call	_render_dirty_column
	pop	af
	inc	sp
	jr	l_draw_column_00107
l_draw_column_00102:
	ld	l,(ix+5)
	ld	h,(ix+6)
	push	hl
	ld	a,(ix+4)
	push	af
	inc	sp
	call	_safe_render_column
	pop	af
	inc	sp
l_draw_column_00107:
	pop	ix
	ret
;	---------------------------------
; Function draw_row
; ---------------------------------
_draw_row:
	push	ix
	ld	ix,0
	add	ix,sp
	bit	7,(ix+6)
	jr	NZ,l_draw_row_00102
	ld	a,(ix+5)
	sub	a,0x30
	ld	a,(ix+6)
	rla
	ccf
	rra
	sbc	a,0x80
	jr	NC,l_draw_row_00102
	ld	hl,_camera_tile_x + 1
	bit	7,(hl)
	jr	NZ,l_draw_row_00102
	dec	hl
	ld	a, (hl)
	add	a,0x14
	ld	c, a
	inc	hl
	ld	a, (hl)
	adc	a,0x00
	ld	b, a
	ld	a,0x60
	cp	a, c
	ld	a,0x00
	sbc	a, b
	jp	PO, l_draw_row_00137
	xor	a,0x80
l_draw_row_00137:
	jp	M, l_draw_row_00102
	ld	l,(ix+5)
	ld	h,(ix+6)
	ld	c,l
	ld	b,h
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	hl,(_camera_tile_x)
	add	hl,de
	ld	bc,_map_data
	add	hl,bc
	push	hl
	ld	a,(ix+4)
	push	af
	inc	sp
	call	_render_dirty_row
	pop	af
	inc	sp
	jr	l_draw_row_00107
l_draw_row_00102:
	ld	l,(ix+5)
	ld	h,(ix+6)
	push	hl
	ld	a,(ix+4)
	push	af
	inc	sp
	call	_safe_render_row
	pop	af
	inc	sp
l_draw_row_00107:
	pop	ix
	ret
;	---------------------------------
; Function clear_viewport_attrs
; ---------------------------------
_clear_viewport_attrs:
	ld	c,0x00
l_clear_viewport_attrs_00102:
	ld	e, c
	ld	d,0x00
	ld	hl,0x0008
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de,0x5806
	add	hl, de
	ld	b,0x0a
l_clear_viewport_attrs_00114:
	ld	(hl),0x48
	inc	hl
	ld	(hl),0x48
	inc	hl
	djnz	l_clear_viewport_attrs_00114
	inc	c
	ld	a, c
	sub	a,0x10
	jr	C,l_clear_viewport_attrs_00102
	ret
;	---------------------------------
; Function load_scr_to_screen
; ---------------------------------
_load_scr_to_screen:
	push	ix
	ld	ix,0
	add	ix,sp
	di
	ld	l,(ix+4)
	ld	h,(ix+5)
	ld	de,0x4000
	ld	bc,0x1b00
	ldir
	ei
	pop	ix
	ret
;	---------------------------------
; Function erase_man
; ---------------------------------
_erase_man:
	ld	c,0x00
l_erase_man_00102:
	ld	e, c
	ld	d,0x00
	ld	hl,0x0038
	add	hl, de
	add	hl, hl
	ld	a, l
	add	a, +((_scr_addr_table_direct) & 0xFF)
	ld	l, a
	ld	a, h
	adc	a, +((_scr_addr_table_direct) / 256)
	ld	h, a
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	add	a,0x0f
	ld	l, a
	jr	NC,l_erase_man_00121
	inc	h
l_erase_man_00121:
	ld	a, e
	add	a, a
	rl	d
	add	a, +((_man_bg) & 0xFF)
	ld	e, a
	ld	a, d
	adc	a, +((_man_bg) / 256)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	inc	hl
	ld	a, c
	add	a, a
	inc	a
	add	a, +((_man_bg) & 0xFF)
	ld	e, a
	ld	a,0x00
	adc	a, +((_man_bg) / 256)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	inc	c
	ld	a, c
	sub	a,0x10
	jr	C,l_erase_man_00102
	ld	a,(_man_bg_attr)
	ld	hl,0x59ef
	ld	(hl), a
	ld	a, (_man_bg_attr + 1)
	ld	l,0xf0
	ld	(hl), a
	ld	a, (_man_bg_attr + 2)
	ld	hl,0x5a0f
	ld	(hl), a
	ld	a, (_man_bg_attr + 3)
	ld	l,0x10
	ld	(hl), a
	ret
;	---------------------------------
; Function draw_man
; ---------------------------------
_draw_man:
	push	ix
	ld	ix,0
	add	ix,sp
	push	af
	push	af
	ld	c,0x00
l_draw_man_00102:
	ld	e, c
	ld	d,0x00
	ld	hl,0x0038
	add	hl, de
	add	hl, hl
	ld	a, l
	add	a, +((_scr_addr_table_direct) & 0xFF)
	ld	l, a
	ld	a, h
	adc	a, +((_scr_addr_table_direct) / 256)
	ld	h, a
	ld	a, (hl)
	inc	hl
	ld	b, (hl)
	add	a,0x0f
	ld	l, a
	ld	a, b
	adc	a,0x00
	ld	(ix-4),l
	ld	(ix-3),a
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, +((_man_sprite) & 0xFF)
	ld	b, a
	ld	a, h
	adc	a, +((_man_sprite) / 256)
	ld	(ix-2),b
	ld	(ix-1),a
	ex	de, hl
	add	hl, hl
	ld	de,_man_bg
	add	hl,de
	ex	de,hl
	pop	hl
	ld	a,(hl)
	push	hl
	ld	(de), a
	ld	a, c
	add	a, a
	inc	a
	ld	l, a
	ld	h,0x00
	ld	de,_man_bg
	add	hl, de
	pop	de
	push	de
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	hl
	ld	a,(hl)
	push	hl
	ld	l,(ix-2)
	ld	h,(ix-1)
	ld	b, (hl)
	and	a, b
	ld	l,(ix-2)
	ld	h,(ix-1)
	inc	hl
	ld	b, (hl)
	or	a, b
	pop	hl
	push	hl
	ld	(hl), a
	ld	a, (de)
	ld	l,(ix-2)
	ld	h,(ix-1)
	inc	hl
	inc	hl
	ld	b, (hl)
	and	a, b
	ld	l,(ix-2)
	ld	h,(ix-1)
	inc	hl
	inc	hl
	inc	hl
	ld	b, (hl)
	or	a, b
	ld	(de), a
	inc	c
	ld	a, c
	sub	a,0x10
	jr	C,l_draw_man_00102
	ld	a, (0x59ef)
	ld	hl,_man_bg_attr
	ld	(hl), a
	ld	a, (0x59f0)
	inc	hl
	ld	(hl), a
	ld	a, (0x59ef)
	and	a,0xf8
	or	a,0x06
	ld	hl,0x59ef
	ld	(hl), a
	ld	a, (0x59f0)
	and	a,0xf8
	or	a,0x06
	ld	l,0xf0
	ld	(hl), a
	ld	a, (0x5a0f)
	ld	hl, +(_man_bg_attr + 2)
	ld	(hl), a
	ld	a, (0x5a10)
	inc	hl
	ld	(hl), a
	ld	a, (0x5a0f)
	and	a,0xf8
	or	a,0x04
	ld	hl,0x5a0f
	ld	(hl), a
	ld	a, (0x5a10)
	and	a,0xf8
	or	a,0x04
	ld	l,0x10
	ld	(hl), a
	ld	sp, ix
	pop	ix
	ret
;	---------------------------------
; Function tile_render_main
; ---------------------------------
_tile_render_main:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl, -5
	add	hl, sp
	ld	sp, hl
	ld	hl,_hud_scr
	push	hl
	call	_load_scr_to_screen
	pop	af
	call	_clear_viewport_attrs
	ld	hl,(_camera_tile_y)
	ld	c,l
	ld	b,h
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	hl,(_camera_tile_x)
	add	hl,de
	ld	bc,_map_data
	add	hl,bc
	push	hl
	call	_render_full_viewport
	pop	af
	call	_draw_man
	xor	a, a
	ld	(_frame_count),a
l_tile_render_main_00128:
	halt
	call	_read_input
	ld	b, l
	ld	hl,_frame_count
	ld	a,(hl)
	inc	a
	ld	(hl),a
	sub	a,0x03
	jr	C,l_tile_render_main_00128
	ld	a, b
	or	a, a
	jr	NZ,l_tile_render_main_00104
	ld	(hl),0x02
	jr	l_tile_render_main_00128
l_tile_render_main_00104:
	xor	a, a
	ld	(_frame_count),a
	push	bc
	inc	sp
	call	_update_camera
	inc	sp
	ld	a, l
	or	a, a
	jr	Z,l_tile_render_main_00128
	ld	hl,(_camera_tile_x)
	ld	de,(_prev_tile_x)
	xor	a,a
	sbc	hl,de
	ld	(ix-5),l
	ld	(ix-4),h
	ld	hl,(_camera_tile_y)
	ld	de,(_prev_tile_y)
	xor	a,a
	sbc	hl,de
	ld	(ix-2),l
	ld	(ix-1),h
	call	_erase_man
	xor	a, a
	cp	a,(ix-5)
	sbc	a,(ix-4)
	jp	PO, l_tile_render_main_00216
	xor	a,0x80
l_tile_render_main_00216:
	rlca
	and	a,0x01
	ld	(ix-3),a
	or	a, a
	jr	Z,l_tile_render_main_00108
	call	_shift_viewport_left
	jr	l_tile_render_main_00109
l_tile_render_main_00108:
	bit	7,(ix-4)
	jr	Z,l_tile_render_main_00109
	call	_shift_viewport_right
l_tile_render_main_00109:
	xor	a, a
	cp	a,(ix-2)
	sbc	a,(ix-1)
	jp	PO, l_tile_render_main_00217
	xor	a,0x80
l_tile_render_main_00217:
	rlca
	and	a,0x01
	ld	c,a
	or	a, a
	jr	Z,l_tile_render_main_00113
	push	bc
	call	_shift_viewport_up
	pop	bc
	jr	l_tile_render_main_00114
l_tile_render_main_00113:
	bit	7,(ix-1)
	jr	Z,l_tile_render_main_00114
	push	bc
	call	_shift_viewport_down
	pop	bc
l_tile_render_main_00114:
	ld	a, c
	or	a, a
	jr	Z,l_tile_render_main_00118
	ld	hl,_camera_tile_y
	ld	a, (hl)
	add	a,0x0f
	ld	(ix-2),a
	inc	hl
	ld	a, (hl)
	adc	a,0x00
	ld	l,(ix-2)
	ld	(ix-1),a
	ld	h,a
	push	hl
	ld	a,0x0f
	push	af
	inc	sp
	call	_draw_row
	pop	af
	inc	sp
	jr	l_tile_render_main_00119
l_tile_render_main_00118:
	bit	7,(ix-1)
	jr	Z,l_tile_render_main_00119
	ld	hl, (_camera_tile_y)
	push	hl
	xor	a, a
	push	af
	inc	sp
	call	_draw_row
	pop	af
	inc	sp
l_tile_render_main_00119:
	call	_draw_man
	ld	a,(ix-3)
	or	a, a
	jr	Z,l_tile_render_main_00123
	ld	hl,(_camera_tile_x)
	ld	bc,0x0013
	add	hl,bc
	push	hl
	ld	a,0x19
	push	af
	inc	sp
	call	_draw_column
	pop	af
	inc	sp
	jp	l_tile_render_main_00128
l_tile_render_main_00123:
	bit	7,(ix-4)
	jp	Z, l_tile_render_main_00128
	ld	hl, (_camera_tile_x)
	push	hl
	ld	a,0x06
	push	af
	inc	sp
	call	_draw_column
	pop	af
	inc	sp
	jp	l_tile_render_main_00128
	SECTION data_compiler
_camera_tile_x:
	DEFW +0x000a
_camera_tile_y:
	DEFW +0x000a
_prev_tile_x:
	DEFW +0x0000
_prev_tile_y:
	DEFW +0x0000
_frame_count:
	DEFB +0x00
	SECTION IGNORE
