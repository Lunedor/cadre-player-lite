--[[
cadre_theme.lua — Customization Reference
- Colors: Standard 6-digit hex RGB (e.g., "FFFFFF" for white, "0F1115" for dark obsidian).
- Alpha: Hex transparency scale where "00" = completely opaque and "FF" = invisible.
- Overrides: Append `_osc`, `_pl`, or `_tb` to target specific components (OSC, Playlist, Titlebar).
  Example: `M.color_bar_bg_pl = "111318"` overrides playlist background independently.
]]

local M = {}

--------------------------------------------------------------------------------
-- TYPOGRAPHY & GEOMETRY
--------------------------------------------------------------------------------
M.font_text = "Roboto"       -- Titlebar window control glyphs

M.bar_radius = 00                       -- Corner rounding for floating pills/cards
M.row_height = 40                       -- Playlist row item height in px
M.header_height = 40                    -- Playlist header height in px
M.toolbar_height = 40                   -- Playlist bottom toolbar height in px
M.search_height = 40                    -- Playlist search input bar height in px

--------------------------------------------------------------------------------
-- GLOBAL BASE PALETTE (Fallback for all components unless overridden)
--------------------------------------------------------------------------------
M.color_text = "F1F5F9"                 -- Primary labels, titles, and active text
M.color_dim = "64748B"                  -- Secondary metadata, inactive indices, empty hints
M.color_bar_bg = "0F1115"               -- Base surface background fill for containers
M.alpha_bar_bg = "28"                   -- Base surface transparency ("00" solid -> "FF" hidden)

-- Redesign: Replaced mismatched blue with a unified, cohesive crimson/burgundy family
M.color_current_pl = "BA110C"           -- NOW PLAYING: Matches your exact seekbar crimson red
M.color_selected_pl = "4A0A08"          -- SELECTED/CLICKED: A deep, rich burgundy wine to contrast the active song

--------------------------------------------------------------------------------
-- COMPONENT OVERRIDES (_osc = Control Bar, _pl = Playlist, _tb = Titlebar)
-- Leave nil to inherit global base values above.
--------------------------------------------------------------------------------
-- Titlebar overrides
M.color_bar_bg_tb = nil
M.alpha_bar_bg_tb = nil
M.color_text_tb = nil

-- OSC overrides
M.color_bar_bg_osc = nil
M.alpha_bar_bg_osc = nil

-- Playlist overrides
M.color_bar_bg_pl = nil
M.alpha_bar_bg_pl = nil

--------------------------------------------------------------------------------
-- ICON TINTS
--------------------------------------------------------------------------------
M.color_icon = "FFFFFF"                 -- Default icon tint across general views
M.color_icon_dim = "00"                 -- Dimmed icon tint across general views
M.color_icon_osc = nil                  -- OSC-specific icon tint override
M.color_icon_pl = nil                   -- Playlist-specific icon tint override

--------------------------------------------------------------------------------
-- TRACKS, RAILS & INTERACTIVE SURFACES
--------------------------------------------------------------------------------
M.color_track_fg = "BA110C"             -- Seekbar scrubber grab-handle head
M.color_track_bg = "2B303C"             -- Inactive seekbar background rail
M.color_slider_rail = "2B303C"          -- Volume flyout vertical track rail
M.color_scroll_fg = "CBD5E1"            -- Playlist scrollbar thumb handle
M.color_scroll_bg = "1E222B"            -- Playlist scrollbar track background
M.color_danger = "BA110C"               -- Delete / Recycle Bin action tint
M.color_hover_bg = "221414"             -- Row hover background tint (swapped from blue-grey to subtle warm dark-red)

return M
