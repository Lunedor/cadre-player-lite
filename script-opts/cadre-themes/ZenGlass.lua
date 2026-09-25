local M = {}

M.theme_name = "Zen Glass"
M.theme_author = "Lunedor"
M.theme_variant = "ZenGlass"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "FFFFFF"
M.background_color = "000000"
M.surface_color    = "FFFFFF"
M.text_color       = "FFFFFF"
M.dim_color        = "AAAAAA"
M.danger_color     = "FF4444"

M.font_text = "Inter"
M.font_size = 14
M.title_font_size = 18

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "auto"
M.titlebar_button_side = "right"

M.bar_height_tb = 30

M.color_bar_bg_tb = "000000"
M.alpha_bar_bg_tb = "FF"

M.color_text_tb = "FFFFFF"
M.color_hover_bg_tb = "030303"

M.alpha_button_bg_tb = "A0"
M.close_button_radius_tb = 0

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

-- Completely invisible container

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 86

M.bar_side_inset_osc = 40
M.bar_bottom_inset_osc = 28

M.bar_radius_osc = 0

M.color_bar_bg_osc = "000000"
M.alpha_bar_bg_osc = "FF"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

-- Minimal centered controls

M.osc_L1 = "play"
M.osc_L2 = "time"

M.osc_R1 = "volume_slider"
M.osc_R3 = "playlist"
M.osc_R2 = "fullscreen"

M.volume_slider_mute_osc = true
M.volume_slider_width_osc = 70
M.volume_slider_height_osc = 2
M.volume_slider_thumb_width_osc = 4
M.volume_slider_thumb_height_osc = 6
M.volume_slider_pad_right_osc = 18

----------------------------------------------------------
-- SEEKBAR
----------------------------------------------------------

M.seek_y_offset = 12

M.seek_side_inset_osc = 0

M.seek_height_normal = 2
M.seek_height_hover = 5

M.color_track_fg_osc = "FFFFFF"
M.color_track_bg_osc = "666666"

M.seek_border_width_osc = 0

----------------------------------------------------------
-- THUMB
----------------------------------------------------------

M.thumb_width = 5
M.thumb_height = 5
M.thumb_radius = 5

M.thumb_color = "FFFFFF"

----------------------------------------------------------
-- TIME
----------------------------------------------------------

M.font_size_osc = 18

M.color_text_osc = "FFFFFF"

M.time_item_width_osc = 100

M.time_label_shadow_osc = true
M.time_label_shadow_color_osc = "000000"
M.time_label_shadow_alpha_osc = "90"

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.icon_size = 22
M.icon_spacing = 46

M.button_row_offset_osc = 54

M.color_icon_osc = "FFFFFF"

M.alpha_icon_dim_osc = "00"

----------------------------------------------------------
-- BUTTON STYLE
----------------------------------------------------------

-- Almost invisible floating buttons

M.icon_bg_enabled_osc = true

M.icon_bg_color_osc = "030303"
M.icon_bg_alpha_osc = "E8"

M.icon_bg_pad_x_osc = 6

M.icon_bg_height_osc = 36
M.icon_bg_radius_osc = 20

M.icon_border_enabled_osc = false

----------------------------------------------------------
-- GROUPS
----------------------------------------------------------

-- No visual grouping

M.icon_group_bg_enabled_osc = false

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "FFFFFF"
M.alpha_chapter_mark = "70"

M.chapter_mark_width = 1

M.chapter_tooltip_bg_color = "000000"
M.chapter_tooltip_bg_alpha = "40"

M.chapter_tooltip_radius = 8

M.chapter_tooltip_pad_x = 12
M.chapter_tooltip_pad_y = 6

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 380

M.row_height_pl = 44
M.row_gap_pl = 4

M.row_radius_pl = 12

M.bar_radius_pl = 20

M.color_bar_bg_pl = "030303"
M.alpha_bar_bg_pl = "80"

M.color_hover_pl = "FFFFFF"
M.alpha_hover_pl = "E0"

M.color_selected_pl = "4F4F4F"
M.color_current_pl = "3F3F3F"

M.color_text_pl = "FFFFFF"
M.color_dim_pl = "FFFFFF"

M.font_size_pl = 14

M.color_scroll_fg_pl = "FFFFFF"
M.color_scroll_bg_pl = "333333"

return M