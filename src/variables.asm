;;;;; FX VARS ;;;;;
PATTERN_FRAMES = 132		; 132 = 24 notes/pattern * (5.5) frames/note
	                        ; 5 frames on odd and 6 frames on even patterns
QUARTER_PATTERN = (PATTERN_FRAMES / 4)

CHECKER_BG_COL = $88 		; pink
CHECKER_PF_COL = $98		; cyan

;;; Sprites horizontal position on the screen
sprite0_pos	DS.B	1
sprite1_pos	DS.B	1

;;; if 0: sprite0 moves left to right and sprite1 right to left
;;; if 1; sprite1 moves left to right and sprite0 right to left
sprites_dir	DS.B	1

bg_6squares_col0	DS.B	1
bg_6squares_col1	DS.B	1
bg_6squares_cnt		DS.B	1

current_bg		DS.B	1
