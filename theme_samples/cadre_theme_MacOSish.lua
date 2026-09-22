-- cadre_theme.lua

local M = {}

M.theme_name = "MacOSish"
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

M.bar_height = 96

M.bar_side_inset = 16
M.bar_bottom_inset = 18

M.bar_radius = 18

M.bar_autohide_sec = 0.45

M.thumb_width = 4
M.thumb_height = 8
M.thumb_radius = 2

M.seek_y_offset = 15
M.icon_row_offset = 60

M.icon_spacing = 40

M.seek_height_normal = 6
M.seek_height_hover = 10

M.side_margin = 28
M.icon_size = 25

--------------------------------------------------------------------------------
-- Playlist
--------------------------------------------------------------------------------

M.panel_width = 430

M.row_height = 44
M.header_height = 44
M.toolbar_height = 44
M.search_height = 40

M.side_inset = 18
M.top_inset = 54
M.bottom_inset = 120

M.bar_radius_pl = 20

M.scrollbar_width = 5
M.hover_strip_width = 18

--------------------------------------------------------------------------------
-- Titlebar
--------------------------------------------------------------------------------

M.bar_height_tb = 36
M.button_width_tb = 44
M.title_font_size_tb = 14
M.titlebar_button_side_tb = "left"

--------------------------------------------------------------------------------
-- Base Palette
--------------------------------------------------------------------------------

M.color_text = "F5F7FA"
M.color_dim = "8B98A7"

M.color_bar_bg = "1D2025"
M.alpha_bar_bg = "30"

M.color_icon = "F3F5F7"
M.color_icon_dim = "7A8795"

M.color_hover_bg = "31363D"

--------------------------------------------------------------------------------
-- Playlist
--------------------------------------------------------------------------------

M.color_selected_pl = "60748A"
M.color_current_pl = "5AC8FA"

--------------------------------------------------------------------------------
-- Controls
--------------------------------------------------------------------------------

M.color_track_fg = "5AC8FA"
M.color_track_bg = "434A53"

M.color_slider_rail = "323842"

M.thumb_color = "FFFFFF"

M.color_scroll_fg = "AAB2BD"
M.color_scroll_bg = "3A414A"

M.color_danger = "FF5F57"

--------------------------------------------------------------------------------
-- Component Overrides
--------------------------------------------------------------------------------

M.color_bar_bg_tb = "20242A"
M.alpha_bar_bg_tb = "34"

M.color_bar_bg_osc = "22262C"
M.alpha_bar_bg_osc = "34"

M.color_bar_bg_pl = "24282F"
M.alpha_bar_bg_pl = "2C"

--------------------------------------------------------------------------------
-- Chapter Tooltip
--------------------------------------------------------------------------------

M.color_chapter_mark = "24282F"

M.alpha_chapter_mark = "30"

M.chapter_tooltip_bg_color = "2B3037"
M.chapter_tooltip_bg_alpha = "24"
M.chapter_tooltip_radius = 10

return M