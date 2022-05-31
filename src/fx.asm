	INCLUDE "bg_grid.asm"
	INCLUDE "bg_columns.asm"
	INCLUDE "bg_lines.asm"

; Calls current background
; unique argument is the address to call (bg_vblanks, bg_kernels, bg_overscans)
; ex: call_current_background bg_vblanks
    MAC CALL_CURRENT_BACKGROUND
	lda current_bg
	asl
	tax
	lda {1}+1,X
	pha
	lda {1},X
	pha
	rts
    ENDM

;;; Does rough positioning of sprite
;;; Argument: Id for the sprite (0 or 1)
;;; A : must contain Horizontal position
    MAC ROUGH_POSITION_SPRITE
	sec
	; Beware ! this loop must not cross a page !
	echo "[FX position sprite Loop] P", ({1})d, "start :", *
.rough_loop:
	; The rough_loop consumes 15 (5*3) pixels
	sbc #$0f	      ; 2 cycles
	bcs .rough_loop ; 3 cycles
	echo "[FX position sprite Loop] P", ({1})d, "end :", *
	sta RESP{1}
    ENDM

;;; Fine position sprite passed as argument
;;; Argument: Id for the sprite (0 or 1)
;;; A: must contain the remaining value of rough positioning
;;; At the end:
;;; A: is destroyed
    MAC FINE_POSITION_SPRITE
	;; A register has value in [-15 .. -1]
	clc
	adc #$07 ; A in [-8 .. 6]
	eor #$ff ; A in [-7 .. 7]
    REPEAT 4
	asl
    REPEND
	sta HMP{1} ; Fine position of missile or sprite
    ENDM

;;; Position a sprite
;;; Argument: Id for the sprite (0 or 1)
;;; A : must contain Horizontal position
;;; At the end:
;;; A: is destroyed
    MAC POSITION_SPRITE
	sta WSYNC
	SLEEP 14
	ROUGH_POSITION_SPRITE {1}
	FINE_POSITION_SPRITE {1}
    ENDM

;;; Functions used in main
fx_init:	SUBROUTINE
	;; Sprites size and color
	lda #$07
	sta NUSIZ0
	sta NUSIZ1

	lda #$00
	sta timeline_i
	sta current_bg
	CALL_CURRENT_BACKGROUND bg_inits
	rts

;;; Factorize position of sprites
;;; X should contain sprite 0 location
;;; Y should contain sprite 1 location
position_sprites:	SUBROUTINE
	txa
	POSITION_SPRITE 0
	tya
	POSITION_SPRITE 1
	sta WSYNC
	sta HMOVE		; Commit sprites fine tuning
	rts

;;; Compute sprites position when moving from left to right
;;; Stored in A
compute_left_right_position:	SUBROUTINE
	lda patframe
	lsr
	clc
	adc #33
	rts

compute_right_left_position:	SUBROUTINE
	lda patframe
	lsr
	sta tmp0
	lda #99
	sec
	sbc tmp0
	rts


;;; Computes the main timeline index and put it in X
compute_timeline_index:	SUBROUTINE
	ldx timeline_i
	rts

;;; Vblank routine for 2 distinct sprites - same color
	MAC TWO_DISTINCT_SPRITES_VBLANK
	;; Load sprites (switch depending on pattern parity)
	lda patcnt
	and #$01
	bne .switch_sprites	; Ugly, can I do better ?
	lda sprite_a_timeline_l,X
	sta sprite_a_ptr
	lda sprite_a_timeline_h,X
	sta sprite_a_ptr+1
	lda sprite_b_timeline_l,X
	sta sprite_b_ptr
	lda sprite_b_timeline_h,X
	sta sprite_b_ptr+1
	jmp .end_switch_sprites
.switch_sprites:
	lda sprite_a_timeline_l,X
	sta sprite_b_ptr
	lda sprite_a_timeline_h,X
	sta sprite_b_ptr+1
	lda sprite_b_timeline_l,X
	sta sprite_a_ptr
	lda sprite_b_timeline_h,X
	sta sprite_a_ptr+1
