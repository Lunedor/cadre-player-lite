-- cadre_theme.lua
local M = {}

M.theme_name = "Terminal"
M.theme_author = "Lunedor"

--------------------------------------------------------------------------------
-- Typography
--------------------------------------------------------------------------------

M.font_text = "Consolas"
M.font_size = 14
M.title_font_size = 16

--------------------------------------------------------------------------------
-- OSC
--------------------------------------------------------------------------------

M.bar_height = 78

M.bar_side_inset = 0
M.bar_bottom_inset = 0

M.bar_radius = 0

M.bar_autohide_sec = 0.3

M.thumb_width = 3
M.thumb_height = 8
M.thumb_radius = 0
M.thumb_color = "B5FF75"

M.seek_y_offset = 10
M.icon_row_offset = 50

M.icon_spacing = 32

M.seek_height_normal = 3
M.seek_height_hover = 6

M.time_label_offset_y = 12

M.side_margin = 20
M.icon_size = 22

--------------------------------------------------------------------------------
-- Playlist
--------------------------------------------------------------------------------

M.panel_width = 360

M.row_height = 34
M.header_height = 34
M.toolbar_height = 34
M.search_height = 32

M.side_inset = 8
M.top_inset = 40
M.bottom_inset = 90

M.bar_radius_pl = 0

M.scrollbar_width = 3
M.hover_strip_width = 12

--------------------------------------------------------------------------------
-- Titlebar
--------------------------------------------------------------------------------

M.bar_height_tb = 30
M.button_width_tb = 38

--------------------------------------------------------------------------------
-- Base Palette
--------------------------------------------------------------------------------

M.color_text = "D5D9D2"
M.color_dim = "667064"

M.color_bar_bg = "090B09"
M.alpha_bar_bg = "08"

M.color_icon = "C8D0C4"
M.color_icon_dim = "4E574C"

M.color_hover_bg = "171B17"

--------------------------------------------------------------------------------
-- Playlist
--------------------------------------------------------------------------------

M.color_selected_pl = "263022"
M.color_current_pl = "B5FF75"

--------------------------------------------------------------------------------
-- Controls
--------------------------------------------------------------------------------

M.color_track_fg = "B5FF75"
M.color_track_bg = "252A25"

M.color_slider_rail = "151815"

M.thumb_color = "E8FFE0"

M.color_scroll_fg = "536052"
M.color_scroll_bg = "111411"

M.color_danger = "FF5555"

--------------------------------------------------------------------------------
-- Component Overrides
--------------------------------------------------------------------------------

M.color_bar_bg_tb = "080A08"
M.alpha_bar_bg_tb = "12"

M.color_bar_bg_osc = "090B09"
M.alpha_bar_bg_osc = "10"

M.color_bar_bg_pl = "0B0E0B"
M.alpha_bar_bg_pl = "10"

--------------------------------------------------------------------------------
-- Chapter Tooltip
--------------------------------------------------------------------------------

M.color_chapter_mark = "090B09"
M.alpha_chapter_mark = "20"

M.chapter_tooltip_bg_color = "101410"
M.chapter_tooltip_bg_alpha = "18"

M.chapter_tooltip_radius = 0

return M