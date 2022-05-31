	ALIGN 256 ; In case, but file should be included at the begining of a bank
slideshow_40x40_title_p0:
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
slideshow_40x40_title_p1:
	dc.b $00, $00, $c4, $aa, $aa, $aa, $ca, $00
	dc.b $00, $01, $00, $00, $01, $00, $00, $00
	dc.b $66, $a8, $a4, $88, $66, $00, $00, $00
	dc.b $ff, $00, $70, $71, $71, $71, $71, $71
	dc.b $71, $79, $71, $3d, $00, $ff, $00, $00
slideshow_40x40_title_p2:
	dc.b $00, $00, $98, $44, $44, $44, $98, $00
	dc.b $00, $11, $12, $11, $90, $bb, $00, $00
	dc.b $55, $55, $35, $55, $33, $00, $00, $00
	dc.b $ff, $00, $cf, $e3, $e3, $e3, $e3, $e3
	dc.b $e3, $e3, $e3, $e3, $00, $ff, $00, $00
slideshow_40x40_title_p3:
	dc.b $00, $00, $80, $50, $50, $50, $40, $00
	dc.b $00, $10, $90, $90, $a0, $a0, $00, $00
	dc.b $60, $10, $20, $10, $60, $00, $00, $00
	dc.b $f0, $00, $10, $a0, $a0, $20, $20, $20
	dc.b $20, $a0, $a0, $20, $00, $f0, $00, $00
slideshow_40x40_title_p4:
	dc.b $00, $00, $22, $a0, $b0, $a8, $b0, $00
	dc.b $00, $cd, $10, $08, $10, $0c, $00, $00
	dc.b $a8, $00, $00, $00, $00, $00, $00, $00
	dc.b $ff, $00, $f3, $fb, $3b, $3b, $3b, $3b
	dc.b $fb, $f3, $03, $fb, $00, $ff, $00, $00
slideshow_40x40_title_p5:
	dc.b $00, $00, $05, $00, $00, $00, $00, $00
	dc.b $00, $0a, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $0f, $00, $05, $05, $05, $05, $05, $05
	dc.b $05, $07, $05, $05, $00, $0f, $00, $00
slideshow_40x40_title_ptr:
	dc.w slideshow_40x40_title_colbg
	dc.w slideshow_40x40_title_colfg
	dc.w slideshow_40x40_title_p0
	dc.w slideshow_40x40_title_p1
	dc.w slideshow_40x40_title_p2
	dc.w slideshow_40x40_title_p3
	dc.w slideshow_40x40_title_p4
	dc.w slideshow_40x40_title_p5

	ALIGN 256
slideshow_40x40_title_colbg:
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $00, $00
slideshow_40x40_title_colfg:
	dc.b $00, $00, $62, $62, $62, $62, $62, $00
	dc.b $00, $0e, $0e, $0e, $0e, $0e, $00, $00
	dc.b $b4, $b4, $b4, $b4, $b4, $00, $00, $00
	dc.b $6a, $00, $6a, $6a, $6a, $6a, $6a, $6a
	dc.b $6a, $6a, $6a, $6a, $00, $6a, $00, $00

slideshow_40x40_lemmings_p0:
	dc.b $00, $80, $40, $40, $e0, $40, $00, $c0
	dc.b $00, $80, $40, $80, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00, $c0, $b0
	dc.b $90, $a0, $90, $00, $f0, $f0, $f0, $f0
	dc.b $f0, $00, $f0, $70, $70, $70, $70, $00
slideshow_40x40_lemmings_p1:
	dc.b $00, $53, $54, $67, $45, $42, $00, $0a
	dc.b $92, $12, $38, $92, $00, $06, $0a, $0e
	dc.b $02, $0c, $00, $00, $00, $00, $95, $75
	dc.b $15, $55, $b3, $00, $ff, $ff, $ff, $ff
	dc.b $ff, $00, $32, $ee, $e2, $ea, $f7, $00
