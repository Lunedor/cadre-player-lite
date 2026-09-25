local M = {}

M.theme_name = "Neon Cyberpunk"
M.theme_author = "Lunedor"
M.theme_variant = "NeonCyberpunk"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "00E5FF"
M.background_color = "070914"
M.surface_color    = "160F2B"
M.text_color       = "E8FFFF"
M.dim_color        = "7682A8"
M.danger_color     = "FF2E88"

M.font_text = "Inter"
M.font_size = 14

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "auto"
M.titlebar_button_side = "right"

M.bar_height_tb = 34

M.color_bar_bg_tb = "070914"
M.alpha_bar_bg_tb = "50"

M.color_text_tb = "C7F9FF"
M.color_hover_bg_tb = "22133F"

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 88

M.bar_side_inset_osc = 32
M.bar_bottom_inset_osc = 28

M.bar_radius_osc = 2

M.color_bar_bg_osc = "160F2B"
M.alpha_bar_bg_osc = "18"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

-- HUD style: everything concentrated in the center

M.osc_L1 = "time"
M.osc_L2 = false

M.osc_C1 = "prev"
M.osc_C2 = "seek_back"
M.osc_C3 = "play"
M.osc_C4 = "seek_forward"
M.osc_C5 = "next"

M.osc_R1 = "playlist"
M.osc_R2 = "volume"
M.osc_R3 = "fullscreen"

----------------------------------------------------------
-- SEEKBAR
----------------------------------------------------------

M.seek_y_offset = 14

M.seek_side_inset_osc = 14

M.seek_height_normal = 2
M.seek_height_hover = 6

M.color_track_fg_osc = "00E5FF"
M.color_track_bg_osc = "30204D"

M.seek_border_width_osc = 1
M.seek_border_color_osc = "00E5FF"
M.seek_border_alpha_osc = "60"

----------------------------------------------------------
-- THUMB
----------------------------------------------------------

M.thumb_width = 10
M.thumb_height = 10
M.thumb_radius = 2

M.thumb_color = "FF2E88"

M.thumb_border_width_osc = 1
M.thumb_border_color_osc = "00E5FF"
M.thumb_border_alpha_osc = "20"

----------------------------------------------------------
-- TIME
----------------------------------------------------------

M.font_size_osc = 15
M.color_text_osc = "E8FFFF"

M.time_item_width_osc = 120

M.time_label_shadow_osc = true
M.time_label_shadow_color_osc = "00E5FF"
M.time_label_shadow_alpha_osc = "70"

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.icon_size = 20
M.icon_spacing = 40

M.button_row_offset_osc = 54

M.color_icon_osc = "C7F9FF"

----------------------------------------------------------
-- BUTTON STYLE
----------------------------------------------------------

M.icon_bg_enabled_osc = true

M.icon_bg_color_osc = "160F2B"
M.icon_bg_alpha_osc = "20"

M.icon_bg_height_osc = 38
M.icon_bg_radius_osc = 2

M.icon_border_enabled_osc = true
M.icon_border_width_osc = 1
M.icon_border_color_osc = "00E5FF"
M.icon_border_alpha_osc = "60"

----------------------------------------------------------
-- GROUPS
----------------------------------------------------------

M.icon_group_bg_enabled_osc = true

M.icon_group_bg_color_osc = "0B1022"
M.icon_group_bg_alpha_osc = "30"

M.icon_group_bg_padding_osc = 14
M.icon_group_bg_height_osc = 44
M.icon_group_bg_radius_osc = 2

M.icon_group_border_enabled_osc = true
M.icon_group_border_color_osc = "FF2E88"
M.icon_group_border_alpha_osc = "70"
M.icon_group_border_width_osc = 1

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "FF2E88"
M.alpha_chapter_mark = "30"

M.chapter_mark_width = 2

M.chapter_tooltip_bg_color = "160F2B"
M.chapter_tooltip_bg_alpha = "20"

M.chapter_tooltip_radius = 2

M.chapter_tooltip_pad_x = 14
M.chapter_tooltip_pad_y = 8

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 390

M.row_height_pl = 42
M.row_gap_pl = 3

M.row_radius_pl = 2

M.bar_radius_pl = 2

M.color_bar_bg_pl = "0B1022"
M.alpha_bar_bg_pl = "18"

M.color_hover_pl = "22133F"
M.alpha_hover_pl = "70"

M.color_selected_pl = "00E5FF"
M.color_current_pl = "FF2E88"

M.color_text_pl = "E8FFFF"
M.color_dim_pl = "7682A8"

M.font_size_pl = 13
M.title_font_size_pl = 17

M.color_scroll_fg_pl = "00E5FF"
M.color_scroll_bg_pl = "160F2B"

return M