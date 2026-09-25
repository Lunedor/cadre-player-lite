local M = {}

M.theme_name = "VHS Retro"
M.theme_author = "Lunedor"
M.theme_variant = "VHSRetro"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "FFB000"
M.background_color = "120F08"
M.surface_color    = "201A0D"
M.text_color       = "FFECC7"
M.dim_color        = "96784A"
M.danger_color     = "FF4444"

M.font_text = "Consolas"
M.font_size = 15

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "always"
M.titlebar_button_side = "right"

M.bar_height_tb = 34

M.color_bar_bg_tb = "120F08"
M.alpha_bar_bg_tb = "20"

M.color_text_tb = "FFB000"
M.color_hover_bg_tb = "33240D"

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 110

M.bar_side_inset_osc = 24
M.bar_bottom_inset_osc = 22

M.bar_radius_osc = 0

M.color_bar_bg_osc = "201A0D"
M.alpha_bar_bg_osc = "10"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

-- Hardware transport controls
M.osc_L1 = "seek_back"
M.osc_L2 = "prev"
M.osc_L3 = "play"
M.osc_L4 = "next"
M.osc_L5 = "seek_forward"

-- Display
M.osc_C1 = "time"

-- Machine controls
M.osc_R4 = "playlist"
M.osc_R2 = "volume"
M.osc_R3 = "fullscreen"
M.osc_R1 = "add"

----------------------------------------------------------
-- SEEKBAR
----------------------------------------------------------

M.seek_y_offset = 16

M.seek_side_inset_osc = 18

M.seek_height_normal = 7
M.seek_height_hover = 10

M.color_track_fg_osc = "FFB000"
M.color_track_bg_osc = "493300"

M.seek_border_width_osc = 1
M.seek_border_color_osc = "FFB000"
M.seek_border_alpha_osc = "40"

----------------------------------------------------------
-- THUMB
----------------------------------------------------------

M.thumb_width = 14
M.thumb_height = 14
M.thumb_radius = 0

M.thumb_color = "FFECC7"

----------------------------------------------------------
-- TIME
----------------------------------------------------------

M.font_size_osc = 20
M.color_text_osc = "FFB000"

M.time_item_width_osc = 170

M.time_label_shadow_osc = true
M.time_label_shadow_alpha_osc = "70"

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.icon_size = 24
M.icon_spacing = 48

M.button_row_offset_osc = 70

M.color_icon_osc = "FFECC7"

----------------------------------------------------------
-- BUTTON STYLE
----------------------------------------------------------

M.icon_bg_enabled_osc = true

M.icon_bg_color_osc = "120F08"
M.icon_bg_alpha_osc = "00"

M.icon_bg_height_osc = 44
M.icon_bg_radius_osc = 0

M.icon_border_enabled_osc = true

M.icon_border_width_osc = 2
M.icon_border_color_osc = "806000"
M.icon_border_alpha_osc = "70"

----------------------------------------------------------
-- GROUPS
----------------------------------------------------------

M.icon_group_bg_enabled_osc = true

M.icon_group_bg_color_osc = "120F08"
M.icon_group_bg_alpha_osc = "00"

M.icon_group_bg_padding_osc = 4
M.icon_group_bg_height_osc = 52
M.icon_group_bg_radius_osc = 0

M.icon_group_border_enabled_osc = true
M.icon_group_border_color_osc = "806000"
M.icon_group_border_alpha_osc = "80"
M.icon_group_border_width_osc = 2

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "FFB000"
M.alpha_chapter_mark = "50"

M.chapter_mark_width = 3

M.chapter_tooltip_bg_color = "201A0D"
M.chapter_tooltip_bg_alpha = "20"

M.chapter_tooltip_radius = 0

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 380

M.row_height_pl = 44
M.row_gap_pl = 2

M.row_radius_pl = 0

M.bar_radius_pl = 0

M.color_bar_bg_pl = "120F08"
M.alpha_bar_bg_pl = "10"

M.color_hover_pl = "33240D"
M.alpha_hover_pl = "70"

M.color_selected_pl = "FFB000"
M.color_current_pl = "FFB000"

M.color_text_pl = "FFECC7"
M.color_dim_pl = "96784A"

M.font_size_pl = 14
M.title_font_size_pl = 18

M.color_scroll_fg_pl = "FFB000"
M.color_scroll_bg_pl = "201A0D"

return M