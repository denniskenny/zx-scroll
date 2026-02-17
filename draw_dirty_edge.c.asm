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
	GLOBAL _dirty_edge_init
	GLOBAL _dirty_edge_full_redraw
	GLOBAL _dirty_edge_scroll
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
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
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION bss_compiler
;--------------------------------------------------------
; ram data
;--------------------------------------------------------

IF 0

; .area _INITIALIZED removed by z88dk


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
; Function dirty_edge_init is a stub
; ---------------------------------
EXTERN l_ret
defc _dirty_edge_init = l_ret
;	---------------------------------
; Function dirty_edge_full_redraw
; ---------------------------------
_dirty_edge_full_redraw:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	l,(ix+8)
	ld	h,(ix+9)
	ld	(hl),0x00
	ld	e, l
	ld	d, h
	inc	de
	ld	bc,0x0bff
	ldir
	pop	ix
	ret
;	---------------------------------
; Function dirty_edge_scroll
; ---------------------------------
_dirty_edge_scroll:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl, -16
	add	hl, sp
	ld	sp, hl
	ld	l,(ix+13)
	ld	h,(ix+14)
	ld	a, (hl)
	ld	(ix-5),a
	inc	hl
	ld	a, (hl)
	ld	(ix-4),a
	ld	a,(ix+15)
	ld	(ix-15),a
	ld	l, a
	ld	a,(ix+16)
	ld	(ix-14),a
	ld	h,a
	ld	a, (hl)
	ld	(ix-3),a
	inc	hl
	ld	a, (hl)
	ld	(ix-2),a
	ld	a,(ix+11)
	ld	(ix-13),a
	ld	l, a
	ld	a,(ix+12)
	ld	(ix-12),a
	ld	h,a
	ld	a, (hl)
	ld	(ix-16),a
	ld	a,(ix+21)
	or	a, a
	jr	NZ,l_dirty_edge_scroll_00149
	ld	(ix+21),0x01
l_dirty_edge_scroll_00149:
	ld	a,(ix+17)
	ld	(ix-7),a
	ld	a,(ix+18)
	ld	(ix-6),a
	ld	b,0x03
l_dirty_edge_scroll_00248:
	sla	(ix-7)
	rl	(ix-6)
	djnz	l_dirty_edge_scroll_00248
	ld	a,(ix-7)
	or	a,a
	ld	(ix-11),a
	ld	a,(ix-6)
	adc	a,0xff
	ld	(ix-10),a
	ld	a,(ix+19)
	ld	(ix-7),a
	ld	a,(ix+20)
	ld	(ix-6),a
	ld	b,0x03
l_dirty_edge_scroll_00249:
	sla	(ix-7)
	rl	(ix-6)
	djnz	l_dirty_edge_scroll_00249
	ld	a,(ix-7)
	add	a,0xa0
	ld	(ix-9),a
	ld	a,(ix-6)
	adc	a,0xff
	ld	(ix-8),a
	ld	(ix-1),0x00
l_dirty_edge_scroll_00131:
	ld	a,(ix-1)
	sub	a,(ix+21)
	jp	NC, l_dirty_edge_scroll_00127
	ld	c,(ix+4)
	ld	a, c
	and	a,0x01
	ld	b,a
	or	a, a
	jr	Z,l_dirty_edge_scroll_00106
	ld	a,(ix-5)
	sub	a,(ix-11)
	ld	a,(ix-4)
	sbc	a,(ix-10)
	jp	PO, l_dirty_edge_scroll_00250
	xor	a,0x80
l_dirty_edge_scroll_00250:
	jp	P, l_dirty_edge_scroll_00127
	inc	(ix-5)
	jr	NZ,l_dirty_edge_scroll_00251
	inc	(ix-4)
l_dirty_edge_scroll_00251:
l_dirty_edge_scroll_00106:
	ld	a, c
	and	a,0x02
	ld	(ix-7),a
	or	a, a
	jr	Z,l_dirty_edge_scroll_00110
	xor	a, a
	cp	a,(ix-5)
	sbc	a,(ix-4)
	jp	PO, l_dirty_edge_scroll_00252
	xor	a,0x80
