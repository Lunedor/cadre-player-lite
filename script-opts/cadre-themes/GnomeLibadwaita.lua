local M = {}

M.theme_name = "GNOME / Libadwaita"
M.theme_author = "Lunedor"
M.theme_variant = "GnomeLibadwaita"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "3584E4"
M.background_color = "242424"
M.surface_color    = "303030"
M.text_color       = "FFFFFF"
M.dim_color        = "B5B5B5"
M.danger_color     = "FF7B63"

M.font_text = "Cantarell"
M.font_size = 15

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "always"
M.titlebar_button_side = "right"

M.bar_height_tb = 40
M.button_width_tb = 44

M.color_bar_bg_tb = "242424"
M.alpha_bar_bg_tb = "00"

M.color_text_tb = "FFFFFF"
M.color_hover_bg_tb = "3D3D3D"

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 96

M.bar_side_inset_osc = 28
M.bar_bottom_inset_osc = 28

M.bar_radius_osc = 16

M.color_bar_bg_osc = "303030"
M.alpha_bar_bg_osc = "10"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

M.osc_L1 = "volume_slider"
M.osc_L2 = false

M.osc_C1 = "prev"
M.osc_C2 = "seek_back"
M.osc_C3 = "play"
M.osc_C4 = "seek_forward"
M.osc_C5 = "next"

M.osc_R1 = "playlist"
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

M.seek_y_offset = 16

M.seek_side_inset_osc = 24

M.seek_height_normal = 4
M.seek_height_hover = 8

M.color_track_fg_osc = "3584E4"
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

M.font_size_osc = 15
M.color_text_osc = "FFFFFF"

M.time_item_width_osc = 130

M.time_label_shadow_osc = false

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.font_icon_osc = "Material Icons Outlined"

M.icon_size = 22
M.icon_spacing = 44

M.button_row_offset_osc = 68

M.color_icon_osc = "FFFFFF"

----------------------------------------------------------
-- BUTTON BACKGROUNDS
----------------------------------------------------------

M.icon_bg_enabled_osc = true

M.icon_bg_color_osc = "3A3A3A"
M.icon_bg_alpha_osc = "30"

M.icon_bg_pad_x_osc = 8
M.icon_bg_height_osc = 42
M.icon_bg_radius_osc = 21

----------------------------------------------------------
-- GROUPS
----------------------------------------------------------

M.icon_group_bg_enabled_osc = false

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "3584E4"
M.alpha_chapter_mark = "50"

M.chapter_mark_width = 2

M.chapter_tooltip_bg_color = "303030"
M.chapter_tooltip_bg_alpha = "10"

M.chapter_tooltip_radius = 10

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 400

M.row_height_pl = 46
M.row_gap_pl = 4

M.row_radius_pl = 10

M.bar_radius_pl = 16

M.color_bar_bg_pl = "303030"
M.alpha_bar_bg_pl = "10"

M.color_hover_pl = "3D3D3D"
M.alpha_hover_pl = "60"

M.color_selected_pl = "3584E4"
M.color_current_pl = "3584E4"

M.color_text_pl = "FFFFFF"
M.color_dim_pl = "B5B5B5"

M.font_size_pl = 14
M.title_font_size_pl = 17

M.color_scroll_fg_pl = "777777"
M.color_scroll_bg_pl = "303030"

M.bottom_inset_pl = 130

return M