.end_switch_sprites:

	;; Set colors
	lda #$00
	sta COLUP0
	lda #$00
	sta COLUP1

	;; Sprite0 - no reflection
	lda #$00
	sta REFP0
	;; Sprite1 - reflected reflection
	lda main_timeline,X
	and #$08
	sta REFP1

	;; Position sprites
	jsr compute_left_right_position
	tax
	jsr compute_right_left_position
	tay
	jsr position_sprites
	ENDM

;;; vblank routine displaying the lemming
	MAC LEMMING_VBLANK
	lda framecnt
	REPEAT 3
	lsr
	REPEND
	and #$03
	tax
	;; Lemming sprite
	lda lemming_sprite_timeline_lb,X
	sta sprite_a_ptr
	lda lemming_sprite_timeline_hb,X
	sta sprite_a_ptr+1
	lda lemming_sprite_timeline_lw,X
	sta sprite_b_ptr
	lda lemming_sprite_timeline_hw,X
	sta sprite_b_ptr+1

	;; Set colors
	lda #$00
	sta COLUP0
	lda #$ff
	sta COLUP1

	lda patcnt
	and #$01
	bne .right_left_move
.left_right_move:
	;; no reflection
	lda #$00
	sta REFP0
	sta REFP1
	;; Sprites moving
	jsr compute_left_right_position
	tax
	tay
	bne .end_move		; unconditional
.right_left_move:
	;; reflection (for both sprites)
	lda #$08
	sta REFP0
	sta REFP1
	;; Sprites moving
	jsr compute_right_left_position
	tax
	tay
.end_move:
	;; Finalize sprites positioning
	jsr position_sprites
	ENDM

fx_vblank:	SUBROUTINE
	;; Selecting routine depending on timeline
	ldx timeline_i
	lda main_timeline,X
	and #$01
	bne .sprites_n_bg
.playfield:
	lda #$00
	sta COLUBK
	sta PF0
	sta PF1
	sta PF2
	;; no reflection
	sta REFP0
	sta REFP1
	lda #$ff
	sta COLUPF
	rts

.sprites_n_bg:
	lda main_timeline,X
	and #$02
	bne .lemming
.two_sprites:
	TWO_DISTINCT_SPRITES_VBLANK
	jmp .bg_vblank
.lemming:
	LEMMING_VBLANK
.bg_vblank:			; common to sprites_n_bg routines
	CALL_CURRENT_BACKGROUND bg_vblanks
	rts


;;; Display a 40x40 picture
	MAC PLAYFIELD_PICTURE
	ldx #0
.bottom_loop:
	ldy #5
.inner_loop:
	sta WSYNC
	lda pf_test_40x40,X
	sta PF0
	lda pf_test_40x40+1,X
	sta PF1
	lda pf_test_40x40+2,X
	sta PF2
	SLEEP 6
	lda pf_test_40x40+3,X
	sta PF0
	lda pf_test_40x40+4,X
	sta PF1
	lda pf_test_40x40+5,X
	sta PF2
	dey
	bpl .inner_loop

	txa
	clc
	adc #6
	tax
	cpx #(40*6)		; 40 lines picture
	bcc .bottom_loop

	sta WSYNC
	lda #$00
	sta PF0
	sta PF1
	sta PF2
	sta COLUPF
	ENDM


fx_kernel:	SUBROUTINE
	;; Selecting routine depending on timeline
	ldx timeline_i
	lda main_timeline,X
	sta WSYNC		; synchronize kernels there
	and #$01
	bne .sprites_n_bg
.playfield:
	PLAYFIELD_PICTURE
	rts
.sprites_n_bg:
	CALL_CURRENT_BACKGROUND bg_kernels
	rts