l_dirty_edge_scroll_00252:
	jp	P, l_dirty_edge_scroll_00127
	ld	l,(ix-5)
	ld	h,(ix-4)
	dec	hl
	ld	(ix-5),l
	ld	(ix-4),h
l_dirty_edge_scroll_00110:
	ld	a, c
	and	a,0x04
	ld	(ix-6),a
	or	a, a
	jr	Z,l_dirty_edge_scroll_00114
	ld	a,(ix-3)
	sub	a,(ix-9)
	ld	a,(ix-2)
	sbc	a,(ix-8)
	jp	PO, l_dirty_edge_scroll_00253
	xor	a,0x80
l_dirty_edge_scroll_00253:
	jp	P, l_dirty_edge_scroll_00127
	inc	(ix-3)
	jr	NZ,l_dirty_edge_scroll_00254
	inc	(ix-2)
l_dirty_edge_scroll_00254:
l_dirty_edge_scroll_00114:
	ld	a, c
	and	a,0x08
	ld	c,a
	or	a, a
	jr	Z,l_dirty_edge_scroll_00118
	xor	a, a
	cp	a,(ix-3)
	sbc	a,(ix-2)
	jp	PO, l_dirty_edge_scroll_00255
	xor	a,0x80
l_dirty_edge_scroll_00255:
	jp	P, l_dirty_edge_scroll_00127
	ld	l,(ix-3)
	ld	h,(ix-2)
	dec	hl
	ld	(ix-3),l
	ld	(ix-2),h
l_dirty_edge_scroll_00118:
	ld	a, b
	or	a, a
	jr	Z,l_dirty_edge_scroll_00120
	push	bc
	ld	l,(ix+17)
	ld	h,(ix+18)
	push	hl
	ld	l,(ix-3)
	ld	h,(ix-2)
	push	hl
	ld	l,(ix-5)
	ld	h,(ix-4)
	push	hl
	ld	l,(ix+7)
	ld	h,(ix+8)
	push	hl
	ld	l,(ix+5)
	ld	h,(ix+6)
	push	hl
	ld	a,(ix-16)
	push	af
	inc	sp
	ld	l,(ix+9)
	ld	h,(ix+10)
	push	hl
	call	_scroll_x_plus_ring
	ld	hl,13
	add	hl, sp
	ld	sp, hl
	pop	bc
l_dirty_edge_scroll_00120:
	ld	a,(ix-7)
	or	a, a
	jr	Z,l_dirty_edge_scroll_00122
	push	bc
	ld	l,(ix+17)
	ld	h,(ix+18)
	push	hl
	ld	l,(ix-3)
	ld	h,(ix-2)
	push	hl
	ld	l,(ix-5)
	ld	h,(ix-4)
	push	hl
	ld	l,(ix+7)
	ld	h,(ix+8)
	push	hl
	ld	l,(ix+5)
	ld	h,(ix+6)
	push	hl
	ld	a,(ix-16)
	push	af
	inc	sp
	ld	l,(ix+9)
	ld	h,(ix+10)
	push	hl
	call	_scroll_x_minus_ring
	ld	hl,13
	add	hl, sp
	ld	sp, hl
	pop	bc
l_dirty_edge_scroll_00122:
	ld	a,(ix-6)
	or	a, a
	jr	Z,l_dirty_edge_scroll_00124
	push	bc
	ld	l,(ix+17)
	ld	h,(ix+18)
	push	hl
	ld	l,(ix-3)
	ld	h,(ix-2)
	push	hl
	ld	l,(ix-5)
	ld	h,(ix-4)
	push	hl
	ld	l,(ix+7)
	ld	h,(ix+8)
	push	hl
	ld	l,(ix+5)
	ld	h,(ix+6)
	push	hl
	ld	hl,12
	add	hl, sp
	push	hl
	ld	l,(ix+9)
	ld	h,(ix+10)
	push	hl
	call	_scroll_y_plus_ring
	ld	hl,14
	add	hl, sp
	ld	sp, hl
	pop	bc
