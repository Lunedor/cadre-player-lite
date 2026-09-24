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

local mp = require "mp"
local msg = require "mp.msg"
local M = {}

M.theme_name = "Default Theme"
M.theme_author = "Lunedor"
M.theme_variant = "GnomeLibadwaita" -- Replaces this file with script-opts/cadre-themes/<name>.lua when changed

----------------------------------------------------------
-- 1. CORE PALETTE (Global Base)
----------------------------------------------------------
-- These define the fundamental look of the application. 
-- Most components will inherit these colors unless 
-- specifically overridden in the sections below.

-- M.accent_color     = "A4A4A4" -- Primary highlight (progress bar, active items, selections)
-- M.background_color = "0A0C10" -- Deepest background color
-- M.surface_color    = "0D1117" -- Elevated elements (control panels, titlebar backgrounds)
-- M.text_color       = "F8FAFC" -- Primary bright text and active icons
-- M.dim_color        = "64748B" -- Secondary text, inactive states, placeholders
-- M.danger_color     = "EF4444" -- Warnings, errors, or destructive actions (like close button hover)

----------------------------------------------------------
-- 2. GLOBAL TYPOGRAPHY & OPACITY
----------------------------------------------------------
-- M.font_text       = "Inter"                      -- Default font family used for drawing text
-- M.font_size       = 16                           -- Default font size used for drawing text
-- M.title_font_size = 18                           -- Default font size used for drawing window titles
-- M.font_icon       = "Material Icons Outlined"    -- Default font family used for drawing icons
-- M.alpha_bar_bg    = "18"                         -- Global background transparency for UI panels
-- M.alpha_icon_dim  = "60"                         -- Global transparency for inactive/dimmed icons

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
-- M.bar_height_tb            = 36      -- Overall height of the titlebar
-- M.button_width_tb          = 44      -- Width of the window control buttons
-- M.hover_strip_height_tb    = 10      -- Height of the invisible trigger zone at the top edge to reveal the bar
-- M.hide_delay_sec_tb        = 0.35    -- How long (in seconds) before the bar hides after mouse leaves
-- M.maximize_cooldown_sec_tb = 0.3     -- Delay to prevent accidental double-clicks when maximizing
-- M.title_font_size_tb       = 14      -- Font size of the window title text

-- Title Bar Specific Overrides
-- M.font_icon_tb             = "Segoe MDL2 Assets" -- Usually kept to Segoe for native Windows window icons
-- M.color_bar_bg_tb          = "07080B"            -- Background color of the titlebar
-- M.alpha_bar_bg_tb          = "38"                -- 00 = opaque, FF = invisible
-- M.color_text_tb            = "E2E8F0"            -- Color of the window title text
-- M.color_hover_bg_tb        = "181C26"            -- Background color of window buttons when hovered
-- M.color_danger_tb          = "EF4444"            -- Close button hover background
-- M.theme.color_button_bg_tb = "181C26" 			-- Titlebar button background color
-- M.theme.alpha_button_bg_tb = "20"				-- 00 = opaque, FF = invisible
-- M.theme.color_button_pressed_bg_tb = "181C26" 	-- Titlebar button background color when pressed
-- M.theme.alpha_button_pressed_bg_tb = "38"		-- Titlebar button background alpha when pressed
-- M.theme.button_radius_tb = 4						-- Titlebar button corner radius
-- M.theme.color_close_bg_tb = "EF4444"				-- Close button background color
-- M.theme.alpha_close_bg_tb = "70"					-- 00 = opaque, FF = invisible (for close button background)
-- M.theme.close_button_radius_tb = 4				-- Close button corner radius

----------------------------------------------------------
-- 4. ON-SCREEN CONTROLLER (_osc) (Play Bar)
----------------------------------------------------------

