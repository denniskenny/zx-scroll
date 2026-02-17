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
	GLOBAL _main
	GLOBAL _draw_initial_tilemap
	GLOBAL _clear_viewport_attrs
	GLOBAL _head_row
	GLOBAL _camera_y
	GLOBAL _camera_x
	GLOBAL _load_scr_to_screen
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
	GLOBAL _copy_viewport_32x16_to_screen_ring
	GLOBAL _copy_viewport_32x16_to_screen
	GLOBAL _shift_buffer_down_8rows
	GLOBAL _shift_buffer_up_8rows
	GLOBAL _shift_buffer_right_8px
	GLOBAL _shift_buffer_left_8px
	GLOBAL _shift_buffer_right_4px
	GLOBAL _shift_buffer_left_4px
	GLOBAL _shift_buffer_right_2px
	GLOBAL _shift_buffer_left_2px
	GLOBAL _shift_buffer_right_1px_rows
	GLOBAL _shift_buffer_left_1px_rows
	GLOBAL _shift_buffer_down_1row
	GLOBAL _shift_buffer_up_1row
	GLOBAL _shift_buffer_right_1px
	GLOBAL _shift_buffer_left_1px
	GLOBAL _dirty_edge_scroll
	GLOBAL _dirty_edge_full_redraw
	GLOBAL _dirty_edge_init
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
	GLOBAL _offscreen_buffer_32x16
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
;--------------------------------------------------------
; ram data
;--------------------------------------------------------

IF 0

; .area _INITIALIZED removed by z88dk

_camera_x:
	DEFS 2
_camera_y:
	DEFS 2
_head_row:
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
; Function read_keys
; ---------------------------------
_read_keys:
	ld	l,0x00
;	Read QWERT row (port 0xFBFE) - Q is bit 0
	ld	bc,0xFBFE
	in	a, (c)
	bit	0, a
	jr	nz, _no_q
	set	3, l
_no_q:
;	Read ASDFG row (port 0xFDFE) - A is bit 0
	ld	bc,0xFDFE
	in	a, (c)
	bit	0, a
	jr	nz, _no_a
	set	2, l
_no_a:
;	Read POIUY row (port 0xDFFE) - P is bit 0, O is bit 1
	ld	bc,0xDFFE
	in	a, (c)
	bit	0, a
	jr	nz, _no_p
	set	0, l
_no_p:
	bit	1, a
	jr	nz, _no_o
	set	1, l
_no_o:
	ret
;	---------------------------------
; Function floating_bus_wait
; ---------------------------------
_floating_bus_wait:
	ld	b,0x09
	ld	c,0x80
_fb_wt:
	in	a, (0xFF)
	cp	b
	jr	z, _fb_ok
	dec	c
	jr	nz, _fb_wt
	ld	l,0x00
	jr	_fb_dn
_fb_ok:
	ld	l,0x01
_fb_dn:
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
	SECTION code_compiler
;	---------------------------------
; Function clear_viewport_attrs
; ---------------------------------
_clear_viewport_attrs:
	ld	b,0xc0
	ld	hl,0x58c0
l_clear_viewport_attrs_00103:
	ld	(hl),0x07
	inc	hl
	ld	(hl),0x07
	inc	hl
	djnz	l_clear_viewport_attrs_00103
	ret
;	---------------------------------
; Function draw_scanline
; ---------------------------------
_draw_scanline:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	c,0x00
l_draw_scanline_00102:
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	b,0x00
	add	hl, bc
	ld	l, (hl)
	ld	a,(ix+4)
	add	a, c
	ld	e, a
	ld	a,(ix+5)
	adc	a,0x00
	ld	d, a
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a,(ix+8)
	ld	b,0x00
	add	a, l
	ld	l, a
	ld	a, b
	adc	a, h
	ld	b, a
	ld	a, +((_tiles) & 0xFF)
	add	a, l
	ld	l, a
	ld	a, +((_tiles) / 256)
	adc	a, b
	ld	h, a
	ld	a, (hl)
	ld	(de), a
	inc	c
	ld	a, c
	sub	a,0x20
	jr	C,l_draw_scanline_00102
	pop	ix
	ret
;	---------------------------------
; Function draw_initial_tilemap
; ---------------------------------
_draw_initial_tilemap:
	ld	bc,_offscreen_buffer_32x16+0
	ld	de,_map_data+0
	ld	hl,0x0000
l_draw_initial_tilemap_00104:
	push	hl
	push	bc
	push	de
	push	hl
	inc	sp
	push	de
	push	bc
	call	_draw_scanline
	pop	af
	pop	af
	inc	sp
	pop	de
	pop	bc
	pop	hl
	ld	a, c
	add	a,0x20
	ld	c, a
	jr	NC,l_draw_initial_tilemap_00123
	inc	b
l_draw_initial_tilemap_00123:
	inc	h
	ld	a, h
	sub	a,0x08
	jr	NZ,l_draw_initial_tilemap_00105
	ld	h,a
	ld	a, e
	add	a,0x60
	ld	e, a
	jr	NC,l_draw_initial_tilemap_00126
	inc	d
l_draw_initial_tilemap_00126:
l_draw_initial_tilemap_00105:
	inc	l
	ld	a, l
	sub	a,0x60
	jr	C,l_draw_initial_tilemap_00104
	ret
;	---------------------------------
; Function main
; ---------------------------------
_main:
	push	ix
	ld	ix,0
	add	ix,sp
	push	af
	dec	sp
	ld	l,0x00
	call	_zx_border_fastcall
	ld	hl,_hud_scr
	push	hl
	call	_load_scr_to_screen
	pop	af
	call	_clear_viewport_attrs
	call	_draw_initial_tilemap
	ld	hl,0x5ae0
	ld	(hl),0x09
	ld	(ix-3),0x01
l_main_00111:
	ld	(ix-2),0x00
	call	_read_keys
	ld	(ix-1),l
	ld	a,(ix-3)
	or	a, a
	jr	NZ,l_main_00102
	ld	a,(ix-1)
	or	a, a
	jr	NZ,l_main_00102
	halt
	jr	l_main_00111
l_main_00102:
	ld	a,(ix-1)
	or	a, a
	jr	Z,l_main_00105
	ld	a,0x03
	push	af
	inc	sp
	ld	hl,0x0030
	push	hl
	ld	l,0x60
	push	hl
	ld	hl,_camera_y
	push	hl
	ld	hl,_camera_x
	push	hl
	ld	hl,_head_row
	push	hl
	ld	hl,_offscreen_buffer_32x16
	push	hl
	ld	hl,_tiles
	push	hl
	ld	hl,_map_data
	push	hl
	ld	a,(ix-1)
	push	af
	inc	sp
	call	_dirty_edge_scroll
	ld	hl,18
	add	hl, sp
	ld	sp, hl
	ld	(ix-3),0x01
l_main_00105:
	ld	a,(ix-3)
	or	a, a
	jr	Z,l_main_00107
	call	_floating_bus_wait
	ld	(ix-2),l
	ld	a, (_head_row)
	push	af
	inc	sp
	ld	hl,_offscreen_buffer_32x16
	push	hl
	call	_copy_viewport_32x16_to_screen_ring
	pop	af
	inc	sp
	ld	(ix-3),0x00
l_main_00107:
	ld	a,(ix-2)
	or	a, a
	jr	NZ,l_main_00111
	halt
	jp	l_main_00111
	SECTION data_compiler
_camera_x:
	DEFW +0x0000
_camera_y:
	DEFW +0x0000
_head_row:
	DEFB +0x00
	SECTION IGNORE
