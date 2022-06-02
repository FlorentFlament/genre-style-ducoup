;;;;; FX VARS ;;;;;
PATTERN_FRAMES = 132		; 132 = 24 notes/pattern * (5.5) frames/note
	                        ; 5 frames on odd and 6 frames on even patterns
QUARTER_PATTERN = (PATTERN_FRAMES / 4)

GRID_BG_COL = $88 		; pink
GRID_PF_COL = $9a		; cyan
COLUMNS_BG_COL = $6a 		; red
COLUMNS_PF_COL = $b8		; blue
COLUMNS_RASTA_BG_COL = $2e 		; yellow
COLUMNS_RASTA_PF_COL = $58		; green
LINES_BG_COL = $b8 		; blue
LINES_PF_COL = $2e		; yellow

;;; Keep track of timeline index
;;; bit0 = 0 -> 40x40
;;; bit0 = 1 -> sprites / bg
;;;   bit1 = 0 -> 2 sprites
;;;     bit3 = 0 -> no reflexion
;;;     bit3 = 1 -> reflexion
;;;   bit1 = 1 -> lemming
;;; bit7 = 1 -> end of intro
timeline_i	DS.B	1	; To be used

;;; Keep track of background being displayed
current_bg	DS.B	1


;;;;;;;;;; Sprites variables ;;;;;;;;;;

;;; Sprites pointers
sprite_a_ptr	DS.B	2
sprite_b_ptr	DS.B	2


;;;;;;;;;; bg_colunms variables ;;;;;;;;;;

bg_columns_col_bg	DS.B	1
bg_columns_col_pf	DS.B	1

;;; Colors switch 0 normal colors, 1 reversed colors
bg_columns_col_sw	DS.B	1
bg_columns_cnt		DS.B	1


;;;;;;;;;; bg_lines variables ;;;;;;;;;;
bg_lines_col		DS.B	1


;;;;;;;;;; 40x40 variables ;;;;;;;;;
slideshow_p0	ds 2
slideshow_p1	ds 2
slideshow_p2	ds 2
slideshow_p3	ds 2
slideshow_p4	ds 2
slideshow_p5	ds 2