l_dirty_edge_scroll_00124:
	ld	a, c
	or	a, a
	jr	Z,l_dirty_edge_scroll_00132
	ld	l,(ix+17)
	ld	h,(ix+18)
	push	hl
	ld	l,(ix-3)
	ld	h,(ix-2)
	push	hl
	ld	l,(ix-5)
	ld	h,(ix-4)
	push	hl
	ld	l,(ix+7)
	ld	h,(ix+8)
	push	hl
	ld	l,(ix+5)
	ld	h,(ix+6)
	push	hl
	ld	hl,10
	add	hl, sp
	push	hl
	ld	l,(ix+9)
	ld	h,(ix+10)
	push	hl
	call	_scroll_y_minus_ring
	ld	hl,14
	add	hl, sp
	ld	sp, hl
l_dirty_edge_scroll_00132:
	inc	(ix-1)
	jp	l_dirty_edge_scroll_00131
l_dirty_edge_scroll_00127:
	ld	a,(ix-1)
	or	a,a
	jr	NZ,l_dirty_edge_scroll_00129
	ld	l,a
	jr	l_dirty_edge_scroll_00133
l_dirty_edge_scroll_00129:
	ld	l,(ix+13)
	ld	h,(ix+14)
	ld	a,(ix-5)
	ld	(hl), a
	inc	hl
	ld	a,(ix-4)
	ld	(hl), a
	ld	l,(ix-15)
	ld	h,(ix-14)
	ld	a,(ix-3)
	ld	(hl), a
	inc	hl
	ld	a,(ix-2)
	ld	(hl), a
	ld	l,(ix-13)
	ld	h,(ix-12)
	ld	a,(ix-16)
	ld	(hl), a
	ld	l,0x01
l_dirty_edge_scroll_00133:
	ld	sp, ix
	pop	ix
	ret
;	---------------------------------
; Function get_tile_pixel
; ---------------------------------
_get_tile_pixel:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	l,(ix+6)
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c,(ix+8)
	ld	b,0x00
	add	hl, bc
	ld	e,(ix+4)
	ld	d,(ix+5)
	add	hl,de
	ld	c, (hl)
	ld	de,_pixel_mask+0
	ld	l,(ix+7)
	ld	h,0x00
	add	hl, de
	ld	a, (hl)
	and	a, c
	ld	l, a
	pop	ix
	ret
	SECTION rodata_compiler
_pixel_mask:
	DEFB +0x80
	DEFB +0x40
	DEFB +0x20
	DEFB +0x10
	DEFB +0x08
	DEFB +0x04
	DEFB +0x02
	DEFB +0x01
	SECTION code_compiler
;	---------------------------------
; Function draw_edge_right_c
; ---------------------------------
_draw_edge_right_c:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl, -6
	add	hl, sp
	ld	sp, hl
	ld	c,(ix+10)
	ld	b,(ix+11)
	dec	bc
	inc	b
	ld	(ix-2),c
	ld	(ix-1),b
	sra	(ix-1)
	rr	(ix-2)
	sra	(ix-1)
	rr	(ix-2)
	sra	(ix-1)
	rr	(ix-2)
	ld	a, c
	and	a,0x07
	ld	(ix-6),a
	ld	h,(ix+13)
	ld	a,(ix+12)
	sra	h
	rra
	sra	h
	rra
	sra	h
	rra
	ld	l,a
	ld	a,(ix+12)
	and	a,0x07
	ld	(ix-3),a
	ld	c,(ix+16)
	ld	e, c
	ld	d,0x00
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	a, e
	add	a,(ix+4)
	ld	b, a
	ld	a, d
	adc	a,(ix+5)
	ld	d, a
	ld	a, b
	add	a,0x1f
	ld	e, a
	jr	NC,l_draw_edge_right_c_00151
	inc	d
