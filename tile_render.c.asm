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
;tile_render.c:22: static unsigned char read_input(void) {
;	---------------------------------
; Function read_input
; ---------------------------------
_read_input:
;tile_render.c:23: unsigned char dir = 0;
	ld	c,0x00
;tile_render.c:26: if (in_key_pressed(IN_KEY_SCANCODE_q)) dir |= 0x08;  // up
	ld	hl,0x01fb
	call	_in_key_pressed_fastcall
	ld	a, h
	or	a, l
	jr	Z,l_read_input_00102
	ld	c,0x08
l_read_input_00102:
;tile_render.c:27: if (in_key_pressed(IN_KEY_SCANCODE_a)) dir |= 0x04;  // down
	ld	hl,0x01fd
	call	_in_key_pressed_fastcall
	ld	a, h
	or	a, l
	jr	Z,l_read_input_00104
	set	2, c
l_read_input_00104:
;tile_render.c:28: if (in_key_pressed(IN_KEY_SCANCODE_o)) dir |= 0x02;  // left
	ld	hl,0x02df
	call	_in_key_pressed_fastcall
	ld	a, h
	or	a, l
	jr	Z,l_read_input_00106
	set	1, c
l_read_input_00106:
;tile_render.c:29: if (in_key_pressed(IN_KEY_SCANCODE_p)) dir |= 0x01;  // right
	ld	hl,0x01df
	call	_in_key_pressed_fastcall
	ld	a, h
	or	a, l
	jr	Z,l_read_input_00108
	set	0, c
l_read_input_00108:
;tile_render.c:31: if (dir) return dir;
	ld	a, c
	or	a, a
	jr	Z,l_read_input_00110
	ld	l, c
	jr	l_read_input_00119
l_read_input_00110:
;tile_render.c:35: uint16_t joy = in_stick_kempston();
	call	_in_stick_kempston
;tile_render.c:36: if (joy & IN_STICK_UP)    dir |= 0x08;
	bit	0, l
	jr	Z,l_read_input_00112
	set	3, c
l_read_input_00112:
;tile_render.c:37: if (joy & IN_STICK_DOWN)  dir |= 0x04;
	bit	1, l
	jr	Z,l_read_input_00114
	set	2, c
l_read_input_00114:
;tile_render.c:38: if (joy & IN_STICK_LEFT)  dir |= 0x02;
	bit	2, l
	jr	Z,l_read_input_00116
	set	1, c
l_read_input_00116:
;tile_render.c:39: if (joy & IN_STICK_RIGHT) dir |= 0x01;
	bit	3, l
	jr	Z,l_read_input_00118
	set	0, c
l_read_input_00118:
;tile_render.c:42: return dir;
	ld	l, c
l_read_input_00119:
;tile_render.c:43: }
	ret
	SECTION code_compiler
;tile_render.c:47: static unsigned char update_camera(unsigned char input) {
;	---------------------------------
; Function update_camera
; ---------------------------------
_update_camera:
	push	ix
	ld	ix,0
	add	ix,sp
;tile_render.c:51: prev_tile_x = camera_tile_x;
	ld	hl,(_camera_tile_x)
	ld	(_prev_tile_x),hl
;tile_render.c:52: prev_tile_y = camera_tile_y;
	ld	hl,(_camera_tile_y)
	ld	(_prev_tile_y),hl
;tile_render.c:54: if ((input & 0x01) && camera_tile_x < max_x) camera_tile_x++;  // right
	ld	c,(ix+4)
	bit	0, c
	jr	Z,l_update_camera_00102
	ld	hl,_camera_tile_x
	ld	a, (hl)
	sub	a,0x4c
	inc	hl
	ld	a, (hl)
	rla
	ccf
	rra
	sbc	a,0x80
	jr	NC,l_update_camera_00102
	ld	hl, (_camera_tile_x)
	inc	hl
	ld	(_camera_tile_x), hl
l_update_camera_00102:
;tile_render.c:55: if ((input & 0x02) && camera_tile_x > 0)      camera_tile_x--;  // left
	bit	1, c
	jr	Z,l_update_camera_00105
	xor	a, a
	ld	hl,_camera_tile_x
	cp	a, (hl)
	inc	hl
	sbc	a, (hl)
	jp	PO, l_update_camera_00190
	xor	a,0x80
l_update_camera_00190:
	jp	P, l_update_camera_00105
	ld	hl,(_camera_tile_x)
	ld	de,0xffff
	add	hl,de
	ld	(_camera_tile_x),hl
l_update_camera_00105:
;tile_render.c:56: if ((input & 0x04) && camera_tile_y < max_y)  camera_tile_y++;  // down
	bit	2, c
	jr	Z,l_update_camera_00108
	ld	hl,_camera_tile_y
	ld	a, (hl)
	sub	a,0x20
	inc	hl
	ld	a, (hl)
	rla
	ccf
	rra
	sbc	a,0x80
	jr	NC,l_update_camera_00108
	ld	hl, (_camera_tile_y)
	inc	hl
	ld	(_camera_tile_y), hl
l_update_camera_00108:
;tile_render.c:57: if ((input & 0x08) && camera_tile_y > 0)       camera_tile_y--;  // up
	bit	3, c
	jr	Z,l_update_camera_00111
	xor	a, a
	ld	hl,_camera_tile_y
	cp	a, (hl)
	inc	hl
	sbc	a, (hl)
	jp	PO, l_update_camera_00193
	xor	a,0x80
l_update_camera_00193:
	jp	P, l_update_camera_00111
	ld	hl,(_camera_tile_y)
	ld	de,0xffff
	add	hl,de
	ld	(_camera_tile_y),hl
l_update_camera_00111:
;tile_render.c:59: return (camera_tile_x != prev_tile_x) || (camera_tile_y != prev_tile_y);
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
;tile_render.c:60: }
	pop	ix
	ret