fx_overscan:	SUBROUTINE
	;; Per pattern chores
	lda patframe
	bne .no_pattern_change
	lda patcnt
	and #$01		; increase timeline_i every other pattern
	bne .end_timeline_i_change
	inc timeline_i
	ldx timeline_i
	lda main_timeline,X
	; back on previous timeline_i when seeing end of timeline indicator
	cmp #$80
	bne .end_timeline_i_change
	dec timeline_i
.end_timeline_i_change:
	;; Possibly update background
	lda patcnt
	REPEAT 2
	lsr
	REPEND
	and #$03		; 4 backgrounds
	sta current_bg
	;; Call background init
	;; Beware ! called each pattern even if background didn't change
	CALL_CURRENT_BACKGROUND bg_inits
.no_pattern_change:
	CALL_CURRENT_BACKGROUND bg_overscans
	rts

bg_inits:
	.word bg_grid_init - 1
	.word bg_columns_rasta_init - 1
	.word bg_lines_init - 1
	.word bg_columns_std_init - 1
bg_vblanks:
	.word bg_grid_vblank - 1
	.word bg_columns_slow_vblank - 1
	.word bg_lines_vblank - 1
	.word bg_columns_fast_vblank - 1
bg_kernels:
	.word bg_grid_kernel - 1
	.word bg_columns_kernel - 1
	.word bg_lines_kernel - 1
	.word bg_columns_kernel - 1
bg_overscans:
	.word bg_grid_overscan - 1
	.word bg_columns_overscan - 1
	.word bg_lines_overscan - 1
	.word bg_columns_overscan - 1

;;; Each bit acts as an independant flag (1 for true, 0 for false)
;;; Bit 0 indicates whether a 40x40 screen should be displayed
;;; Bit 1 indicates whether a lemming should be displayed
;;; Bit 3 indicates whether sprites should be hardware reflected
main_timeline:
	.byte #$00
	.byte #$03		; Lemming
	.byte #$01		; 2 sprites - no reflection
	.byte #$09		; 2 sprites - with reflection
	.byte #$09
	.byte #$09
	.byte #$01
	.byte #$01
	.byte #$01
	.byte #$01
	.byte #$03
	.byte #$00
	.byte #$03
	.byte #$00
	.byte #$09
	.byte #$09
	.byte #$09
	.byte #$09
	.byte #$03
	.byte #$80		; end of intro

;;; Sprites to be used
sprite_a_timeline_l:
	.byte #$00
	.byte #$00
	.byte #<sprite_hello
	.byte #<sprite_tete_mr_0_lego
	.byte #<sprite_tete_mr_2
	.byte #<sprite_tete_mme_0
	.byte #<sprite_symbol_male
	.byte #<sprite_symbol_male
	.byte #<sprite_symbol_female
	.byte #<sprite_symbol_nogenre
	.byte #$00
	.byte #$00
	.byte #$00
	.byte #$00
	.byte #<sprite_tete_mr_0_lego
	.byte #<sprite_tete_mr_2
	.byte #<sprite_tete_mme_0
	.byte #<sprite_animal_dog
	.byte #$00
sprite_a_timeline_h:
	.byte #$00
	.byte #$00
	.byte #>sprite_hello
	.byte #>sprite_tete_mr_0_lego
	.byte #>sprite_tete_mr_2
	.byte #>sprite_tete_mme_0
	.byte #>sprite_symbol_male
	.byte #>sprite_symbol_male
	.byte #>sprite_symbol_female
	.byte #>sprite_symbol_nogenre
	.byte #$00
	.byte #$00
	.byte #$00
	.byte #$00
	.byte #>sprite_tete_mr_0_lego
	.byte #>sprite_tete_mr_2
	.byte #>sprite_tete_mme_0
	.byte #>sprite_animal_dog
	.byte #$00