l_draw_edge_right_c_00151:
	push	bc
	push	de
	push	hl
	ld	l,(ix+14)
	ld	h,(ix+15)
	ex	(sp), hl
	push	hl
	call	__mulint_callee
	pop	de
	pop	bc
	ld	a, l
	add	a,(ix-2)
	ld	(ix-5),a
	ld	a, h
	adc	a,(ix-1)
	ld	(ix-4),a
	ld	a,(ix+6)
	add	a,(ix-5)
	ld	(ix-2),a
	ld	a,(ix+7)
	adc	a,(ix-4)
	ld	(ix-1),a
	ld	a,(ix+4)
	add	a,0x1f
	ld	(ix-5),a
	ld	a,(ix+5)
	adc	a,0x00
	ld	(ix-4),a
	ld	b,0x00
l_draw_edge_right_c_00111:
	ld	a, b
	sub	a,0x60
	jr	NC,l_draw_edge_right_c_00113
	ld	l,(ix-2)
	ld	h,(ix-1)
	ld	a, (hl)
	push	bc
	push	de
	ld	h,(ix-3)
	push	hl
	inc	sp
	ld	h,(ix-6)
	ld	l,a
	push	hl
	ld	l,(ix+8)
	ld	h,(ix+9)
	push	hl
	call	_get_tile_pixel
	pop	af
	pop	af
	inc	sp
	pop	de
	pop	bc
	ld	a, (de)
	inc	l
	dec	l
	jr	Z,l_draw_edge_right_c_00102
	or	a,0x01
	ld	(de), a
	jr	l_draw_edge_right_c_00103
l_draw_edge_right_c_00102:
	and	a,0xfe
	ld	(de), a
l_draw_edge_right_c_00103:
	inc	(ix-3)
	ld	a,(ix-3)
	sub	a,0x08
	jr	NZ,l_draw_edge_right_c_00105
	ld	(ix-3),0x00
	ld	a,(ix-2)
	add	a,(ix+14)
	ld	(ix-2),a
	ld	a,(ix-1)
	adc	a,(ix+15)
	ld	(ix-1),a
l_draw_edge_right_c_00105:
	inc	c
	ld	a, c
	sub	a,0x60
	jr	NZ,l_draw_edge_right_c_00107
	ld	c,a
	ld	e,(ix-5)
	ld	d,(ix-4)
	jr	l_draw_edge_right_c_00112
l_draw_edge_right_c_00107:
	ld	hl,0x0020
	add	hl, de
	ex	de, hl
l_draw_edge_right_c_00112:
	inc	b
	jr	l_draw_edge_right_c_00111
l_draw_edge_right_c_00113:
	ld	sp, ix
	pop	ix
	ret
;	---------------------------------
; Function draw_edge_left_c
; ---------------------------------
_draw_edge_left_c:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl, -5
	add	hl, sp
	ld	sp, hl
	ld	a,(ix+10)
	ld	(ix-2),a
	ld	a,(ix+11)
	ld	(ix-1),a
	sra	(ix-1)
	rr	(ix-2)
	sra	(ix-1)
	rr	(ix-2)
	sra	(ix-1)
	rr	(ix-2)
	ld	a,(ix+10)
	and	a,0x07
	ld	(ix-5),a
	ld	h,(ix+13)
	ld	a,(ix+12)
	sra	h
	rra
	sra	h
	rra
	sra	h
	rra
	ld	l,a
	ld	a,(ix+12)
	and	a,0x07
	ld	c, a
	ld	e,(ix+16)
	ld	d,0x00
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	a, e
	add	a,(ix+4)
	ld	e, a
	ld	a, d
	adc	a,(ix+5)
	ld	d, a
	push	bc
	push	de
	push	hl
	ld	l,(ix+14)
	ld	h,(ix+15)
	ex	(sp), hl
	push	hl
	call	__mulint_callee
	pop	de
	pop	bc
	ld	a, l
	add	a,(ix-2)
	ld	(ix-4),a
	ld	a, h
	adc	a,(ix-1)
	ld	(ix-3),a
	ld	a,(ix+6)
	add	a,(ix-4)
	ld	(ix-2),a
	ld	a,(ix+7)
	adc	a,(ix-3)
	ld	(ix-1),a
	ld	b,0x60
