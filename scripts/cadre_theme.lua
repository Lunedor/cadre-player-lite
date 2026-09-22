--[[
=========================================================
 cadre_theme.lua
 Default Theme Configuration

 Default theme for the Cadre UI. This file contains every possible customization variable, allowing users to tweak the appearance of the interface to their liking. 
 By default, all settings are commented out, meaning the player will use its hardcoded default fallbacks. To customize, simply uncomment a line and change its value.
 Author: Lunedor

 HOW TO USE:
 This file contains every possible customization variable.
 By default, everything is commented out with `--`, meaning 
 the player will use its hardcoded default fallbacks.

 To change a setting:
 1. Remove the `-- ` at the start of the line.
 2. Change the value.

 COLOR FORMAT:
 Hex: "RRGGBB" (e.g., "0A0C10")
 Alpha: "00" (fully opaque) to "FF" (fully invisible)
=========================================================
]]

local M = {}

M.theme_name = "Default Theme"
M.theme_author = "Lunedor"

----------------------------------------------------------
-- 1. CORE PALETTE (Global Base)
----------------------------------------------------------
-- These define the fundamental look of the application. 
-- Most components will inherit these colors unless 
-- specifically overridden in the sections below.

-- M.accent_color     = "63B8FF" -- Primary highlight (progress bar, active items, selections)
-- M.background_color = "0A0C10" -- Deepest background color
-- M.surface_color    = "0D1117" -- Elevated elements (control panels, titlebar backgrounds)
-- M.text_color       = "F8FAFC" -- Primary bright text and active icons
-- M.dim_color        = "64748B" -- Secondary text, inactive states, placeholders
-- M.danger_color     = "EF4444" -- Warnings, errors, or destructive actions (like close button hover)

----------------------------------------------------------
-- 2. GLOBAL TYPOGRAPHY & OPACITY
----------------------------------------------------------
-- M.font_text       = "Inter"
-- M.font_size       = 16
-- M.title_font_size = 18
-- M.font_icon       = "Material Icons Outlined" -- Default font family used for drawing icons

-- M.alpha_bar_bg    = "18" -- Global background transparency for UI panels
-- M.alpha_icon_dim  = "60" -- Global transparency for inactive/dimmed icons

----------------------------------------------------------
-- 3. TITLE BAR (_tb)
----------------------------------------------------------
-- "auto"   -> Titlebar hides automatically, appears when mouse touches top edge
-- "always" -> Titlebar is permanently visible from startup
-- M.titlebar_show_mode       = "auto"

-- "left"  -> macOS style: Close, Minimize, Maximize on the left
-- "right" -> Windows style: Minimize, Maximize, Close on the right
-- M.titlebar_button_side     = "right"

-- Geometry & Behavior
-- M.bar_height_tb            = 36 -- Overall height of the titlebar
-- M.button_width_tb          = 44 -- Width of the window control buttons
-- M.hover_strip_height_tb    = 10 -- Height of the invisible trigger zone at the top edge to reveal the bar
-- M.hide_delay_sec_tb        = 0.35 -- How long (in seconds) before the bar hides after mouse leaves
-- M.maximize_cooldown_sec_tb = 0.3 -- Delay to prevent accidental double-clicks when maximizing
-- M.title_font_size_tb       = 14

-- Title Bar Specific Overrides
-- M.font_icon_tb             = "Segoe MDL2 Assets" -- Usually kept to Segoe for native Windows window icons
-- M.color_bar_bg_tb          = "07080B"
-- M.alpha_bar_bg_tb          = "38"
-- M.color_text_tb            = "E2E8F0"
-- M.color_hover_bg_tb        = "181C26" -- Background color of window buttons when hovered
-- M.color_danger_tb          = "EF4444" -- Close button hover background

----------------------------------------------------------
-- 4. ON-SCREEN CONTROLLER (_osc) (Play Bar)
----------------------------------------------------------
-- Geometry & Behavior
-- M.bar_height_osc       = 100 -- Total height of the bottom control panel
-- M.bar_side_inset_osc   = 0   -- Gap between the OSC and the left/right window edges
-- M.bar_bottom_inset_osc = 0   -- Gap between the OSC and the bottom window edge
-- M.bar_radius_osc       = 0   -- Corner roundness of the OSC panel
-- M.bar_autohide_sec_osc = 0.4 -- Delay before bottom bar hides when mouse leaves

-- Seekbar (Timeline) Geometry
-- M.seek_y_offset        = 14  -- Distance from the top of the OSC panel to the progress bar
-- M.seek_height_normal   = 6   -- Thickness of the progress bar normally
-- M.seek_height_hover    = 10  -- Thickness of the progress bar when hovered
-- M.side_margin          = 24  -- Left/right padding for the progress bar and icons

