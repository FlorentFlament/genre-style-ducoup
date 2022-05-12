bg_columns_std_init:	SUBROUTINE
	;; Playfield setup - 3 columns
	lda #$1
	sta CTRLPF
	lda #$f0
	sta PF0
	lda #$ff
	sta PF1
	lda #$01
	sta PF2
	lda #0
	sta bg_columns_cnt

	;; Colors setup - Standard colors
	lda #COLUMNS_BG_COL
	sta bg_columns_col_bg
	lda #COLUMNS_PF_COL
	sta bg_columns_col_pf
	rts

bg_columns_rasta_init:	SUBROUTINE
	;; Playfield setup - 5 columns
	lda #$1
	sta CTRLPF
	lda #$f0
	sta PF0
	lda #$f0
	sta PF1
	lda #$f0
	sta PF2
	lda #0
	sta bg_columns_cnt

	;; Colors setup - Rasta colors
	lda #COLUMNS_RASTA_BG_COL
	sta bg_columns_col_bg
	lda #COLUMNS_RASTA_PF_COL
	sta bg_columns_col_pf
	rts

bg_columns_fast_vblank:	SUBROUTINE
	clc
	lda bg_columns_cnt
	cmp #(QUARTER_PATTERN - 6)
	bcs .colors1
.colors0:
	lda #$00
	bcc .end		; unconditional
.colors1:
	lda #$01
.end:
	sta bg_columns_col_sw
	rts

bg_columns_slow_vblank:	SUBROUTINE
	clc
	lda patframe
	cmp #(PATTERN_FRAMES / 4)
	beq .switch_colors
	cmp #(3*PATTERN_FRAMES / 4)
	bne .end
.switch_colors:
	lda bg_columns_col_sw
	eor #$01
	sta bg_columns_col_sw
.end:
	rts

bg_columns_top_bottom_loop:	SUBROUTINE
	ldx #54			; One more line done in kernel main
.loop:
	sta WSYNC
	dex
	bpl .loop
	rts

bg_columns_kernel:	SUBROUTINE
	;; Set colors (bg and pf)
	lda bg_columns_col_sw
	sta WSYNC
	bne .reverse_colors
	lda bg_columns_col_bg
	sta COLUBK
	lda bg_columns_col_pf
	sta COLUPF
	bne .end_set_colors	; unconditional - shouldn't have black color
.reverse_colors:
	lda bg_columns_col_pf
	sta COLUBK
	lda bg_columns_col_bg
	sta COLUPF
.end_set_colors:

	jsr bg_columns_top_bottom_loop

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

	jsr bg_columns_top_bottom_loop

	;; Clear background
	sta WSYNC
	lda #$00
	sta COLUBK
	sta COLUPF
	rts

bg_columns_overscan:	SUBROUTINE
	inc bg_columns_cnt
	lda bg_columns_cnt
	cmp #QUARTER_PATTERN
	bne .continue
	lda #0
	sta bg_columns_cnt
.continue:
	rts