-- =======================================================
-- 4.1. MAIN PANEL (Global Geometry & Background)
-- =======================================================
-- M.bar_height_osc       = 90       -- Total height of the bottom control panel
-- M.bar_side_inset_osc   = 24       -- Gap between the OSC and the left/right window edges
-- M.bar_y_anchor_osc     = "bottom" -- "bottom", "top", or "center"
-- M.bar_top_inset_osc    = 24       -- Gap above the OSC when top-anchored
-- M.bar_bottom_inset_osc = 24       -- Gap between the OSC and the bottom window edge
-- M.bar_radius_osc       = 12       -- Corner roundness of the OSC panel
-- M.bar_autohide_sec_osc = 0.4      -- Delay before bottom bar hides when mouse leaves
-- M.color_bar_bg_osc     = "0D1117" -- OSC panel background color (Commented: using transparent)
-- M.alpha_bar_bg_osc     = "FF"     -- FF = completely invisible (allows floating elements)

-- =======================================================
-- 4.2. LAYOUT & SLOTS (Button Placement)
-- =======================================================
-- Supported buttons: prev, seek_back, play, pause, seek_forward, next, stop,
-- volume, volume_slider, mute, add, fullscreen, playlist, time.
-- Set a slot to false to remove it. The number controls order.

-- Left Group
-- M.osc_L1 = "time"
-- M.osc_L2 = false
-- M.osc_L3 = false
-- M.osc_L4 = false
-- M.osc_L5 = false
-- M.osc_L6 = false

-- Center Group
-- M.osc_C1 = "prev"
-- M.osc_C2 = "seek_back"
-- M.osc_C3 = "play"
-- M.osc_C4 = "seek_forward"
-- M.osc_C5 = "next"
-- M.osc_C6 = false

-- Right Group
-- M.osc_R1 = "playlist"
-- M.osc_R2 = "fullscreen"
-- M.osc_R3 = "add"
-- M.osc_R4 = "volume"
-- M.osc_R5 = false
-- M.osc_R6 = false

-- =======================================================
-- 4.3. SEEKBAR & TIMELINE (Dimensions & Colors)
-- =======================================================
-- M.seek_y_offset         = 12       -- Distance from the top of the OSC panel to the progress bar
-- M.side_margin           = 16       -- Left/right padding for the progress bar
-- M.seek_side_inset_osc   = 16       -- Horizontal inset for the seekbar only
-- M.seek_height_normal    = 4        -- Thin, minimalist progress bar
-- M.seek_height_hover     = 8        -- Expands on hover for easier clicking
-- M.color_track_fg_osc    = "FFFFFF" -- Foreground: the filled, "played" portion
-- M.color_track_bg_osc    = "444444" -- Background: the empty, "unplayed" portion
-- M.color_slider_rail_osc = "444444" -- Background track used for volume sliders
-- M.seek_border_width_osc = 1        -- Thickness of the border around the progress bar
-- M.seek_border_color_osc = "FFFFFF" -- Color of the border around the progress bar
-- M.seek_border_alpha_osc = "60"     -- 00 = opaque, FF = invisible

-- =======================================================
-- 4.4. THUMB (Draggable Position Indicator)
-- =======================================================
-- M.thumb_width           = 12         -- Width of the indicator
-- M.thumb_height          = 12         -- Height of the indicator (matches width for a circle)
-- M.thumb_radius          = 6          -- Half of width/height creates a perfect circle
-- M.thumb_color           = "FFFFFF"   -- Solid white thumb
-- M.thumb_border_width_osc = 1         -- Thickness of the border around the thumb
-- M.thumb_border_color_osc = "000000"  -- Color of the border around the thumb
-- M.thumb_border_alpha_osc = "60"      -- 00 = opaque, FF = invisible