slideshow_40x40_lemmings_p2:
	dc.b $00, $22, $22, $2a, $2a, $14, $00, $66
	dc.b $11, $11, $11, $11, $00, $65, $55, $65
	dc.b $45, $43, $00, $00, $00, $00, $99, $ea
	dc.b $89, $ab, $db, $00, $a7, $ab, $a3, $af
	dc.b $73, $00, $d7, $d7, $55, $55, $ba, $00
slideshow_40x40_lemmings_p3:
	dc.b $00, $c0, $a0, $c0, $80, $60, $00, $00
	dc.b $80, $80, $80, $80, $00, $80, $00, $00
	dc.b $80, $80, $00, $00, $00, $00, $e0, $e0
	dc.b $e0, $e0, $90, $00, $70, $b0, $30, $b0
	dc.b $60, $00, $50, $50, $50, $d0, $60, $00
slideshow_40x40_lemmings_p4:
	dc.b $00, $0c, $11, $11, $11, $10, $00, $c8
	dc.b $15, $15, $15, $09, $00, $88, $55, $d5
	dc.b $55, $49, $00, $00, $00, $00, $bb, $bb
	dc.b $9b, $bb, $cc, $00, $7f, $ff, $7f, $7f
	dc.b $ff, $00, $a9, $ae, $ac, $aa, $9c, $00
slideshow_40x40_lemmings_p5:
	dc.b $00, $21, $12, $12, $3a, $11, $00, $33
	dc.b $0a, $3a, $2a, $12, $00, $01, $02, $02
	dc.b $02, $02, $00, $00, $00, $00, $33, $dd
	dc.b $11, $55, $bb, $00, $ff, $ff, $ff, $ff
	dc.b $ff, $00, $f9, $f7, $fb, $fd, $f3, $00
slideshow_40x40_lemmings_ptr:
	dc.w slideshow_40x40_lemmings_colbg
	dc.w slideshow_40x40_lemmings_colfg
	dc.w slideshow_40x40_lemmings_p0
	dc.w slideshow_40x40_lemmings_p1
	dc.w slideshow_40x40_lemmings_p2
	dc.w slideshow_40x40_lemmings_p3
	dc.w slideshow_40x40_lemmings_p4
	dc.w slideshow_40x40_lemmings_p5

	ALIGN 256
slideshow_40x40_lemmings_colbg:
	dc.b $98, $98, $98, $98, $98, $98, $98, $98
	dc.b $98, $98, $98, $98, $98, $98, $98, $98
	dc.b $98, $98, $98, $98, $6a, $6a, $98, $98
	dc.b $98, $98, $98, $6a, $98, $98, $98, $98
	dc.b $98, $6a, $98, $98, $98, $98, $98, $6a
slideshow_40x40_lemmings_colfg:
	dc.b $00, $6a, $6a, $6a, $6a, $6a, $00, $6a
	dc.b $6a, $6a, $6a, $6a, $00, $6a, $6a, $6a
	dc.b $6a, $6a, $00, $00, $00, $00, $6a, $6a
	dc.b $6a, $6a, $6a, $00, $6a, $6a, $6a, $6a
	dc.b $6a, $00, $6a, $6a, $6a, $6a, $6a, $00

	ALIGN 256 ; In case, but file should be included at the begining of a bank
slideshow_40x40_rainbow_p0:
	dc.b $00, $00, $90, $a0, $90, $b0, $c0, $00
	dc.b $f0, $70, $70, $70, $f0, $00, $30, $50
	dc.b $30, $70, $90, $00, $00, $30, $d0, $10
	dc.b $50, $b0, $00, $70, $f0, $f0, $f0, $70
	dc.b $00, $f0, $f0, $f0, $f0, $f0, $00, $00