l_draw_edge_left_c_00109:
	ld	l,(ix-2)
	ld	h,(ix-1)
	ld	a, (hl)
	push	bc
	push	de
	ld	h, c
	push	hl
	inc	sp
	ld	h,(ix-5)
	ld	l,a
	push	hl
	ld	l,(ix+8)
	ld	h,(ix+9)
	push	hl
	call	_get_tile_pixel
	pop	af
	pop	af
	inc	sp
	pop	de
	pop	bc
	ld	a, (de)
	inc	l
	dec	l
	jr	Z,l_draw_edge_left_c_00102
	or	a,0x80
	ld	(de), a
	jr	l_draw_edge_left_c_00103
l_draw_edge_left_c_00102:
	and	a,0x7f
	ld	(de), a
l_draw_edge_left_c_00103:
	inc	c
	ld	a, c
	sub	a,0x08
	jr	NZ,l_draw_edge_left_c_00105
	ld	c,a
	ld	a,(ix-2)
	add	a,(ix+14)
	ld	(ix-2),a
	ld	a,(ix-1)
	adc	a,(ix+15)
	ld	(ix-1),a
l_draw_edge_left_c_00105:
	inc	(ix+16)
	ld	a,(ix+16)
	sub	a,0x60
	jr	NZ,l_draw_edge_left_c_00107
	ld	(ix+16),0x00
	ld	e,(ix+4)
	ld	d,(ix+5)
	jr	l_draw_edge_left_c_00110
l_draw_edge_left_c_00107:
	ld	hl,0x0020
	add	hl, de
	ex	de, hl
l_draw_edge_left_c_00110:
	djnz	l_draw_edge_left_c_00109
	ld	sp, ix
	pop	ix
	ret
;	---------------------------------
; Function draw_edge_bottom_c
; ---------------------------------
_draw_edge_bottom_c:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl, -14
	add	hl, sp
	ld	sp, hl
	ld	a,(ix+12)
	add	a,0x5f
	ld	c, a
	ld	a,(ix+13)
	adc	a,0x00
	ld	l,c
	ld	h,a
	ld	a,l
	sra	h
	rra
	sra	h
	rra
	sra	h
	rra
	ld	l,a
	ld	a, c
	and	a,0x07
	ld	(ix-14),a
	ld	b,(ix+11)
	ld	a,(ix+10)
	sra	b
	rra
	sra	b
	rra
	sra	b
	rra
	ld	c,a
	ld	a,(ix+10)
	and	a,0x07
	ld	(ix-13),a
	ld	a,(ix+16)
	add	a,0x5f
	cp	a,0x60
	jr	C,l_draw_edge_bottom_c_00102
	add	a,0xa0
l_draw_edge_bottom_c_00102:
	ld	d,0x00
	ld	e, a
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	a, e
	add	a,(ix+4)
	ld	(ix-12),a
	ld	a, d
	adc	a,(ix+5)
	ld	(ix-11),a
	push	bc
	ld	e,(ix+14)
	ld	d,(ix+15)
	push	de
	push	hl
	call	__mulint_callee
	pop	bc
	add	hl, bc
	ld	e,(ix+6)
	ld	d,(ix+7)
	add	hl,de
	ld	(ix-10),l
	ld	(ix-9),h
	ld	a,0x08
	sub	a,(ix-13)
	ld	(ix-8),a
	ld	e,0x00
l_draw_edge_bottom_c_00108:
	ld	a, e
	sub	a,0x20
	jp	NC, l_draw_edge_bottom_c_00110
	ld	l,(ix-10)
	ld	h,(ix-9)
	ld	d,0x00
	add	hl, de
	ld	a,(ix-12)
	add	a, e
	ld	(ix-7),a
	ld	a,(ix-11)
	adc	a,0x00
	ld	(ix-6),a
	ld	a,(ix-14)
	ld	(ix-5),a
	ld	(ix-4),0x00
	ld	d, (hl)
	ld	a,(ix-13)
	or	a, a
	jr	NZ,l_draw_edge_bottom_c_00104
	ld	l, d
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a,(ix-5)
	ld	(ix-2),a
	ld	a, h
	adc	a,(ix-4)
	ld	(ix-1),a
	ld	a,(ix+8)
	add	a,(ix-2)
	ld	l, a
	ld	a,(ix+9)
	adc	a,(ix-1)
	ld	h, a
	ld	a, (hl)
	ld	l,(ix-7)
	ld	h,(ix-6)
	ld	(hl), a
	jp	l_draw_edge_bottom_c_00109
