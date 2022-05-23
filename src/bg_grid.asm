	MAC BG_GRID_CHOOSE_COLOR
	;; Choose colors according to bit 5 of Y register
	txa
	and #$20
	beq .even
.odd:
	lda #GRID_BG_COL
	sta COLUBK
	lda #GRID_PF_COL
	sta COLUPF
	bne .color_chosen	; unconditional jump
.even:
	lda #GRID_PF_COL
	sta COLUBK
	lda #GRID_BG_COL
	sta COLUPF
.color_chosen:
	ENDM

bg_grid_init:	SUBROUTINE
	;; Playfield setup
	lda #$0
	sta CTRLPF
	lda #$f0
	sta PF0
	lda #$83
	sta PF1
	lda #$07
	sta PF2
;;; Empty functions
bg_grid_vblank:
bg_grid_overscan:
	rts

bg_grid_top_bottom_loop:	SUBROUTINE
	ldy #55
.loop:
	sta WSYNC
	BG_GRID_CHOOSE_COLOR
	lda #$00
	sta GRP0
	sta GRP1
	inx
	dey
	bpl .loop
	rts

bg_grid_kernel:	SUBROUTINE
	ldx framecnt
	jsr bg_grid_top_bottom_loop

	ldy #15
.loop_middle_ext:
	lda #7
	sta ptr
.loop_middle_int:
	sta WSYNC
	BG_GRID_CHOOSE_COLOR
	lda (sprite_a_ptr),Y
	sta GRP0
	lda (sprite_b_ptr),Y
	sta GRP1
	inx
	dec ptr
	bpl .loop_middle_int
	dey
	bpl .loop_middle_ext

	jsr bg_grid_top_bottom_loop
	sta WSYNC
	lda #$00
	sta COLUBK
	sta COLUPF
	rts