slideshow_40x40_rainbow_p1:
	dc.b $00, $00, $bb, $77, $77, $77, $77, $00
	dc.b $6f, $ae, $a6, $aa, $67, $00, $ac, $aa
	dc.b $ac, $ae, $9e, $00, $00, $cc, $ab, $a8
	dc.b $aa, $ad, $00, $76, $ab, $ab, $aa, $2b
	dc.b $00, $ea, $da, $d9, $8b, $db, $00, $00
slideshow_40x40_rainbow_p2:
	dc.b $00, $00, $39, $d7, $13, $55, $b3, $00
	dc.b $d4, $d7, $d4, $d5, $e6, $00, $e7, $5f
	dc.b $4f, $57, $d7, $00, $00, $9d, $7d, $3d
	dc.b $5d, $53, $00, $de, $ed, $ee, $c7, $ec
	dc.b $00, $53, $5d, $51, $55, $9b, $00, $00
slideshow_40x40_rainbow_p3:
	dc.b $00, $00, $50, $50, $50, $50, $90, $00
	dc.b $70, $b0, $b0, $b0, $b0, $00, $e0, $50
	dc.b $50, $50, $60, $00, $00, $b0, $50, $50
	dc.b $50, $b0, $00, $70, $b0, $b0, $b0, $b0
	dc.b $00, $70, $f0, $f0, $70, $70, $00, $00
slideshow_40x40_rainbow_p4:
	dc.b $00, $00, $cc, $ab, $c8, $ea, $ed, $00
	dc.b $b7, $56, $56, $dc, $d6, $00, $7c, $ba
	dc.b $bc, $be, $b9, $00, $00, $ac, $ab, $a8
	dc.b $aa, $9d, $00, $6e, $d5, $d5, $d5, $ed
	dc.b $00, $77, $aa, $2a, $aa, $b6, $00, $00
slideshow_40x40_rainbow_p5:
	dc.b $00, $00, $9d, $7d, $bd, $dd, $33, $00
	dc.b $ea, $eb, $f3, $fa, $fb, $00, $3d, $dd
	dc.b $1d, $5d, $b3, $00, $00, $d5, $ff, $ff
	dc.b $ff, $ff, $00, $e6, $fa, $e2, $ea, $f6
	dc.b $00, $fe, $fd, $fd, $fd, $fd, $00, $00
slideshow_40x40_rainbow_ptr:
	dc.w slideshow_40x40_rainbow_colbg
	dc.w slideshow_40x40_rainbow_colfg
	dc.w slideshow_40x40_rainbow_p0
	dc.w slideshow_40x40_rainbow_p1
	dc.w slideshow_40x40_rainbow_p2
	dc.w slideshow_40x40_rainbow_p3
	dc.w slideshow_40x40_rainbow_p4
	dc.w slideshow_40x40_rainbow_p5

	ALIGN 256
slideshow_40x40_rainbow_colbg:
	dc.b $00, $c6, $00, $00, $00, $00, $00, $c6
	dc.b $00, $00, $00, $00, $00, $98, $00, $00
	dc.b $00, $00, $00, $56, $2c, $00, $00, $00
	dc.b $00, $00, $24, $00, $00, $00, $00, $00
	dc.b $64, $00, $00, $00, $00, $00, $64, $00
slideshow_40x40_rainbow_colfg:
	dc.b $00, $00, $c6, $c6, $c6, $c6, $c6, $00
	dc.b $98, $98, $98, $98, $98, $00, $56, $56
	dc.b $56, $56, $56, $00, $00, $2c, $2c, $2c
	dc.b $2c, $2c, $00, $24, $24, $24, $24, $24
	dc.b $00, $64, $64, $64, $64, $64, $00, $00

	ALIGN 256 ; In case, but file should be included at the begining of a bank
slideshow_40x40_rainbow_p0:
	dc.b $00, $00, $90, $a0, $90, $b0, $c0, $00
	dc.b $f0, $70, $70, $70, $f0, $00, $30, $50
	dc.b $30, $70, $90, $00, $00, $30, $d0, $10
	dc.b $50, $b0, $00, $70, $f0, $f0, $f0, $70
	dc.b $00, $f0, $f0, $f0, $f0, $f0, $00, $00