l_draw_edge_bottom_c_00104:
	ld	(ix-2),e
	ld	(ix-1),0x00
	ld	l,e
	ld	h,0x00
	add	hl, bc
	inc	hl
	ld	a, l
	sub	a,(ix+14)
	ld	a, h
	sbc	a,(ix+15)
	jp	PO, l_draw_edge_bottom_c_00150
	xor	a,0x80
l_draw_edge_bottom_c_00150:
	jp	P, l_draw_edge_bottom_c_00112
	ld	l,(ix-2)
	ld	h,0x00
	inc	hl
	ld	a, l
	add	a,(ix-10)
	ld	l, a
	ld	a, h
	adc	a,(ix-9)
	ld	h, a
	ld	a, (hl)
	jr	l_draw_edge_bottom_c_00113
l_draw_edge_bottom_c_00112:
	ld	a, d
l_draw_edge_bottom_c_00113:
	ld	(ix-3),a
	ld	h,0x00
	ld	l, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a,(ix-5)
	ld	(ix-2),a
	ld	a, h
	adc	a,(ix-4)
	ld	(ix-1),a
	ld	a,(ix-2)
	add	a,(ix+8)
	ld	l, a
	ld	a,(ix-1)
	adc	a,(ix+9)
	ld	h, a
	ld	d, (hl)
	ld	l,(ix-3)
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a,(ix-5)
	ld	(ix-2),a
	ld	a, h
	adc	a,(ix-4)
	ld	(ix-1),a
	ld	a,(ix-2)
	add	a,(ix+8)
	ld	l, a
	ld	a,(ix-1)
	adc	a,(ix+9)
	ld	h, a
	ld	l, (hl)
	ld	a,(ix-13)
	inc	a
	jr	l_draw_edge_bottom_c_00152
l_draw_edge_bottom_c_00151:
	sla	d
l_draw_edge_bottom_c_00152:
	dec	a
	jr	NZ,l_draw_edge_bottom_c_00151
	ld	a,(ix-8)
l_draw_edge_bottom_c_00153:
	srl	l
	dec	a
	jr	NZ, l_draw_edge_bottom_c_00153
	ld	a, d
	or	a, l
	ld	l,(ix-7)
	ld	h,(ix-6)
	ld	(hl), a
l_draw_edge_bottom_c_00109:
	inc	e
	jp	l_draw_edge_bottom_c_00108
l_draw_edge_bottom_c_00110:
	ld	sp, ix
	pop	ix
	ret
;	---------------------------------
; Function draw_edge_top_c
; ---------------------------------
_draw_edge_top_c:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl, -14
	add	hl, sp
	ld	sp, hl
	ld	h,(ix+13)
	ld	a,(ix+12)
	sra	h
	rra
	sra	h
	rra
	sra	h
	rra
	ld	l,a
	ld	a,(ix+12)
	and	a,0x07
	ld	(ix-14),a
	ld	b,(ix+11)
	ld	a,(ix+10)
	sra	b
	rra
	sra	b
	rra
	sra	b
	rra
	ld	c,a
	ld	a,(ix+10)
	and	a,0x07
	ld	(ix-13),a
	ld	e,(ix+16)
	ld	d,0x00
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	a, e
	add	a,(ix+4)
	ld	(ix-12),a
	ld	a, d
	adc	a,(ix+5)
	ld	(ix-11),a
	push	bc
	ld	e,(ix+14)
	ld	d,(ix+15)
	push	de
	push	hl
	call	__mulint_callee
	pop	bc
	add	hl, bc
	ld	e,(ix+6)
	ld	d,(ix+7)
	add	hl,de
	ld	(ix-10),l
	ld	(ix-9),h
	ld	a,0x08
	sub	a,(ix-13)
	ld	(ix-8),a
	ld	e,0x00
