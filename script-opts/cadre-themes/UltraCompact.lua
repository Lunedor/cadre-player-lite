local M = {}

M.theme_name = "Ultra-Compact Minimalist"
M.theme_author = "Lunedor"

-- Panel Geometry
M.bar_height_osc = 56
M.bar_bottom_inset_osc = 16

-- Seekbar Geometry
M.seek_y_offset = 6
M.seek_height_normal = 2
M.seek_height_hover = 4
M.thumb_width = 8
M.thumb_height = 8
M.thumb_radius = 4

-- Button & Typography sizes
M.button_y_anchor_osc = "bottom"
M.button_row_offset_osc = 22
M.icon_size = 20
M.font_size_osc = 16

-- Left Group (Time only)
M.osc_L1 = "time"
M.osc_L2 = false
M.osc_L3 = false
M.osc_L4 = false
M.osc_L5 = false
M.osc_L6 = false

-- Center Group (Play only)
M.osc_C1 = "play"
M.osc_C2 = false
M.osc_C3 = false
M.osc_C4 = false
M.osc_C5 = false
M.osc_C6 = false

-- Right Group (Volume & Fullscreen)
M.osc_R1 = "volume"
M.osc_R2 = "fullscreen"
M.osc_R3 = false
M.osc_R4 = false
M.osc_R5 = false
M.osc_R6 = false

return M