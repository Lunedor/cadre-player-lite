local M = {}

M.theme_name = "Netflix Cinema"
M.theme_author = "Lunedor"
M.theme_variant = "NetflixCinema"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "E50914"
M.background_color = "000000"
M.surface_color    = "141414"
M.text_color       = "FFFFFF"
M.dim_color        = "999999"
M.danger_color     = "E50914"

M.font_text = "Netflix Sans"
M.font_size = 16

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "auto"
M.titlebar_button_side = "right"

M.bar_height_tb = 34

M.color_bar_bg_tb = "000000"
M.alpha_bar_bg_tb = "60"

M.color_text_tb = "FFFFFF"
M.color_hover_bg_tb = "222222"

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 120

M.bar_side_inset_osc = 50
M.bar_bottom_inset_osc = 10

M.bar_radius_osc = 24

M.color_bar_bg_osc = "000000"
M.alpha_bar_bg_osc = "60"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

-- Center cinematic display

M.osc_L1 = false
M.osc_L2 = false

M.osc_C1 = "prev"
M.osc_C2 = "seek_back"
M.osc_C3 = "play"
M.osc_C4 = "seek_forward"
M.osc_C5 = "next"

-- Minimal utilities

M.osc_R1 = "volume"
M.osc_R2 = "playlist"
M.osc_R3 = "fullscreen"

----------------------------------------------------------
-- SEEKBAR
----------------------------------------------------------

M.seek_y_offset = 10

M.seek_side_inset_osc = 30

M.seek_height_normal = 4
M.seek_height_hover = 10

M.color_track_fg_osc = "E50914"
M.color_track_bg_osc = "555555"

M.seek_border_width_osc = 0

----------------------------------------------------------
-- THUMB
----------------------------------------------------------

M.thumb_width = 14
M.thumb_height = 14
M.thumb_radius = 7

M.thumb_color = "FFFFFF"

----------------------------------------------------------
-- TIME
----------------------------------------------------------

M.font_size_osc = 18

M.color_text_osc = "FFFFFF"

M.time_item_width_osc = 160

M.time_label_shadow_osc = true
M.time_label_shadow_alpha_osc = "90"

M.time_label_offset_y = 24

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.icon_size = 28
M.icon_spacing = 54

M.button_row_offset = 72

M.color_icon_osc = "FFFFFF"

----------------------------------------------------------
-- BUTTON STYLE
----------------------------------------------------------

M.icon_bg_enabled_osc = true

M.icon_bg_color_osc = "FFFFFF"
M.icon_bg_alpha_osc = "E0"

M.icon_bg_height_osc = 40
M.icon_bg_radius_osc = 20

M.icon_border_enabled_osc = false

----------------------------------------------------------
-- GROUPS
----------------------------------------------------------

M.icon_group_bg_enabled_osc = false

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "FFFFFF"
M.alpha_chapter_mark = "40"

M.chapter_mark_width = 2

M.chapter_tooltip_bg_color = "141414"
M.chapter_tooltip_bg_alpha = "20"

M.chapter_tooltip_radius = 12

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 480

M.row_height_pl = 52
M.row_gap_pl = 6

M.row_radius_pl = 12

M.bar_radius_pl = 20

M.color_bar_bg_pl = "141414"
M.alpha_bar_bg_pl = "30"

M.color_hover_pl = "222222"
M.alpha_hover_pl = "80"

M.color_selected_pl = "E50914"
M.color_current_pl = "E50914"

M.color_text_pl = "FFFFFF"
M.color_dim_pl = "999999"

M.font_size_pl = 15
M.title_font_size_pl = 20

M.color_scroll_fg_pl = "777777"
M.color_scroll_bg_pl = "222222"

M.bottom_inset_pl = 150

return M