local M = {}

M.theme_name = "YouTube Player"
M.theme_author = "Lunedor"
M.theme_variant = "YouTubePlayer"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "FF0000"
M.background_color = "0F0F0F"
M.surface_color    = "181818"
M.text_color       = "FFFFFF"
M.dim_color        = "AAAAAA"
M.danger_color     = "FF0000"

M.font_text = "Roboto"
M.font_size = 14

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "auto"
M.titlebar_button_side = "right"

M.bar_height_tb = 32

M.color_bar_bg_tb = "0F0F0F"
M.alpha_bar_bg_tb = "70"

M.color_text_tb = "FFFFFF"
M.color_hover_bg_tb = "272727"

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 78

M.bar_side_inset_osc = 12
M.bar_bottom_inset_osc = 14

M.bar_radius_osc = 8

M.color_bar_bg_osc = "0F0F0F"
M.alpha_bar_bg_osc = "FF"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

-- Video timestamp
M.osc_L1 = "time"

-- Playback
M.osc_C1 = "prev"
M.osc_C2 = "seek_back"
M.osc_C3 = "play"
M.osc_C4 = "seek_forward"
M.osc_C5 = "next"

-- Player options
M.osc_R1 = "volume"
M.osc_R2 = "playlist"
M.osc_R3 = "fullscreen"

----------------------------------------------------------
-- SEEKBAR
----------------------------------------------------------

M.seek_y_offset = 10

M.seek_side_inset_osc = 10

M.seek_height_normal = 3
M.seek_height_hover = 8

M.color_track_fg_osc = "FF0000"
M.color_track_bg_osc = "555555"

M.seek_border_width_osc = 0

----------------------------------------------------------
-- THUMB
----------------------------------------------------------

M.thumb_width = 12
M.thumb_height = 12
M.thumb_radius = 6

M.thumb_color = "FFFFFF"

----------------------------------------------------------
-- TIME
----------------------------------------------------------

M.font_size_osc = 13

M.color_text_osc = "FFFFFF"

M.time_item_width_osc = 130

M.time_label_shadow_osc = true
M.time_label_shadow_alpha_osc = "80"

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.icon_size = 22
M.icon_spacing = 38

M.button_row_offset_osc = 50

M.color_icon_osc = "FFFFFF"

----------------------------------------------------------
-- BUTTON STYLE
----------------------------------------------------------

M.icon_bg_enabled_osc = true

M.icon_bg_color_osc = "181818"
M.icon_bg_alpha_osc = "50"

M.icon_bg_height_osc = 36
M.icon_bg_radius_osc = 18

M.icon_border_enabled_osc = false

----------------------------------------------------------
-- GROUPS
----------------------------------------------------------

M.icon_group_bg_enabled_osc = false

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "FFFFFF"
M.alpha_chapter_mark = "60"

M.chapter_mark_width = 2

M.chapter_tooltip_bg_color = "181818"
M.chapter_tooltip_bg_alpha = "30"

M.chapter_tooltip_radius = 6

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 360

M.row_height_pl = 40
M.row_gap_pl = 2

M.row_radius_pl = 6

M.bar_radius_pl = 12

M.color_bar_bg_pl = "181818"
M.alpha_bar_bg_pl = "20"

M.color_hover_pl = "272727"
M.alpha_hover_pl = "70"

M.color_selected_pl = "FF0000"
M.color_current_pl = "FF0000"

M.color_text_pl = "FFFFFF"
M.color_dim_pl = "AAAAAA"

M.font_size_pl = 14
M.title_font_size_pl = 17

M.color_scroll_fg_pl = "AAAAAA"
M.color_scroll_bg_pl = "333333"

return M