sprite_b_timeline_l:
	.byte #$00
	.byte #$00
	.byte #<sprite_folks
	.byte #<sprite_tete_mme_0
	.byte #<sprite_tete_mr_1_barbu
	.byte #<sprite_tete_mme_1
	.byte #<sprite_symbol_female
	.byte #<sprite_symbol_male
	.byte #<sprite_symbol_female
	.byte #<sprite_symbol_nogenre
	.byte #$00
	.byte #$00
	.byte #$00
	.byte #$00
	.byte #<sprite_tete_mme_0
	.byte #<sprite_tete_mr_1_barbu
	.byte #<sprite_tete_mme_1
	.byte #<sprite_animal_cat
	.byte #$00
sprite_b_timeline_h:
	.byte #$00
	.byte #$00
	.byte #>sprite_folks
	.byte #>sprite_tete_mme_0
	.byte #>sprite_tete_mr_1_barbu
	.byte #>sprite_tete_mme_1
	.byte #>sprite_symbol_female
	.byte #>sprite_symbol_male
	.byte #>sprite_symbol_female
	.byte #>sprite_symbol_nogenre
	.byte #$00
	.byte #$00
	.byte #$00
	.byte #$00
	.byte #>sprite_tete_mme_0
	.byte #>sprite_tete_mr_1_barbu
	.byte #>sprite_tete_mme_1
	.byte #>sprite_animal_cat
	.byte #$00

;;; Lemmings sprites animation
lemming_sprite_timeline_lb:
	dc.b #<sprite_lemming_1b
	dc.b #<sprite_lemming_2b
	dc.b #<sprite_lemming_3b
	dc.b #<sprite_lemming_4b
lemming_sprite_timeline_hb:
	dc.b #>sprite_lemming_1b
	dc.b #>sprite_lemming_2b
	dc.b #>sprite_lemming_3b
	dc.b #>sprite_lemming_4b
lemming_sprite_timeline_lw:
	dc.b #<sprite_lemming_1w
	dc.b #<sprite_lemming_2w
	dc.b #<sprite_lemming_3w
	dc.b #<sprite_lemming_4w
lemming_sprite_timeline_hw:
	dc.b #>sprite_lemming_1w
	dc.b #>sprite_lemming_2w
	dc.b #>sprite_lemming_3w
	dc.b #>sprite_lemming_4w

sprite_hello:
	dc.b $ff, $20, $ff, $00, $ff, $a1, $00, $ff
	dc.b $01, $00, $ff, $01, $00, $ff, $81, $ff
sprite_folks:
	dc.b $fd, $87, $00, $fb, $04, $ff, $00, $80
	dc.b $ff, $00, $ff, $81, $ff, $00, $05, $ff

sprite_tete_mme_0:
	dc.b $ed, $93, $ed, $93, $b9, $fd, $7e, $fe
	dc.b $fc, $f2, $ed, $c1, $d5, $e2, $7c, $38
sprite_tete_mme_1:
	dc.b $7e, $81, $99, $bd, $bd, $7d, $fa, $fc
	dc.b $f2, $e1, $e5, $e1, $ea, $f1, $7e, $1c
sprite_tete_mr_0_lego:
	dc.b $ff, $ab, $d5, $7e, $3c, $42, $42, $99
	dc.b $85, $81, $a5, $81, $e3, $cf, $ff, $7e
sprite_tete_mr_1_barbu:
	dc.b $ff, $ff, $ff, $f9, $e6, $5f, $3f, $79
	dc.b $7e, $f1, $a1, $ea, $e1, $71, $3e, $1c
sprite_tete_mr_2:
	dc.b $7e, $f3, $f9, $f5, $ff, $7e, $24, $42
	dc.b $5a, $81, $a5, $c3, $c3, $ff, $ff, $7e
sprite_tete_mr_3:
	dc.b $7e, $95, $a5, $a5, $a1, $82, $5c, $24
	dc.b $6a, $c2, $d6, $e2, $fc, $7e, $3f, $15
sprite_symbol_female:
	dc.b $fe, $82, $38, $44, $10, $38, $10, $38
	dc.b $44, $44, $44, $38, $00, $28, $82, $fe
sprite_symbol_male:
	dc.b $fe, $82, $28, $00, $70, $88, $88, $88
	dc.b $75, $03, $07, $00, $54, $28, $82, $fe
