local M = {}

M.theme_name = "Windows Media Center 2026"
M.theme_author = "Lunedor"
M.theme_variant = "WindowsMediaCenter2026"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "00A4EF"
M.background_color = "07131F"
M.surface_color    = "102A43"
M.text_color       = "F4FAFF"
M.dim_color        = "8AA4B8"
M.danger_color     = "E81123"

M.font_text = "Segoe UI"
M.font_size = 16

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "auto"
M.titlebar_button_side = "right"

M.bar_height_tb = 38

M.color_bar_bg_tb = "07131F"
M.alpha_bar_bg_tb = "20"

M.color_text_tb = "D9F0FF"
M.color_hover_bg_tb = "153B5C"

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 118

M.bar_side_inset_osc = 30
M.bar_bottom_inset_osc = 26

M.bar_radius_osc = 18

M.color_bar_bg_osc = "102A43"
M.alpha_bar_bg_osc = "18"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

-- Information panel
M.osc_L1 = "time"
M.osc_L2 = false

-- Main media controls
M.osc_C1 = "prev"
M.osc_C2 = "seek_back"
M.osc_C3 = "play"
M.osc_C4 = "seek_forward"
M.osc_C5 = "next"

-- Living room controls
M.osc_R4 = "playlist"
M.osc_R2 = "volume"
M.osc_R3 = "fullscreen"
M.osc_R1 = "add"

----------------------------------------------------------
-- SEEKBAR
----------------------------------------------------------

M.seek_y_offset = 18

M.seek_side_inset_osc = 22

M.seek_height_normal = 6
M.seek_height_hover = 12

M.color_track_fg_osc = "00A4EF"
M.color_track_bg_osc = "34546B"

M.seek_border_width_osc = 0

----------------------------------------------------------
-- THUMB
----------------------------------------------------------

M.thumb_width = 16
M.thumb_height = 16
M.thumb_radius = 8

M.thumb_color = "FFFFFF"

----------------------------------------------------------
-- TIME
----------------------------------------------------------

M.font_size_osc = 18

M.color_text_osc = "F4FAFF"

M.time_item_width_osc = 150

M.time_label_shadow_osc = true
M.time_label_shadow_alpha_osc = "40"

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.icon_size = 26
M.icon_spacing = 52

M.button_row_offset_osc = 72

M.color_icon_osc = "FFFFFF"

----------------------------------------------------------
-- BUTTON STYLE
----------------------------------------------------------

M.icon_bg_enabled_osc = true

M.icon_bg_color_osc = "163B5A"
M.icon_bg_alpha_osc = "30"

M.icon_bg_height_osc = 40
M.icon_bg_radius_osc = 24

M.icon_border_enabled_osc = false

----------------------------------------------------------
-- GROUPS
----------------------------------------------------------

M.icon_group_bg_enabled_osc = true

M.icon_group_bg_color_osc = "07131F"
M.icon_group_bg_alpha_osc = "30"

M.icon_group_bg_padding_osc = 8
M.icon_group_bg_height_osc = 52
M.icon_group_bg_radius_osc = 29

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "00A4EF"
M.alpha_chapter_mark = "50"

M.chapter_mark_width = 2

M.chapter_tooltip_bg_color = "102A43"
M.chapter_tooltip_bg_alpha = "20"

M.chapter_tooltip_radius = 12

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 460

M.row_height_pl = 54
M.row_gap_pl = 5

M.row_radius_pl = 12

M.bar_radius_pl = 22

M.color_bar_bg_pl = "102A43"
M.alpha_bar_bg_pl = "18"

M.color_hover_pl = "153B5C"
M.alpha_hover_pl = "70"

M.color_selected_pl = "00A4EF"
M.color_current_pl = "00A4EF"

M.color_text_pl = "F4FAFF"
M.color_dim_pl = "8AA4B8"

M.font_size_pl = 15
M.title_font_size_pl = 19

M.color_scroll_fg_pl = "00A4EF"
M.color_scroll_bg_pl = "163B5A"

return M