	INCLUDE "bg_grid.asm"

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
	sta COLUP0
	lda #$00
	sta COLUP1

	;; Initial sprites positions
	lda #33
	sta sprite0_pos
	lda #99
	sta sprite1_pos
	;; sprite0 moves left to right
	;; sprite1 moves right to left
	lda #$1
	sta sprites_dir

	;; Clear bg and pf colors
	lda #$00
	sta COLUPF
	sta COLUBK

	jsr bg_6squares_init
	rts

fx_vblank:	SUBROUTINE
	;; Position sprites
	lda sprite0_pos
	POSITION_SPRITE 0
	lda sprite1_pos
	POSITION_SPRITE 1
	sta WSYNC
	sta HMOVE		; Commit sprites fine tuning

	jsr bg_6squares_vblank
	rts

fx_kernel:	SUBROUTINE
	jsr bg_6squares_kernel
	rts

;;; X must be 0 for sprite0, 1 for sprite1
fx_update_sprite_position:	SUBROUTINE
	cpx sprites_dir
	beq .sp_right_left
.sp_left_right:
	inc sprite0_pos,X
	bne .end		; inconditional
.sp_right_left:
	dec sprite0_pos,X
.end:
	rts

fx_overscan:	SUBROUTINE
	;; Update sprites positions
	lda framecnt
	and #$01
	beq .end_update_sprites_positions
	ldx #0
	jsr fx_update_sprite_position
	ldx #1
	jsr fx_update_sprite_position
.end_update_sprites_positions:

	;; Update sprites directions
	lda patframe
	bne .end_update_sprites_directions
	lda sprites_dir
	eor #$01
	sta sprites_dir
.end_update_sprites_directions:

	jsr bg_6squares_overscan
	rts

;;; Sprites ripped from:
;;; http://8bitcity.blogspot.com/2011/12/pixel-art-tiny-sprites.html
sprite0:
	dc.b $00, $00, $00, $00, $55, $ff, $7f, $7f
	dc.b $7f, $6d, $7f, $22, $00, $00, $00, $00
sprite1:
	dc.b $00, $00, $52, $52, $52, $52, $f2, $f2
	dc.b $f2, $fe, $72, $72, $77, $52, $72, $00