slideshow_40x40_rainbow_p1:
	dc.b $00, $00, $bb, $77, $77, $77, $77, $00
	dc.b $6f, $ae, $a6, $aa, $67, $00, $ac, $aa
	dc.b $ac, $ae, $9e, $00, $00, $cc, $ab, $a8
	dc.b $aa, $ad, $00, $76, $ab, $ab, $aa, $2b
	dc.b $00, $ea, $da, $d9, $8b, $db, $00, $00
slideshow_40x40_rainbow_p2:
	dc.b $00, $00, $39, $d7, $13, $55, $b3, $00
	dc.b $d4, $d7, $d4, $d5, $e6, $00, $e7, $5f
	dc.b $4f, $57, $d7, $00, $00, $9d, $7d, $3d
	dc.b $5d, $53, $00, $de, $ed, $ee, $c7, $ec
	dc.b $00, $53, $5d, $51, $55, $9b, $00, $00
slideshow_40x40_rainbow_p3:
	dc.b $00, $00, $50, $50, $50, $50, $90, $00
	dc.b $70, $b0, $b0, $b0, $b0, $00, $e0, $50
	dc.b $50, $50, $60, $00, $00, $b0, $50, $50
	dc.b $50, $b0, $00, $70, $b0, $b0, $b0, $b0
	dc.b $00, $70, $f0, $f0, $70, $70, $00, $00
slideshow_40x40_rainbow_p4:
	dc.b $00, $00, $cc, $ab, $c8, $ea, $ed, $00
	dc.b $b7, $56, $56, $dc, $d6, $00, $7c, $ba
	dc.b $bc, $be, $b9, $00, $00, $ac, $ab, $a8
	dc.b $aa, $9d, $00, $6e, $d5, $d5, $d5, $ed
	dc.b $00, $77, $aa, $2a, $aa, $b6, $00, $00
slideshow_40x40_rainbow_p5:
	dc.b $00, $00, $9d, $7d, $bd, $dd, $33, $00
	dc.b $ea, $eb, $f3, $fa, $fb, $00, $3d, $dd
	dc.b $1d, $5d, $b3, $00, $00, $d5, $ff, $ff
	dc.b $ff, $ff, $00, $e6, $fa, $e2, $ea, $f6
	dc.b $00, $fe, $fd, $fd, $fd, $fd, $00, $00
slideshow_40x40_rainbow_ptr:
	dc.w slideshow_40x40_rainbow_colbg
	dc.w slideshow_40x40_rainbow_colfg
	dc.w slideshow_40x40_rainbow_p0
	dc.w slideshow_40x40_rainbow_p1
	dc.w slideshow_40x40_rainbow_p2
	dc.w slideshow_40x40_rainbow_p3
	dc.w slideshow_40x40_rainbow_p4
	dc.w slideshow_40x40_rainbow_p5

	ALIGN 256
slideshow_40x40_rainbow_colbg:
	dc.b $00, $c6, $00, $00, $00, $00, $00, $c6
	dc.b $00, $00, $00, $00, $00, $98, $00, $00
	dc.b $00, $00, $00, $56, $2c, $00, $00, $00
	dc.b $00, $00, $24, $00, $00, $00, $00, $00
	dc.b $64, $00, $00, $00, $00, $00, $64, $00
slideshow_40x40_rainbow_colfg:
	dc.b $00, $00, $c6, $c6, $c6, $c6, $c6, $00
	dc.b $98, $98, $98, $98, $98, $00, $56, $56
	dc.b $56, $56, $56, $00, $00, $2c, $2c, $2c
	dc.b $2c, $2c, $00, $24, $24, $24, $24, $24
	dc.b $00, $64, $64, $64, $64, $64, $00, $00