-- =======================================================
-- 4.5. TEXT & TIME LABELS
-- =======================================================
-- M.time_label_offset_y         = 18           -- Vertical offset for the current time/duration text
-- M.font_size_osc               = 20           -- Font size of the current time/duration text
-- M.color_text_osc              = "FFFFFF"     -- Color of the current time/duration text
-- M.time_item_width_osc         = 140          -- Width reserved for "00:00 / 00:00"
-- M.time_label_shadow_osc       = true         -- Enable a subtle shadow behind the time text for better visibility
-- M.time_label_shadow_x_osc     = 0            -- Horizontal offset of the shadow (0 = directly behind text)
-- M.time_label_shadow_y_osc     = 2            -- Vertical offset of the shadow (0 = directly behind text)
-- M.time_label_shadow_color_osc = "000000"     -- Color of the shadow behind the time text
-- M.time_label_shadow_alpha_osc = "40"         -- 00 = opaque, FF = invisible
-- M.time_label_outline_osc       = true        -- Enable a subtle outline around the time text for better visibility
-- M.time_label_outline_width_osc = 1           -- Thickness of the outline around the time text
-- M.time_label_outline_color_osc = "000000"    -- Color of the outline around the time text
-- M.time_label_outline_alpha_osc = "30"        -- 00 = opaque, FF = invisible

-- =======================================================
-- 4.6. ICONS & INDIVIDUAL BUTTONS
-- =======================================================
-- M.font_icon_osc           = "Material Icons Outlined"
-- M.icon_size               = 24       -- Icon size of OSC buttons
-- M.icon_spacing            = 48       -- Horizontal spacing between buttons
-- M.button_row_offset         = 52       -- Vertical offset of the button row from the top of the OSC panel
-- M.color_icon_osc          = "FFFFFF" -- Icon color of OSC buttons
-- M.alpha_icon_dim_osc      = "00"     -- 00 = opaque, FF = invisible


-- M.icon_bg_enabled_osc     = true     -- Enable a subtle background behind each button for better visibility
-- M.icon_bg_color_osc       = "0D1117" -- Background color of the button backgrounds
-- M.icon_bg_alpha_osc       = "60"     -- 00 = opaque, FF = invisible
-- M.icon_bg_pad_x_osc       = 6        -- Horizontal padding inside the button background
-- M.icon_bg_height_osc      = 40       -- Height of the button background
-- M.icon_bg_radius_osc      = 20       -- Corner roundness of the button background
-- M.icon_border_enabled_osc = true     -- Enable a subtle border around each button for better visibility
-- M.icon_border_width_osc   = 1        -- Thickness of the border around the button background
-- M.icon_border_color_osc   = "FFFFFF" -- Color of the border around the button background
-- M.icon_border_alpha_osc   = "40"     -- 00 = opaque, FF = invisible
-- M.volume_slider_width_osc       = 110 -- Width of the inline volume slider
-- M.volume_slider_height_osc      = 6   -- Track height
-- M.volume_slider_thumb_width_osc = 4   -- Thumb half-width
-- M.volume_slider_thumb_height_osc = 12 -- Thumb half-height
-- M.volume_slider_radius_osc      = 3   -- Track and thumb radius
-- M.volume_slider_color_osc       = "FFFFFF" -- Filled track color
-- M.volume_slider_track_color_osc = "444444" -- Empty track color

-- =======================================================
-- 4.7. BUTTON GROUPS
-- =======================================================
-- M.icon_group_bg_enabled_osc     = true          -- Enable a subtle background behind each button group for better visibility
-- M.icon_group_bg_color_osc       = "111111"      -- Background color of the button group backgrounds
-- M.icon_group_bg_alpha_osc       = "60"          -- 00 = opaque, FF = invisible
-- M.icon_group_bg_padding_osc     = 16            -- Horizontal padding inside the button group background
-- M.icon_group_bg_height_osc      = 48            -- Height of the button group background
-- M.icon_group_bg_radius_osc      = 24            -- Corner roundness of the button group background
-- M.icon_group_border_enabled_osc = false         -- Enable a subtle border around each button group for better visibility
-- M.icon_group_border_color_osc   = "FFFFFF"      -- Color of the border around the button group background
-- M.icon_group_border_alpha_osc   = "40"          -- 00 = opaque, FF = invisible
-- M.icon_group_border_width_osc   = 1             -- Thickness of the border around the button group background