;tile_render.c:67: static void scroll_right(void) {
;	---------------------------------
; Function scroll_right
; ---------------------------------
_scroll_right:
;tile_render.c:68: shift_viewport_left();
	call	_shift_viewport_left
;tile_render.c:71: &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x + VIEWPORT_COLS - 1]);
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
	ex	de, hl
	ld	hl,(_camera_tile_x)
	add	hl,de
	ld	de,0x0013
	add	hl, de
	add	hl, bc
;tile_render.c:70: VIEWPORT_COL_OFFSET + VIEWPORT_COLS - 1,
	push	hl
	ld	a,0x19
	push	af
	inc	sp
	call	_render_dirty_column
	pop	af
	inc	sp
;tile_render.c:72: }
	ret
;tile_render.c:74: static void scroll_left(void) {
;	---------------------------------
; Function scroll_left
; ---------------------------------
_scroll_left:
;tile_render.c:75: shift_viewport_right();
	call	_shift_viewport_right
;tile_render.c:78: &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x]);
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
;tile_render.c:77: VIEWPORT_COL_OFFSET,
	push	hl
	ld	a,0x06
	push	af
	inc	sp
	call	_render_dirty_column
	pop	af
	inc	sp
;tile_render.c:79: }
	ret
;tile_render.c:81: static void scroll_down(void) {
;	---------------------------------
; Function scroll_down
; ---------------------------------
_scroll_down:
;tile_render.c:82: shift_viewport_up();
	call	_shift_viewport_up
;tile_render.c:85: &map_data[(camera_tile_y + VIEWPORT_CHAR_ROWS - 1) * MAP_WIDTH + camera_tile_x]);
	ld	hl,(_camera_tile_y)
	ld	bc,0x000f
	add	hl,bc
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
;tile_render.c:84: VIEWPORT_CHAR_ROWS - 1,
	push	hl
	ld	a,0x0f
	push	af
	inc	sp
	call	_render_dirty_row
	pop	af
	inc	sp
;tile_render.c:86: }
	ret
;tile_render.c:88: static void scroll_up(void) {
;	---------------------------------
; Function scroll_up
; ---------------------------------
_scroll_up:
;tile_render.c:89: shift_viewport_down();
	call	_shift_viewport_down
;tile_render.c:92: &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x]);
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
;tile_render.c:91: 0,
	push	hl
	xor	a, a
	push	af
	inc	sp
	call	_render_dirty_row
	pop	af
	inc	sp
;tile_render.c:93: }
	ret
;tile_render.c:95: static void redraw_viewport(void) {
;	---------------------------------
; Function redraw_viewport
; ---------------------------------
_redraw_viewport:
;tile_render.c:96: render_full_viewport(&map_data[camera_tile_y * MAP_WIDTH + camera_tile_x]);
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
;tile_render.c:97: }
	ret
