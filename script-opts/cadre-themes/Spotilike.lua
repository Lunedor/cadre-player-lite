local M = {}

M.theme_name = "Spotilike"
M.theme_author = "Lunedor"
M.theme_variant = "Spotilike"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "1DB954"
M.background_color = "080808"
M.surface_color    = "181818"
M.text_color       = "FFFFFF"
M.dim_color        = "B3B3B3"

M.font_text = "Inter"
M.font_size = 15

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "auto"
M.titlebar_button_side = "right"

M.bar_height_tb = 34

M.color_bar_bg_tb = "080808"
M.alpha_bar_bg_tb = "30"

M.color_text_tb = "FFFFFF"
M.color_hover_bg_tb = "282828"

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 82
M.bar_side_inset_osc = 20
M.bar_bottom_inset_osc = 18

M.bar_radius_osc = 18

M.color_bar_bg_osc = "181818"
M.alpha_bar_bg_osc = "08"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

-- Left: track information
M.osc_L1 = "time"
M.osc_L2 = false

-- Center: playback
M.osc_C1 = "prev"
M.osc_C2 = "seek_back"
M.osc_C3 = "play"
M.osc_C4 = "seek_forward"
M.osc_C5 = "next"

-- Right: player actions
M.osc_R1 = "volume"
M.osc_R2 = "playlist"
M.osc_R3 = "fullscreen"

----------------------------------------------------------
-- SEEKBAR
----------------------------------------------------------

M.seek_y_offset = 14

M.seek_side_inset_osc = 18

M.seek_height_normal = 3
M.seek_height_hover = 6

M.color_track_fg_osc = "1DB954"
M.color_track_bg_osc = "535353"

M.seek_border_width_osc = 0

----------------------------------------------------------
-- THUMB
----------------------------------------------------------

M.thumb_width = 10
M.thumb_height = 10
M.thumb_radius = 5

M.thumb_color = "FFFFFF"

----------------------------------------------------------
-- TIME
----------------------------------------------------------

M.font_size_osc = 14
M.color_text_osc = "FFFFFF"

M.time_item_width_osc = 120

M.time_label_shadow_osc = false
M.time_label_outline_osc = false

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.icon_size = 22
M.icon_spacing = 42

M.button_row_offset_osc = 52

M.color_icon_osc = "FFFFFF"

M.icon_bg_enabled_osc = false

----------------------------------------------------------
-- GROUPS
----------------------------------------------------------

M.icon_group_bg_enabled_osc = false

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "1DB954"
M.alpha_chapter_mark = "70"

M.chapter_mark_width = 1

M.chapter_tooltip_bg_color = "181818"
M.chapter_tooltip_bg_alpha = "10"

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 380

M.row_height_pl = 48
M.row_gap_pl = 2
M.row_radius_pl = 8

M.bar_radius_pl = 18

M.color_bar_bg_pl = "121212"
M.alpha_bar_bg_pl = "08"

M.color_hover_pl = "282828"
M.alpha_hover_pl = "60"

M.color_selected_pl = "1DB954"
M.color_current_pl = "1DB954"

M.color_text_pl = "FFFFFF"
M.color_dim_pl = "B3B3B3"

M.font_size_pl = 14
M.title_font_size_pl = 18

M.color_scroll_fg_pl = "535353"
M.color_scroll_bg_pl = "181818"

return M