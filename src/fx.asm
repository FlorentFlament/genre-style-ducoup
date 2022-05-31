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

	;; Clear bg and pf colors
	lda #$00
	sta COLUPF
	sta COLUBK

	lda #$00
	sta current_bg
	CALL_CURRENT_BACKGROUND bg_inits
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
	ENDM

fx_vblank:	SUBROUTINE
	;; Select sprites
	lda patcnt
	lsr
	and #$03		; 4 sprites - Subject to change (also the mechanism)
	tax

	;; Selecting routine depending on timeline
	lda main_timeline,X
	and #$01
	beq .two_distinct
	;; Lemming code goes there
	bne .main_fx_selected
.two_distinct:
	TWO_DISTINCT_SPRITES_VBLANK
.main_fx_selected:

	;; Position sprites
	lda patframe
	lsr
	clc
	adc #33
	POSITION_SPRITE 0
	lda patframe
	lsr
	sta tmp0
	lda #99
	sec
	sbc tmp0
	POSITION_SPRITE 1

	sta WSYNC
	sta HMOVE		; Commit sprites fine tuning

	CALL_CURRENT_BACKGROUND bg_vblanks
	rts

fx_kernel:	SUBROUTINE
	CALL_CURRENT_BACKGROUND bg_kernels
	rts

fx_overscan:	SUBROUTINE
	;; Per pattern chores
	lda patframe
	bne .no_pattern_change
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
;	.byte #$01		; Lemming
	.byte #$00		; 2 sprites - no reflection
	.byte #$08		; 2 sprites - with reflection
	.byte #$08
	.byte #$08

;;; Sprites to be used
sprite_a_timeline_l:
;	.byte #<sprite_lemming_1b
	.byte #<sprite_hello
	.byte #<sprite_tete_mr_0_lego
	.byte #<sprite_tete_mr_2
	.byte #<sprite_tete_mme_0
sprite_a_timeline_h:
;	.byte #>sprite_lemming_1b
	.byte #>sprite_hello
	.byte #>sprite_tete_mr_0_lego
	.byte #>sprite_tete_mr_2
	.byte #>sprite_tete_mme_0
sprite_b_timeline_l:
;	.byte #<sprite_lemming_1w
	.byte #<sprite_folks
	.byte #<sprite_tete_mme_0
	.byte #<sprite_tete_mr_1_barbu
	.byte #<sprite_tete_mme_1
sprite_b_timeline_h:
;	.byte #>sprite_lemming_1w
	.byte #>sprite_folks
	.byte #>sprite_tete_mme_0
	.byte #>sprite_tete_mr_1_barbu
	.byte #>sprite_tete_mme_1

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

sprite_lemming_1b:
	dc.b $00, $00, $00, $00, $00, $30, $18, $18
	dc.b $18, $08, $00, $30, $38, $14, $00, $00
sprite_lemming_1w:
	dc.b $00, $00, $00, $00, $30, $04, $02, $22
	dc.b $20, $10, $1c, $08, $00, $00, $00, $00
