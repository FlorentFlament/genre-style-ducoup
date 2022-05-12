;;;;;;;;;; Checker Code

	MAC BG_CHECKER_CHOOSE_COLOR
	;; Choose colors according to bit 5 of Y register
	tya
	and #$20
	beq .even
.odd:
	lda #CHECKER_BG_COL
	sta COLUBK
	lda #CHECKER_PF_COL
	sta COLUPF
	bne .color_chosen	; unconditional jump
.even:
	lda #CHECKER_PF_COL
	sta COLUBK
	lda #CHECKER_BG_COL
	sta COLUPF
.color_chosen:
	ENDM

bg_checker_init:	SUBROUTINE
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
bg_checker_vblank:
bg_checker_overscan:
	rts

bg_checker_top_bottom_loop:	SUBROUTINE
	ldx #55
.loop:
	sta WSYNC
	BG_CHECKER_CHOOSE_COLOR
	lda #$00
	sta GRP0
	sta GRP1
	iny
	dex
	bpl .loop
	rts

bg_checker_kernel:	SUBROUTINE
	ldy framecnt
	jsr bg_checker_top_bottom_loop

	ldx #15
.loop_middle_ext:
	lda #7
	sta ptr
.loop_middle_int:
	sta WSYNC
	BG_CHECKER_CHOOSE_COLOR
	lda sprite0,X
	sta GRP0
	lda sprite1,X
	sta GRP1
	iny
	dec ptr
	bpl .loop_middle_int
	dex
	bpl .loop_middle_ext

	jsr bg_checker_top_bottom_loop
	sta WSYNC
	lda #$00
	sta COLUBK
	sta COLUPF
	rts



;;;;;;;;;;; 6 squares code

bg_6squares_init:	SUBROUTINE
	;; Playfield setup
	lda #$1
	sta CTRLPF
	lda #$f0
	sta PF0
	lda #$ff
	sta PF1
	lda #$01
	sta PF2

	lda #0
	sta bg_6squares_cnt
	rts

bg_6squares_vblank:	SUBROUTINE
	clc
	lda bg_6squares_cnt
	cmp #(QUARTER_PATTERN - 6)
	bcc .colors1
.colors0:
	lda #COLUMNS_BG_COL
	sta bg_6squares_col0
	lda #COLUMNS_PF_COL
	sta bg_6squares_col1
	bcs .end		; unconditional
.colors1:
	lda #COLUMNS_PF_COL
	sta bg_6squares_col0
	lda #COLUMNS_BG_COL
	sta bg_6squares_col1
.end:
	rts

bg_6squares_top_bottom_loop:	SUBROUTINE
	ldx #54			; One more line done in kernel main
.loop:
	sta WSYNC
	dex
	bpl .loop
	rts

bg_6squares_kernel:	SUBROUTINE
	;; Set colors (bg and pf)
	sta WSYNC
	lda bg_6squares_col0
	sta COLUBK
	lda bg_6squares_col1
	sta COLUPF
	jsr bg_6squares_top_bottom_loop

	ldx #15
.loop_middle_ext:
	ldy #7
.loop_middle_int:
	sta WSYNC
	lda sprite0,X
	sta GRP0
	lda sprite1,X
	sta GRP1
	dey
	bpl .loop_middle_int
	dex
	bpl .loop_middle_ext

	;; Clear players
	sta WSYNC
	lda #$00
	sta GRP0
	sta GRP1
	jsr bg_6squares_top_bottom_loop

	sta WSYNC
	lda #$00
	sta COLUBK
	sta COLUPF
	rts

bg_6squares_overscan:	SUBROUTINE
	inc bg_6squares_cnt
	lda bg_6squares_cnt
	cmp #QUARTER_PATTERN
	bne .continue
	lda #0
	sta bg_6squares_cnt
.continue:
	rts