sprite_symbol_nogenre:
	dc.b $fe, $82, $00, $20, $70, $20, $70, $88
	dc.b $88, $88, $75, $03, $07, $00, $82, $fe
sprite_animal_cat:
	dc.b $3e, $41, $b8, $f5, $ed, $fd, $ff, $ff
	dc.b $ff, $7e, $3e, $0a, $1f, $15, $1e, $12
sprite_animal_dog:
	dc.b $18, $1b, $db, $db, $df, $ff, $ff, $f9
	dc.b $f6, $8d, $5f, $95, $9f, $3e, $36, $24

sprite_lemming_1b:
	dc.b $00, $00, $00, $00, $00, $30, $18, $18
	dc.b $18, $08, $00, $30, $38, $14, $00, $00
sprite_lemming_1w:
	dc.b $00, $00, $00, $00, $30, $04, $02, $22
	dc.b $20, $10, $1c, $08, $00, $00, $00, $00
sprite_lemming_2b:
	dc.b $00, $00, $00, $00, $00, $3c, $1c, $18
	dc.b $08, $00, $10, $38, $28, $00, $00, $00
sprite_lemming_2w:
	dc.b $00, $00, $00, $00, $66, $00, $60, $20
	dc.b $30, $1c, $08, $00, $00, $00, $00, $00
sprite_lemming_3b:
	dc.b $00, $00, $00, $00, $00, $3c, $18, $18
	dc.b $08, $08, $20, $34, $18, $00, $00, $00
sprite_lemming_3w:
	dc.b $00, $00, $00, $00, $4c, $40, $00, $20
	dc.b $10, $10, $1c, $08, $00, $00, $00, $00
sprite_lemming_4b:
	dc.b $00, $00, $00, $00, $00, $18, $18, $08
	dc.b $08, $08, $00, $30, $3c, $00, $00, $00
sprite_lemming_4w:
	dc.b $00, $00, $00, $00, $18, $20, $00, $10
	dc.b $10, $10, $1c, $08, $00, $00, $00, $00

pf_test_40x40:
	dc.b $70, $00, $00, $00, $00, $f0
	dc.b $70, $01, $07, $e0, $e0, $f0
	dc.b $00, $01, $07, $e0, $c0, $f0
	dc.b $00, $00, $04, $e0, $00, $f0
	dc.b $00, $00, $00, $e0, $00, $00
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $38, $00, $00, $00
	dc.b $00, $00, $f2, $70, $00, $00
	dc.b $00, $01, $ff, $70, $00, $00
	dc.b $00, $01, $01, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $00, $f1, $c1, $40, $78, $13
	dc.b $80, $fb, $e1, $40, $fd, $13
	dc.b $80, $c3, $e1, $40, $e1, $13
	dc.b $80, $c3, $e1, $40, $e1, $13
	dc.b $80, $e3, $e1, $40, $f9, $1f
	dc.b $80, $e3, $e1, $40, $7d, $1f
	dc.b $80, $c3, $e1, $40, $05, $13
	dc.b $80, $c3, $e1, $60, $05, $13
	dc.b $80, $c3, $ef, $70, $fd, $13
	dc.b $00, $c1, $c7, $30, $78, $13
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $00, $00, $fc, $f0, $00, $00
	dc.b $00, $00, $fc, $f0, $00, $00
	dc.b $00, $00, $00, $00, $00, $00
	dc.b $f0, $e0, $00, $00, $00, $fc
	dc.b $f0, $e0, $00, $00, $00, $fc
	dc.b $00, $60, $00, $00, $00, $0c
	dc.b $00, $60, $00, $00, $00, $0c
	dc.b $00, $60, $80, $10, $00, $0c
	dc.b $00, $60, $80, $10, $00, $0c
	dc.b $00, $60, $80, $10, $00, $0c
	dc.b $00, $60, $80, $10, $00, $0c
	dc.b $00, $60, $80, $10, $00, $0c
