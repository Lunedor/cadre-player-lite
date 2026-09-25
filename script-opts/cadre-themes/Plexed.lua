local M = {}

M.theme_name = "Plexed"
M.theme_author = "Lunedor"
M.theme_variant = "Plexed"

----------------------------------------------------------
-- CORE PALETTE
----------------------------------------------------------

M.accent_color     = "E5A00D"
M.background_color = "090909"
M.surface_color    = "171717"
M.text_color       = "FFFFFF"
M.dim_color        = "A0A0A0"
M.danger_color     = "E50914"

M.font_text = "Inter"
M.font_size = 15

----------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------

M.titlebar_show_mode = "auto"
M.titlebar_button_side = "right"

M.bar_height_tb = 36

M.color_bar_bg_tb = "090909"
M.alpha_bar_bg_tb = "40"

M.color_text_tb = "D6D6D6"
M.color_hover_bg_tb = "262626"

----------------------------------------------------------
-- OSC PANEL
----------------------------------------------------------

M.bar_y_anchor_osc = "bottom"

M.bar_height_osc = 120

M.bar_side_inset_osc = 30
M.bar_bottom_inset_osc = 26

M.bar_radius_osc = 14

M.color_bar_bg_osc = "171717"
M.alpha_bar_bg_osc = "12"

----------------------------------------------------------
-- BUTTON LAYOUT
----------------------------------------------------------

-- Playback cluster left
M.osc_L1 = "prev"
M.osc_L2 = "seek_back"
M.osc_L3 = "play"
M.osc_L4 = "seek_forward"
M.osc_L5 = "next"

-- Information center
M.osc_C1 = "time"
M.osc_C2 = false

-- Theater controls right
M.osc_R1 = "playlist"
M.osc_R2 = "volume"
M.osc_R3 = "fullscreen"
M.osc_R4 = "add"

----------------------------------------------------------
-- SEEKBAR
----------------------------------------------------------

M.seek_y_offset = 18

M.seek_side_inset_osc = 22

M.seek_height_normal = 5
M.seek_height_hover = 9

M.color_track_fg_osc = "E5A00D"
M.color_track_bg_osc = "404040"

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
M.time_label_shadow_alpha_osc = "60"

----------------------------------------------------------
-- ICONS
----------------------------------------------------------

M.icon_size = 25
M.icon_spacing = 52

M.button_row_offset_osc = 72

M.color_icon_osc = "FFFFFF"

----------------------------------------------------------
-- BUTTON BACKGROUND
----------------------------------------------------------

M.icon_bg_enabled_osc = true

M.icon_bg_color_osc = "262626"
M.icon_bg_alpha_osc = "30"

M.icon_bg_height_osc = 35
M.icon_bg_radius_osc = 20

----------------------------------------------------------
-- GROUPS
----------------------------------------------------------

M.icon_group_bg_enabled_osc = true

M.icon_group_bg_color_osc = "111111"
M.icon_group_bg_alpha_osc = "20"

M.icon_group_bg_padding_osc = 4
M.icon_group_bg_height_osc = 54
M.icon_group_bg_radius_osc = 25

----------------------------------------------------------
-- CHAPTERS
----------------------------------------------------------

M.color_chapter_mark = "E5A00D"
M.alpha_chapter_mark = "50"

M.chapter_mark_width = 2

M.chapter_tooltip_bg_color = "171717"
M.chapter_tooltip_bg_alpha = "20"

M.chapter_tooltip_radius = 10

----------------------------------------------------------
-- PLAYLIST
----------------------------------------------------------

M.panel_width_pl = 430

M.row_height_pl = 50
M.row_gap_pl = 5

M.row_radius_pl = 10

M.bar_radius_pl = 18

M.color_bar_bg_pl = "101010"
M.alpha_bar_bg_pl = "12"

M.color_hover_pl = "252525"
M.alpha_hover_pl = "60"

M.color_selected_pl = "E5A00D"
M.color_current_pl = "E5A00D"

M.color_text_pl = "FFFFFF"
M.color_dim_pl = "A0A0A0"

M.font_size_pl = 15
M.title_font_size_pl = 18

M.color_scroll_fg_pl = "555555"
M.color_scroll_bg_pl = "171717"

M.bottom_inset_pl = 170

return M