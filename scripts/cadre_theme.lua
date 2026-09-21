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
M.font_text = "Roboto"                  -- Titlebar window control glyphs

-- PLAY BAR & CONTROL ELEMENTS --
M.max_bar_width = 900                   -- Maximum width for floating pills/cards, if you want to make it as full width comment out this line
M.bar_side_inset = 0                    -- Side inset for floating pills/cards
M.bar_bottom_inset = 10                 -- Bottom inset for floating pills/cards
M.bar_radius = 8                        -- Corner rounding for floating pills/cards
M.row_height = 40                       -- Playlist row item height in px
M.header_height = 40                    -- Playlist header height in px
M.toolbar_height = 40                   -- Playlist bottom toolbar height in px
M.search_height = 40                    -- Playlist search input bar height in px
M.bar_autohide_sec = 0.5                -- Auto-hide duration for floating pills/cards in seconds
M.thumb_width = 3                       -- Half-width of the current position indicator
M.thumb_height = 8                      -- Half-height of the current position indicator
M.thumb_radius = 3                      -- Controls the shape (0 = square, 6 = circle)
M.thumb_color = "FFFFFF"                -- Color of the current position indicator
M.bar_height = 90                       -- Height of the control bar
M.seek_y_offset = 15                    -- Padding from the top of the background to the seek bar
M.icon_row_offset = 60                  -- Padding from the top of the background to the icons
M.icon_spacing = 38                     -- Horizontal space between each icon
M.seek_height_normal = 10               -- Normal height of the seek bar
M.seek_height_hover = 12                -- Height of the seek bar when hovered
M.time_label_offset_y = 15              -- Vertical offset for the time label
M.side_margin = 20                      -- Side margin for the control bar and other elements
M.icon_size = 26                        -- Size of the icons in the control bar

-- PLAYLIST PANEL LAYOUT --
M.panel_width = 400                     -- Width of the playlist panel
M.side_inset = 14                       -- Side inset for the playlist panel
M.top_inset = 54                        -- Top inset for the playlist panel
M.bottom_inset = 110                    -- Bottom inset for the playlist panel
M.scrollbar_width = 6                   -- Width of the scrollbar
M.hover_strip_width = 18                -- Width of the hover strip
M.hide_delay_sec = 0.4                  -- Delay before auto-hiding the panel
M.osc_bottom_exclusion = 130            -- Bottom exclusion area for the OSC

-- TITLEBAR LAYOUT --
M.bar_height_tb = 34                    -- Height of the titlebar
M.button_width_tb = 40                  -- Width of the titlebar buttons
M.hover_strip_height_tb = 12            -- Height of the hover strip in the titlebar
M.hide_delay_sec_tb = 0.4               -- Delay before auto-hiding the titlebar
M.maximize_cooldown_sec_tb = 0.35       -- Cooldown time for the maximize action
M.title_font_size_tb = 16               -- Font size for the titlebar text
M.titlebar_show_mode_tb = "always"      -- "auto"   -> hover-to-show or "always" -> titlebar is shown permanently from startup 
M.titlebar_button_side = "right"        -- left for macOS-style (close, minimize, maximize from left edge) or "right" (default, classic Windows) 

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
M.color_bar_bg_tb = nil                -- Titlebar background color
M.alpha_bar_bg_tb = nil                -- Titlebar background transparency
M.color_text_tb = nil                  -- Titlebar text color

-- OSC overrides
M.color_bar_bg_osc = nil               -- OSC background color
M.alpha_bar_bg_osc = nil               -- OSC background transparency

-- Playlist overrides
M.color_bar_bg_pl = nil                -- Playlist background color
M.alpha_bar_bg_pl = nil                -- Playlist background transparency

--------------------------------------------------------------------------------
-- ICON TINTS
--------------------------------------------------------------------------------
M.color_icon = "FFFFFF"                 -- Default icon tint across general views
M.color_icon_dim = "00"                 -- Dimmed icon tint across general views
M.color_icon_osc = nil                  -- OSC-specific icon tint override (overrides M.color_icon)
M.color_icon_pl = nil                   -- Playlist-specific icon tint override (overrides M.color_icon)

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
