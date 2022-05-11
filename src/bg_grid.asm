;;;;;;;;;; Checker Code

	MAC BG_CHECKER_CHOOSE_COLOR
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

	MAC BG_6SQUARES_CHOOSE_COLOR
	;; Choose colors according to bit 5 of Y register
	clc
	cpy #120
	bcc .even
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
	rts

bg_6squares_top_bottom_loop:	SUBROUTINE
	ldx #55
.loop:
	sta WSYNC
	BG_6SQUARES_CHOOSE_COLOR
	lda #$00
	sta GRP0
	sta GRP1
	iny
	dex
	bpl .loop
	rts

bg_6squares_kernel:	SUBROUTINE
	ldy #0
	jsr bg_6squares_top_bottom_loop

	ldx #15
.loop_middle_ext:
	lda #7
	sta ptr
.loop_middle_int:
	sta WSYNC
	BG_6SQUARES_CHOOSE_COLOR
	lda sprite0,X
	sta GRP0
	lda sprite1,X
	sta GRP1
	iny
	dec ptr
	bpl .loop_middle_int
	dex
	bpl .loop_middle_ext

	jsr bg_6squares_top_bottom_loop
	sta WSYNC
	lda #$00
	sta COLUBK
	sta COLUPF
	rts