-- M.button_left_inset_osc = 36                    -- Horizontal inset for the left button group
-- M.button_right_inset_osc = 36                   -- Horizontal inset for the right button group
-- M.button_y_anchor_osc   = "top"                 -- Anchor point for button vertical positioning, "top" or "bottom"
-- M.button_row_offset_osc = 52                    -- Offset from the selected bar edge

-- =======================================================
-- 4.8. CHAPTER MARKERS & TOOLTIPS
-- =======================================================
-- M.font_chapter_tooltip       = "Inter"   -- Font family used for drawing chapter name tooltips
-- M.color_chapter_mark         = "000000"  -- Color of the vertical lines indicating chapters
-- M.alpha_chapter_mark         = "40"      -- 00 = opaque, FF = invisible
-- M.chapter_mark_width         = 2         -- Thickness of chapter lines
-- M.chapter_hover_px           = 8         -- How close mouse needs to be to trigger chapter name
-- M.chapter_tooltip_size       = 16        -- Font size of the chapter name tooltip
-- M.chapter_tooltip_offset_y   = 35        -- Vertical offset of the chapter name tooltip from the top of the OSC panel
-- M.chapter_tooltip_bg_color   = "111111"  -- Background color of the chapter name tooltip
-- M.chapter_tooltip_bg_alpha   = "20"      -- 00 = opaque, FF = invisible
-- M.chapter_tooltip_radius     = 6         -- Corner roundness of the chapter name tooltip
-- M.chapter_tooltip_pad_x      = 12        -- Horizontal padding inside the chapter name tooltip
-- M.chapter_tooltip_pad_y      = 8         -- Vertical padding inside the chapter name tooltip

-- =======================================================
-- 4.9 VOLUME SLIDER
-- =======================================================

-- M.volume_slider_mute_osc = true                  -- Volume slider mute button, true = enabled, false = disabled
-- M.volume_slider_width_osc = 110                  -- Width of the inline volume slider
-- M.volume_slider_height_osc = 6                   -- Height of the volume slider track
-- M.volume_slider_thumb_width_osc = 4              -- Width of the volume slider thumb
-- M.volume_slider_thumb_height_osc = 12            -- Height of the volume slider thumb
-- M.volume_slider_radius_osc = 3                   -- Volume slider radius
-- M.volume_slider_color_osc = "FFFFFF"             -- Volume slider filled track color
-- M.volume_slider_track_color_osc = "444444"       -- Volume slider empty track color
-- M.volume_slider_mute_width_osc = 24              -- Width of the mute button
-- M.volume_slider_mute_gap_osc = 8                 -- Gap between the mute button and the volume slider

----------------------------------------------------------
-- 5. PLAYLIST PANEL (_pl)
----------------------------------------------------------
-- Row appearance
-- M.row_padding_x_pl       = 16      -- Horizontal inset for row content
-- M.row_gap_pl             = 2       -- Vertical gap between rows
-- M.row_radius_pl          = 6       -- Corner radius of row backgrounds
-- M.title_offset_x_pl      = 42      -- Title start position inside a row
-- M.row_right_inset_x_pl   = 16      -- Right inset for duration and play icons
-- M.color_hover_pl         = "252A31" -- Hovered row background
-- M.alpha_hover_pl         = "40"    -- 00 = opaque, FF = invisible
-- M.alpha_selected_pl      = "60"    -- Selected row background alpha
-- M.alpha_current_pl       = "88"    -- Current row background alpha
-- M.color_index_pl         = "CBD5E1" -- Playlist index color
-- M.alpha_index_pl         = "30"    -- Playlist index alpha
-- M.color_duration_pl      = "CBD5E1" -- Duration text color
-- M.alpha_duration_pl      = "00"    -- Duration text alpha
-- M.icon_size_pl           = 18      -- Search and row-state icon size
-- M.toolbar_icon_size_pl   = 20      -- Bottom toolbar icon size
-- M.toolbar_icon_spacing_pl = 34     -- Bottom toolbar icon spacing