;tile_render.c:100: void clear_viewport_attrs(void) {
;	---------------------------------
; Function clear_viewport_attrs
; ---------------------------------
_clear_viewport_attrs:
;tile_render.c:102: for (row = 0; row < VIEWPORT_CHAR_ROWS; row++) {
	ld	c,0x00
l_clear_viewport_attrs_00102:
;tile_render.c:103: unsigned char *attr = (unsigned char *)(0x5800
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
;tile_render.c:106: memset(attr, PAPER_BLACK | INK_WHITE, VIEWPORT_COLS);
	ld	b,0x0a
l_clear_viewport_attrs_00114:
	ld	(hl),0x07
	inc	hl
	ld	(hl),0x07
	inc	hl
	djnz	l_clear_viewport_attrs_00114
;tile_render.c:102: for (row = 0; row < VIEWPORT_CHAR_ROWS; row++) {
	inc	c
	ld	a, c
	sub	a,0x10
	jr	C,l_clear_viewport_attrs_00102
;tile_render.c:108: }
	ret
;tile_render.c:110: void load_scr_to_screen(const unsigned char *scr) {
;	---------------------------------
; Function load_scr_to_screen
; ---------------------------------
_load_scr_to_screen:
	push	ix
	ld	ix,0
	add	ix,sp
;tile_render.c:113: __endasm;
	di
;tile_render.c:114: memcpy((void *)0x4000, scr, 6912);
	ld	l,(ix+4)
	ld	h,(ix+5)
	ld	de,0x4000
	ld	bc,0x1b00
	ldir
;tile_render.c:117: __endasm;
	ei
;tile_render.c:118: }
	pop	ix
	ret
;tile_render.c:120: void tile_render_main(void) {
;	---------------------------------
; Function tile_render_main
; ---------------------------------
_tile_render_main:
;tile_render.c:124: load_scr_to_screen(hud_scr);
	ld	hl,_hud_scr
	push	hl
	call	_load_scr_to_screen
	pop	af
;tile_render.c:125: clear_viewport_attrs();
	call	_clear_viewport_attrs
;tile_render.c:128: map_start = &map_data[camera_tile_y * MAP_WIDTH + camera_tile_x];
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
;tile_render.c:129: render_full_viewport(map_start);
	push	hl
	call	_render_full_viewport
	pop	af
;tile_render.c:132: frame_count = 0;
	xor	a, a
	ld	(_frame_count),a
;tile_render.c:133: while (1) {
l_tile_render_main_00121:
;tile_render.c:137: intrinsic_halt();
	halt
;tile_render.c:139: input = read_input();
	call	_read_input
	ld	b, l
;tile_render.c:141: frame_count++;
	ld	hl,_frame_count
;tile_render.c:142: if (frame_count < SCROLL_INTERVAL) continue;
	ld	a,(hl)
	inc	a
	ld	(hl),a
	sub	a,0x03
	jr	C,l_tile_render_main_00121
;tile_render.c:143: if (input == 0) { frame_count = SCROLL_INTERVAL - 1; continue; }
	ld	a, b
	or	a, a
	jr	NZ,l_tile_render_main_00104
	ld	(hl),0x02
	jr	l_tile_render_main_00121
l_tile_render_main_00104:
;tile_render.c:144: frame_count = 0;
	xor	a, a
	ld	(_frame_count),a
;tile_render.c:146: moved = update_camera(input);
	push	bc
	inc	sp
	call	_update_camera
	inc	sp
;tile_render.c:147: if (moved) {
	ld	a, l
	or	a, a
	jr	Z,l_tile_render_main_00121
;tile_render.c:148: int dx = camera_tile_x - prev_tile_x;
	ld	hl,(_camera_tile_x)
	ld	bc,(_prev_tile_x)
	xor	a,a
	sbc	hl,bc
	ld	c,l
	ld	b,h
;tile_render.c:149: int dy = camera_tile_y - prev_tile_y;
	ld	hl,(_camera_tile_y)
	ld	de,(_prev_tile_y)
	xor	a,a
	sbc	hl,de
;tile_render.c:151: if (dx && dy) {
	ld	a,b
	ex	de,hl
	or	a,c
	jr	Z,l_tile_render_main_00115
	ld	a, d
	or	a, e
	jr	Z,l_tile_render_main_00115
;tile_render.c:153: redraw_viewport();
	call	_redraw_viewport
	jr	l_tile_render_main_00121
l_tile_render_main_00115:
;tile_render.c:154: } else if (dx > 0) {
	xor	a, a
	cp	a, c
	sbc	a, b
	jp	PO, l_tile_render_main_00188
	xor	a,0x80
l_tile_render_main_00188:
	jp	P, l_tile_render_main_00112
;tile_render.c:155: scroll_right();
	call	_scroll_right
	jr	l_tile_render_main_00121
l_tile_render_main_00112:
;tile_render.c:156: } else if (dx < 0) {
	bit	7, b
	jr	Z,l_tile_render_main_00109
;tile_render.c:157: scroll_left();
	call	_scroll_left
	jr	l_tile_render_main_00121
l_tile_render_main_00109:
;tile_render.c:158: } else if (dy > 0) {
	xor	a, a
	cp	a, e
	sbc	a, d
	jp	PO, l_tile_render_main_00189
	xor	a,0x80
l_tile_render_main_00189:
	jp	P, l_tile_render_main_00106
;tile_render.c:159: scroll_down();
	call	_scroll_down
	jr	l_tile_render_main_00121
l_tile_render_main_00106:
;tile_render.c:161: scroll_up();
	call	_scroll_up
;tile_render.c:165: }
	jr	l_tile_render_main_00121
	SECTION data_compiler
_camera_tile_x:
	DEFW +0x0000
_camera_tile_y:
	DEFW +0x0000
_prev_tile_x:
	DEFW +0x0000
_prev_tile_y:
	DEFW +0x0000
_frame_count:
	DEFB +0x00
	SECTION IGNORE