l_draw_edge_top_c_00106:
	ld	a, e
	sub	a,0x20
	jp	NC, l_draw_edge_top_c_00108
	ld	l,(ix-10)
	ld	h,(ix-9)
	ld	d,0x00
	add	hl, de
	ld	a,(ix-12)
	add	a, e
	ld	(ix-7),a
	ld	a,(ix-11)
	adc	a,0x00
	ld	(ix-6),a
	ld	a,(ix-14)
	ld	(ix-5),a
	ld	(ix-4),0x00
	ld	d, (hl)
	ld	a,(ix-13)
	or	a, a
	jr	NZ,l_draw_edge_top_c_00102
	ld	l, d
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a,(ix-5)
	ld	(ix-2),a
	ld	a, h
	adc	a,(ix-4)
	ld	(ix-1),a
	ld	a,(ix+8)
	add	a,(ix-2)
	ld	l, a
	ld	a,(ix+9)
	adc	a,(ix-1)
	ld	h, a
	ld	a, (hl)
	ld	l,(ix-7)
	ld	h,(ix-6)
	ld	(hl), a
	jp	l_draw_edge_top_c_00107
l_draw_edge_top_c_00102:
	ld	(ix-2),e
	ld	(ix-1),0x00
	ld	l,e
	ld	h,0x00
	add	hl, bc
	inc	hl
	ld	a, l
	sub	a,(ix+14)
	ld	a, h
	sbc	a,(ix+15)
	jp	PO, l_draw_edge_top_c_00141
	xor	a,0x80
l_draw_edge_top_c_00141:
	jp	P, l_draw_edge_top_c_00110
	ld	l,(ix-2)
	ld	h,0x00
	inc	hl
	ld	a, l
	add	a,(ix-10)
	ld	l, a
	ld	a, h
	adc	a,(ix-9)
	ld	h, a
	ld	a, (hl)
	jr	l_draw_edge_top_c_00111
l_draw_edge_top_c_00110:
	ld	a, d
l_draw_edge_top_c_00111:
	ld	(ix-3),a
	ld	h,0x00
	ld	l, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a,(ix-5)
	ld	(ix-2),a
	ld	a, h
	adc	a,(ix-4)
	ld	(ix-1),a
	ld	a,(ix-2)
	add	a,(ix+8)
	ld	l, a
	ld	a,(ix-1)
	adc	a,(ix+9)
	ld	h, a
	ld	d, (hl)
	ld	l,(ix-3)
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a,(ix-5)
	ld	(ix-2),a
	ld	a, h
	adc	a,(ix-4)
	ld	(ix-1),a
	ld	a,(ix-2)
	add	a,(ix+8)
	ld	l, a
	ld	a,(ix-1)
	adc	a,(ix+9)
	ld	h, a
	ld	l, (hl)
	ld	a,(ix-13)
	inc	a
	jr	l_draw_edge_top_c_00143
l_draw_edge_top_c_00142:
	sla	d
l_draw_edge_top_c_00143:
	dec	a
	jr	NZ,l_draw_edge_top_c_00142
	ld	a,(ix-8)
l_draw_edge_top_c_00144:
	srl	l
	dec	a
	jr	NZ, l_draw_edge_top_c_00144
	ld	a, d
	or	a, l
	ld	l,(ix-7)
	ld	h,(ix-6)
	ld	(hl), a
l_draw_edge_top_c_00107:
	inc	e
	jp	l_draw_edge_top_c_00106
l_draw_edge_top_c_00108:
	ld	sp, ix
	pop	ix
	ret
;	---------------------------------
; Function scroll_x_plus_ring
; ---------------------------------
_scroll_x_plus_ring:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	c,(ix+6)
	ld	a,0x60
	sub	a, c
	ld	e, a
	ld	d,(ix+6)
	ld	a, e
	or	a, a
	jr	Z,l_scroll_x_plus_ring_00102
	ld	l, d
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c,(ix+4)
	ld	b,(ix+5)
	add	hl,bc
	push	de
	ld	a, e
	push	af
	inc	sp
	push	hl
	call	_shift_buffer_left_1px_rows
	pop	af
	inc	sp
	pop	de