-- Geometry & Layout
-- M.panel_width_pl       = 420		 -- Width of the playlist side-panel
-- M.row_height_pl        = 42 		 -- Height of each individual track item in the list
-- M.header_height_pl     = 42 		 -- Height of the top header row of the playlist panel
-- M.toolbar_height_pl    = 42 		 -- Height of the toolbar row (search bar, sort buttons, etc.)
-- M.search_height_pl     = 40		  -- Height of the search bar row
-- M.bar_radius_pl        = 20 		 -- Corner roundness of the playlist panel
-- M.font_size_pl         = 14 		 -- Font size of the track text in the playlist
-- M.title_font_size_pl   = 16 		 -- Font size of the playlist title text

-- Positioning & Insets
-- M.side_inset_pl        = 16      -- Gap from the window edge to the panel
-- M.top_inset_pl         = 48      -- Gap from the top window edge (leaves room for titlebar)
-- M.bottom_inset_pl      = 115     -- Gap from the bottom window edge
-- M.osc_bottom_exclusion_pl = 125  -- Minimum vertical pixels to keep clear so playlist doesn't overlap the OSC

-- Interaction
-- M.scrollbar_width_pl   = 4       -- Width of the vertical scrollbar
-- M.hover_strip_width_pl = 16      -- Invisible trigger area at the edge of the screen to open the playlist
-- M.hide_delay_sec_pl    = 0.35    -- How long (in seconds) before the panel hides after mouse leaves

-- Playlist Specific Colors
-- M.font_icon_pl         = "Material Icons Outlined"   -- Font family used for drawing icons in the playlist panel
-- M.color_bar_bg_pl      = "0B0E14"                    -- Panel background
-- M.alpha_bar_bg_pl      = "18"                        -- 00 = opaque, FF = invisible
-- M.color_icon_pl        = "CBD5E1"                    -- Color of the button icons
-- M.color_text_pl        = "F8FAFC"                    -- Color of the track text
-- M.color_dim_pl         = "64748B"                    -- Secondary text (e.g., track durations, artist names)
-- M.color_danger_pl      = "EF4444"                    -- Remove track button color
-- M.color_scroll_fg_pl   = "475569"                    -- Scrollbar handle color
-- M.color_scroll_bg_pl   = "0F172A"                    -- Scrollbar track color
-- M.color_selected_pl    = "63B8FF"                    -- Text/icon color for an actively clicked/selected item
-- M.color_current_pl     = "63B8FF"                    -- Text/icon color for the currently playing track
-- M.alpha_icon_dim_pl    = "60"                        -- 00 = opaque, FF = invisible (for inactive/dimmed icons)

local function load_theme_variant(base_theme)
	local variant = base_theme.theme_variant
	if type(variant) ~= "string" or variant == "" or variant == "default" then
		return base_theme
	end

	local variant_path = variant:gsub("\\\\", "/")
	if not variant_path:lower():match("%.lua$") then
		variant_path = variant_path .. ".lua"
	end

	local relative_paths
	if variant_path:find("/", 1, true) then
		relative_paths = { variant_path }
	else
		relative_paths = {
			"script-opts/cadre-themes/" .. variant_path,
			"script-opt/cadre-themes/" .. variant_path,
			"scripts/cadre-themes/" .. variant_path,
		}
	end

	for _, relative_path in ipairs(relative_paths) do
		local path = mp.find_config_file(relative_path)
		if path then
			local selected_theme = dofile(path)
			if type(selected_theme) ~= "table" then
				msg.warn("cadre_theme: theme variant must return a table: " .. relative_path)
				return base_theme
			end
			selected_theme.theme_variant = variant
			msg.info("cadre_theme: loaded theme variant " .. relative_path)
			return selected_theme
		end
	end

	msg.warn("cadre_theme: theme variant not found: " .. variant)
	return base_theme
end

M = load_theme_variant(M)

return M