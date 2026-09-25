local M = {}

M.theme_name = "Winamp Nostalgia"
M.theme_author = "Lunedor"
M.theme_variant = "WinampNostalgia"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "00FF66"
M.background_color = "050805"
M.surface_color    = "101510"
M.text_color       = "E0FFE8"
M.dim_color        = "6E8875"
M.danger_color     = "FF5555"

M.font_text = "Consolas"
M.font_size = 13

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "always"
M.titlebar_button_side = "right"

M.bar_height_tb = 30

M.color_bar_bg_tb = "050805"
M.alpha_bar_bg_tb = "20"

M.color_text_tb = "00FF66"
M.color_hover_bg_tb = "172117"

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 86

M.bar_side_inset_osc = 18
M.bar_bottom_inset_osc = 18

M.bar_radius_osc = 2

M.color_bar_bg_osc = "101510"
M.alpha_bar_bg_osc = "10"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

-- Information
M.osc_L1 = "time"
M.osc_L2 = false

-- Transport
M.osc_C1 = "prev"
M.osc_C2 = "seek_back"
M.osc_C3 = "play"
M.osc_C4 = "seek_forward"
M.osc_C5 = "next"

-- Utilities
M.osc_R4 = "playlist"
M.osc_R2 = "volume"
M.osc_R3 = "fullscreen"
M.osc_R1 = "add"

----------------------------------------------------------
-- SEEKBAR
----------------------------------------------------------

M.seek_y_offset = 12

M.seek_side_inset_osc = 12

M.seek_height_normal = 3
M.seek_height_hover = 6

M.color_track_fg_osc = "00FF66"
M.color_track_bg_osc = "243024"

M.seek_border_width_osc = 1
M.seek_border_color_osc = "00FF66"
M.seek_border_alpha_osc = "50"

----------------------------------------------------------
-- THUMB
----------------------------------------------------------

M.thumb_width = 10
M.thumb_height = 10
M.thumb_radius = 0

M.thumb_color = "00FF66"

----------------------------------------------------------
-- TIME
----------------------------------------------------------

M.font_size_osc = 14

M.color_text_osc = "E0FFE8"

M.time_item_width_osc = 120

M.time_label_shadow_osc = false

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.icon_size = 18
M.icon_spacing = 36

M.button_row_offset_osc = 52

M.color_icon_osc = "00FF66"

----------------------------------------------------------
-- BUTTON STYLE
----------------------------------------------------------

M.icon_bg_enabled_osc = true

M.icon_bg_color_osc = "050805"
M.icon_bg_alpha_osc = "00"

M.icon_bg_height_osc = 34
M.icon_bg_radius_osc = 0

M.icon_border_enabled_osc = true

M.icon_border_width_osc = 1
M.icon_border_color_osc = "1B5E32"
M.icon_border_alpha_osc = "80"

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "00FF66"
M.alpha_chapter_mark = "50"

M.chapter_mark_width = 1

M.chapter_tooltip_bg_color = "101510"
M.chapter_tooltip_bg_alpha = "10"

M.chapter_tooltip_radius = 0

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 360

M.row_height_pl = 36
M.row_gap_pl = 1

M.row_radius_pl = 0

M.bar_radius_pl = 2

M.color_bar_bg_pl = "050805"
M.alpha_bar_bg_pl = "10"

M.color_hover_pl = "172117"
M.alpha_hover_pl = "70"

M.color_selected_pl = "00FF66"
M.color_current_pl = "00FF66"

M.color_text_pl = "E0FFE8"
M.color_dim_pl = "6E8875"

M.font_size_pl = 12
M.title_font_size_pl = 15

M.color_scroll_fg_pl = "00FF66"
M.color_scroll_bg_pl = "101510"

return M