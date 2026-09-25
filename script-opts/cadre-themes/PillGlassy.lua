-- cadre_theme.lua
local M = {}

M.theme_name = "Pill and Glassy"
M.theme_author = "Lunedor"

--------------------------------------------------------------------------------
-- Typography
--------------------------------------------------------------------------------

M.font_text = "Inter"
M.font_size = 18
M.title_font_size = 20

--------------------------------------------------------------------------------
-- OSC
--------------------------------------------------------------------------------

M.max_bar_width_osc = 800
M.bar_height = 98

M.bar_bottom_inset = 26

M.bar_radius = 28

M.bar_autohide_sec = 0.5

M.thumb_width = 4
M.thumb_height = 10
M.thumb_radius = 3
M.thumb_color = "7DE2FF"

M.seek_y_offset = 15
M.icon_row_offset = 62

M.icon_spacing = 40

M.seek_height_normal = 6
M.seek_height_hover = 10

M.time_label_offset_y = 17

M.side_margin = 30
M.icon_size = 26

--------------------------------------------------------------------------------
-- Playlist
--------------------------------------------------------------------------------

M.panel_width = 430

M.row_height = 46
M.header_height = 44
M.toolbar_height = 44
M.search_height = 42

M.side_inset = 22
M.top_inset = 58
M.bottom_inset = 120

M.bar_radius_pl = 26

M.scrollbar_width = 5
M.hover_strip_width = 20

--------------------------------------------------------------------------------
-- Titlebar
--------------------------------------------------------------------------------

M.bar_height_tb = 38
M.button_width_tb = 44
M.title_font_size_tb = 14

M.hover_strip_height_tb = 10

--------------------------------------------------------------------------------
-- Base Palette
--------------------------------------------------------------------------------

M.color_text = "F4F8FC"
M.color_dim = "91A0B3"

M.color_bar_bg = "101722"
M.alpha_bar_bg = "45"

M.color_icon = "EDF7FF"
M.color_icon_dim = "65768A"

M.color_hover_bg = "26384A"

--------------------------------------------------------------------------------
-- Playlist
--------------------------------------------------------------------------------

M.color_selected_pl = "26465A"
M.color_current_pl = "7DE2FF"

--------------------------------------------------------------------------------
-- Controls
--------------------------------------------------------------------------------

M.color_track_fg = "7DE2FF"
M.color_track_bg = "344454"

M.color_slider_rail = "25313D"

M.thumb_color = "FFFFFF"

M.color_scroll_fg = "8FA6BB"
M.color_scroll_bg = "19232E"

M.color_danger = "FF6675"

--------------------------------------------------------------------------------
-- Component Overrides
--------------------------------------------------------------------------------

M.color_bar_bg_tb = "121C29"
M.alpha_bar_bg_tb = "42"

M.color_bar_bg_osc = "121D29"
M.alpha_bar_bg_osc = "40"

M.color_bar_bg_pl = "152231"
M.alpha_bar_bg_pl = "3C"

--------------------------------------------------------------------------------
-- Chapter Tooltip
--------------------------------------------------------------------------------

M.color_chapter_mark = "152231"
M.alpha_chapter_mark = "35"

M.chapter_tooltip_bg_color = "172838"
M.chapter_tooltip_bg_alpha = "30"

M.chapter_tooltip_radius = 14

return M