;;;;; FX VARS ;;;;;

;;; Sprites horizontal position on the screen
sprite0_pos	DS.B	1
sprite1_pos	DS.B	1

;;; if 0: sprite0 moves left to right and sprite1 right to left
;;; if 1; sprite1 moves left to right and sprite0 right to left
sprites_dir	DS.B	1