-- Thumb (The draggable position indicator on the progress bar)
-- M.thumb_width          = 4   -- Width of the draggable indicator
-- M.thumb_height         = 10  -- Height of the draggable indicator
-- M.thumb_radius         = 5   -- Corner roundness of the thumb (0 = square)

-- Icon & Text Layout
-- M.icon_size            = 24
-- M.icon_spacing         = 36  -- Horizontal space between control icons (play, pause, etc.)
-- M.icon_row_offset      = 60  -- Distance from the top of the OSC panel down to the icons
-- M.time_label_offset_y  = 16  -- Vertical offset for the current time/duration text
-- M.font_size_osc        = 14

-- OSC Specific Colors
-- M.font_icon_osc            = "Material Icons Outlined"
-- M.color_bar_bg_osc         = "0D1117" -- OSC panel background
-- M.alpha_bar_bg_osc         = "1C"
-- M.color_icon_osc           = "F8FAFC"
-- M.color_text_osc           = "F8FAFC"
-- M.alpha_icon_dim_osc       = "60"

-- Track & Progress Colors
-- M.color_track_fg_osc       = "63B8FF" -- Foreground: the filled, "played" portion of the timeline
-- M.color_track_bg_osc       = "303845" -- Background: the empty, "unplayed" portion of the timeline
-- M.color_slider_rail_osc    = "1E293B" -- Background track used for volume sliders
-- M.thumb_color              = "F8FAFC" -- Color of the draggable timeline indicator

-- Chapter Markers & Tooltips
-- M.font_chapter_tooltip       = "Inter"
-- M.color_chapter_mark         = "0A0C10" -- Color of the vertical lines indicating chapters on the seekbar
-- M.alpha_chapter_mark         = "20"
-- M.chapter_mark_width         = 2  -- Thickness of chapter lines
-- M.chapter_hover_px           = 8  -- How close the mouse needs to be (in pixels) to trigger the chapter name
-- M.chapter_tooltip_size       = 18 -- Font size of the chapter hover text
-- M.chapter_tooltip_offset_y   = 36 -- Distance to push the tooltip above the timeline
-- M.chapter_tooltip_bg_color   = "0A0C10"
-- M.chapter_tooltip_bg_alpha   = "30"
-- M.chapter_tooltip_radius     = 8
-- M.chapter_tooltip_pad_x      = 8
-- M.chapter_tooltip_pad_y      = 10

----------------------------------------------------------
-- 5. PLAYLIST PANEL (_pl)
----------------------------------------------------------
-- Geometry & Layout
-- M.panel_width_pl       = 420 -- Width of the playlist side-panel
-- M.row_height_pl        = 42  -- Height of each individual track item in the list
-- M.header_height_pl     = 42
-- M.toolbar_height_pl    = 42
-- M.search_height_pl     = 40
-- M.bar_radius_pl        = 20  -- Corner roundness of the playlist panel
-- M.font_size_pl         = 14
-- M.title_font_size_pl   = 16

-- Positioning & Insets
-- M.side_inset_pl        = 16  -- Gap from the window edge to the panel
-- M.top_inset_pl         = 48  -- Gap from the top window edge (leaves room for titlebar)
-- M.bottom_inset_pl      = 115 -- Gap from the bottom window edge
-- M.osc_bottom_exclusion_pl = 125 -- Minimum vertical pixels to keep clear so playlist doesn't overlap the OSC

-- Interaction
-- M.scrollbar_width_pl   = 4
-- M.hover_strip_width_pl = 16  -- Invisible trigger area at the edge of the screen to open the playlist
-- M.hide_delay_sec_pl    = 0.35

-- Playlist Specific Colors
-- M.font_icon_pl         = "Material Icons Outlined"
-- M.color_bar_bg_pl      = "0B0E14" -- Panel background
-- M.alpha_bar_bg_pl      = "18"
-- M.color_icon_pl        = "CBD5E1"
-- M.color_text_pl        = "F8FAFC"
-- M.color_dim_pl         = "64748B" -- Secondary text (e.g., track durations, artist names)
-- M.color_danger_pl      = "EF4444"
-- M.color_scroll_fg_pl   = "475569" -- Scrollbar handle color
-- M.color_scroll_bg_pl   = "0F172A" -- Scrollbar track color
-- M.color_selected_pl    = "63B8FF" -- Text/icon color for an actively clicked/selected item
-- M.color_current_pl     = "63B8FF" -- Text/icon color for the currently playing track
-- M.alpha_icon_dim_pl    = "60"

return M