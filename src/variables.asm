;;;;; FX VARS ;;;;;
PATTERN_FRAMES = 132		; 132 = 24 notes/pattern * (5.5) frames/note
	                        ; 5 frames on odd and 6 frames on even patterns
QUARTER_PATTERN = (PATTERN_FRAMES / 4)

GRID_BG_COL = $88 		; pink
GRID_PF_COL = $98		; cyan
COLUMNS_BG_COL = $68 		; red
COLUMNS_PF_COL = $b8		; blue
COLUMNS_RASTA_BG_COL = $2c 		; yellow
COLUMNS_RASTA_PF_COL = $56		; green
LINES_BG_COL = $b6 		; blue
LINES_PF_COL = $2e		; yellow

;;; Keep track of background being displayed
current_bg		DS.B	1


;;;;;;;;;; Sprites variables ;;;;;;;;;;
	
;;; Sprites horizontal position on the screen
sprite0_pos	DS.B	1
sprite1_pos	DS.B	1

;;; if 0: sprite0 moves left to right and sprite1 right to left
;;; if 1; sprite1 moves left to right and sprite0 right to left
sprites_dir	DS.B	1


;;;;;;;;;; bg_colunms variables ;;;;;;;;;;
	
bg_columns_col_bg	DS.B	1
bg_columns_col_pf	DS.B	1

;;; Colors switch 0 normal colors, 1 reversed colors
bg_columns_col_sw	DS.B	1
bg_columns_cnt		DS.B	1


;;;;;;;;;; bg_lines variables ;;;;;;;;;;
bg_lines_col		DS.B	1
