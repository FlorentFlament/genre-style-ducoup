	MAC BG_LINES_CHOOSE_NEXT_COLOR
	;; Choose colors according to bit 5 of Y register
	lda gum_table,Y
	clc
	sbc tmp0 		; Position of texture
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
	iny
	;inc tmp0
	BG_LINES_CHOOSE_NEXT_COLOR
	dex
	bpl .loop
	rts

bg_lines_kernel:	SUBROUTINE
	ldy framecnt		; for transformation translation
	lda framecnt
	;asl
	sta tmp0
	BG_LINES_CHOOSE_NEXT_COLOR
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
	;inc tmp0
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

gum_table:
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $01, $01, $01, $01, $02
	dc.b $02, $02, $03, $03, $03, $04, $04, $05
	dc.b $05, $05, $06, $06, $07, $08, $08, $09
	dc.b $09, $0a, $0a, $0b, $0c, $0c, $0d, $0e
	dc.b $0f, $0f, $10, $11, $12, $13, $13, $14
	dc.b $15, $16, $17, $18, $19, $1a, $1b, $1c
	dc.b $1d, $1e, $1f, $20, $21, $22, $23, $24
	dc.b $25, $26, $27, $28, $2a, $2b, $2c, $2d
	dc.b $2e, $30, $31, $32, $33, $35, $36, $37
	dc.b $38, $3a, $3b, $3c, $3e, $3f, $40, $42
	dc.b $43, $45, $46, $47, $49, $4a, $4c, $4d
	dc.b $4f, $50, $51, $53, $54, $56, $57, $59
	dc.b $5a, $5c, $5d, $5f, $60, $62, $63, $65
	dc.b $67, $68, $6a, $6b, $6d, $6e, $70, $71
	dc.b $73, $75, $76, $78, $79, $7b, $7c, $7e
	dc.b $7f, $81, $83, $84, $86, $87, $89, $8a
	dc.b $8c, $8e, $8f, $91, $92, $94, $95, $97
	dc.b $98, $9a, $9c, $9d, $9f, $a0, $a2, $a3
	dc.b $a5, $a6, $a8, $a9, $ab, $ac, $ae, $af
	dc.b $b0, $b2, $b3, $b5, $b6, $b8, $b9, $ba
	dc.b $bc, $bd, $bf, $c0, $c1, $c3, $c4, $c5
	dc.b $c7, $c8, $c9, $ca, $cc, $cd, $ce, $cf
	dc.b $d1, $d2, $d3, $d4, $d5, $d7, $d8, $d9
	dc.b $da, $db, $dc, $dd, $de, $df, $e0, $e1
	dc.b $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9
	dc.b $ea, $eb, $ec, $ec, $ed, $ee, $ef, $f0
	dc.b $f0, $f1, $f2, $f3, $f3, $f4, $f5, $f5
	dc.b $f6, $f6, $f7, $f7, $f8, $f9, $f9, $fa
	dc.b $fa, $fa, $fb, $fb, $fc, $fc, $fc, $fd
	dc.b $fd, $fd, $fe, $fe, $fe, $fe, $ff, $ff
	dc.b $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
