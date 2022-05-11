;;; Functions used in main
fx_init:	SUBROUTINE
	lda #$07
	sta NUSIZ0
	sta NUSIZ1
	lda #$00
	sta COLUP0
	lda #$ff
	sta COLUP1
	rts

fx_vblank:	SUBROUTINE
	rts

	MAC CHOOSE_COLOR
	;; Choose colors according to bit 5 of Y register
	tya
	and #$20	
	beq .even
.odd:	
	lda #$8a
	sta COLUBK
	lda #$9a
	sta COLUPF
	bne .color_chosen	; unconditional jump
.even:	
	lda #$9a
	sta COLUBK
	lda #$8a
	sta COLUPF
.color_chosen:
	ENDM
	
fx_kernel:	SUBROUTINE
	lda #$f0
	sta PF0
	lda #$83
	sta PF1
	lda #$07
	sta PF2

	ldy framecnt

	ldx #55
.loop_top:
	sta WSYNC
	CHOOSE_COLOR
	iny
	dex
	bpl .loop_top

	ldx #15
.loop_middle_ext:
	lda #7
	sta tmp
.loop_middle_int:	
	sta WSYNC
	CHOOSE_COLOR
	lda sprite0,X
	sta GRP0
	lda sprite1,X
	sta GRP1
	iny
	dec tmp
	bpl .loop_middle_int
	dex
	bpl .loop_middle_ext

	ldx #55
.loop_bottom:
	sta WSYNC
	CHOOSE_COLOR
	lda #$00
	sta GRP0
	sta GRP1
	iny
	dex
	bpl .loop_bottom

	sta WSYNC
	lda #$00
	sta COLUBK
	sta COLUPF
	rts

fx_overscan:	SUBROUTINE
	rts

;;; Sprites ripped from:
;;; http://8bitcity.blogspot.com/2011/12/pixel-art-tiny-sprites.html
sprite0:	
	dc.b $00, $00, $00, $00, $55, $7f, $7f, $7f
	dc.b $7f, $6d, $7f, $22, $00, $00, $00, $00
sprite1:
	dc.b $00, $00, $52, $52, $52, $52, $f2, $f2
	dc.b $f2, $fe, $72, $72, $77, $52, $72, $00

