	MAC BG_LINES_CHOOSE_NEXT_COLOR
	;; Choose colors according to bit 5 of Y register
	lda sin_table,Y
	clc
	adc tmp0
	and #$18
	beq .even
.odd:
	lda #LINES_BG_COL
	sta bg_lines_col
	bne .color_chosen	; unconditional jump
.even:
	lda #LINES_PF_COL
	sta bg_lines_col
.color_chosen:
	ENDM

bg_lines_init:	SUBROUTINE
	;; Playfield setup
	lda #$0
	sta CTRLPF
	lda #$00
	sta PF0
	sta PF1
	sta PF2
	sta COLUBK
;;; Empty functions
bg_lines_vblank:
bg_lines_overscan:
	rts

bg_lines_top_bottom_loop:	SUBROUTINE
	ldx #55
.loop:
	sta WSYNC
	lda bg_lines_col
	sta COLUBK
	lda #$00
	sta GRP0
	sta GRP1
	BG_LINES_CHOOSE_NEXT_COLOR
	iny
	inc tmp0
	dex
	bpl .loop
	rts

bg_lines_kernel:	SUBROUTINE
	ldy framecnt		; for transformation translation
	lda #$0
	sta tmp0
	jsr bg_lines_top_bottom_loop

	ldx #15
.loop_middle_ext:
	lda #7
	sta ptr
.loop_middle_int:
	sta WSYNC
	lda bg_lines_col
	sta COLUBK
	lda sprite0,X
	sta GRP0
	lda sprite1,X
	sta GRP1
	BG_LINES_CHOOSE_NEXT_COLOR
	iny
	inc tmp0
	dec ptr
	bpl .loop_middle_int
	dex
	bpl .loop_middle_ext

	jsr bg_lines_top_bottom_loop
	sta WSYNC
	lda #$00
	sta COLUBK
	sta COLUPF
	rts

sin_table:
	dc.b $00, $00, $01, $02, $03, $04, $04, $05
	dc.b $06, $07, $08, $09, $09, $0a, $0b, $0c
	dc.b $0d, $0d, $0e, $0f, $10, $10, $11, $12
	dc.b $12, $13, $14, $14, $15, $16, $16, $17
	dc.b $18, $18, $19, $19, $1a, $1a, $1b, $1b
	dc.b $1c, $1c, $1d, $1d, $1d, $1e, $1e, $1f
	dc.b $1f, $1f, $20, $20, $20, $20, $20, $21
	dc.b $21, $21, $21, $21, $21, $21, $21, $21
	dc.b $22, $21, $21, $21, $21, $21, $21, $21
	dc.b $21, $21, $20, $20, $20, $20, $20, $1f
	dc.b $1f, $1f, $1e, $1e, $1d, $1d, $1d, $1c
	dc.b $1c, $1b, $1b, $1a, $1a, $19, $19, $18
	dc.b $18, $17, $16, $16, $15, $14, $14, $13
	dc.b $12, $12, $11, $10, $10, $0f, $0e, $0d
	dc.b $0d, $0c, $0b, $0a, $09, $09, $08, $07
	dc.b $06, $05, $04, $04, $03, $02, $01, $00
	dc.b $00, $00, $ff, $fe, $fd, $fc, $fc, $fb
	dc.b $fa, $f9, $f8, $f7, $f7, $f6, $f5, $f4
	dc.b $f3, $f3, $f2, $f1, $f0, $f0, $ef, $ee
	dc.b $ee, $ed, $ec, $ec, $eb, $ea, $ea, $e9
	dc.b $e8, $e8, $e7, $e7, $e6, $e6, $e5, $e5
	dc.b $e4, $e4, $e3, $e3, $e3, $e2, $e2, $e1
	dc.b $e1, $e1, $e0, $e0, $e0, $e0, $e0, $df
	dc.b $df, $df, $df, $df, $df, $df, $df, $df
	dc.b $de, $df, $df, $df, $df, $df, $df, $df
	dc.b $df, $df, $e0, $e0, $e0, $e0, $e0, $e1
	dc.b $e1, $e1, $e2, $e2, $e3, $e3, $e3, $e4
	dc.b $e4, $e5, $e5, $e6, $e6, $e7, $e7, $e8
	dc.b $e8, $e9, $ea, $ea, $eb, $ec, $ec, $ed
	dc.b $ee, $ee, $ef, $f0, $f0, $f1, $f2, $f3
	dc.b $f3, $f4, $f5, $f6, $f7, $f7, $f8, $f9
	dc.b $fa, $fb, $fc, $fc, $fd, $fe, $ff, $00