l_scroll_x_plus_ring_00102:
	ld	a, d
	or	a, a
	jr	Z,l_scroll_x_plus_ring_00104
	push	de
	push	de
	inc	sp
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	_shift_buffer_left_1px_rows
	pop	af
	inc	sp
	pop	de
l_scroll_x_plus_ring_00104:
	push	de
	inc	sp
	ld	l,(ix+15)
	ld	h,(ix+16)
	push	hl
	ld	l,(ix+13)
	ld	h,(ix+14)
	push	hl
	ld	l,(ix+11)
	ld	h,(ix+12)
	push	hl
	ld	l,(ix+9)
	ld	h,(ix+10)
	push	hl
	ld	l,(ix+7)
	ld	h,(ix+8)
	push	hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	_draw_edge_right_c
	ld	hl,13
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
;	---------------------------------
; Function scroll_x_minus_ring
; ---------------------------------
_scroll_x_minus_ring:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	c,(ix+6)
	ld	a,0x60
	sub	a, c
	ld	e, a
	ld	d,(ix+6)
	ld	a, e
	or	a, a
	jr	Z,l_scroll_x_minus_ring_00102
	ld	l, d
	ld	h,0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c,(ix+4)
	ld	b,(ix+5)
	add	hl,bc
	push	de
	ld	a, e
	push	af
	inc	sp
	push	hl
	call	_shift_buffer_right_1px_rows
	pop	af
	inc	sp
	pop	de
l_scroll_x_minus_ring_00102:
	ld	a, d
	or	a, a
	jr	Z,l_scroll_x_minus_ring_00104
	push	de
	push	de
	inc	sp
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	_shift_buffer_right_1px_rows
	pop	af
	inc	sp
	pop	de
l_scroll_x_minus_ring_00104:
	push	de
	inc	sp
	ld	l,(ix+15)
	ld	h,(ix+16)
	push	hl
	ld	l,(ix+13)
	ld	h,(ix+14)
	push	hl
	ld	l,(ix+11)
	ld	h,(ix+12)
	push	hl
	ld	l,(ix+9)
	ld	h,(ix+10)
	push	hl
	ld	l,(ix+7)
	ld	h,(ix+8)
	push	hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	_draw_edge_left_c
	ld	hl,13
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
;	---------------------------------
; Function scroll_y_plus_ring
; ---------------------------------
_scroll_y_plus_ring:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	a, (hl)
	inc	a
	cp	a,0x60
	jr	NZ,l_scroll_y_plus_ring_00102
	xor	a, a
l_scroll_y_plus_ring_00102:
	ld	(hl), a
	push	af
	inc	sp
	ld	l,(ix+16)
	ld	h,(ix+17)
	push	hl
	ld	l,(ix+14)
	ld	h,(ix+15)
	push	hl
	ld	l,(ix+12)
	ld	h,(ix+13)
	push	hl
	ld	l,(ix+10)
	ld	h,(ix+11)
	push	hl
	ld	l,(ix+8)
	ld	h,(ix+9)
	push	hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	_draw_edge_bottom_c
	ld	hl,13
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
;	---------------------------------
; Function scroll_y_minus_ring
; ---------------------------------
_scroll_y_minus_ring:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	a, (hl)
	or	a, a
	jr	NZ,l_scroll_y_minus_ring_00102
	ld	a,0x60
l_scroll_y_minus_ring_00102:
	dec	a
	ld	(hl), a
	push	af
	inc	sp
	ld	l,(ix+16)
	ld	h,(ix+17)
	push	hl
	ld	l,(ix+14)
	ld	h,(ix+15)
	push	hl
	ld	l,(ix+12)
	ld	h,(ix+13)
	push	hl
	ld	l,(ix+10)
	ld	h,(ix+11)
	push	hl
	ld	l,(ix+8)
	ld	h,(ix+9)
	push	hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	_draw_edge_top_c
	ld	hl,13
	add	hl, sp
	ld	sp, hl
	pop	ix
	ret
	SECTION IGNORE
