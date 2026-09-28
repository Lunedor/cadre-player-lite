--[[
cadre_osc.lua (control bar)
]]
local mp = require "mp"
local assdraw = require "mp.assdraw"
local utils = require "mp.utils"
local msg = require "mp.msg"

local common_path = mp.find_config_file("scripts/cadre_common.lua")
local common = dofile(common_path)
common.register_script("cadre_osc")

local thumbfast = {width = 0, height = 0, disabled = true, available = false}
mp.register_script_message(
    "thumbfast-info",
    function(json)
        local data = utils.parse_json(json)
        if type(data) ~= "table" or not data.width or not data.height then
            msg.error("thumbfast-info: received json didn't produce a table with thumbnail information")
        else
            thumbfast = data
        end
    end
)

--------------------------------------------------------------------------------
-- CONFIG
--------------------------------------------------------------------------------

local theme = common.theme
local icon_size = theme.icon_size or 24
local icon_bg_height = theme.icon_bg_height_osc
    or theme.icon_bg_height
    or (icon_size + 12)
local icon_bg_width = theme.icon_bg_width_osc or icon_bg_height
local cfg = {
    UI_FONT = theme.font_ui or theme.font_text or "Inter",
    ICON_FONT = theme.font_icon_osc or theme.font_icon or "Material Icons Outlined",
    ICON_COLOR = common.bgr(theme.color_icon_osc or theme.text_color or "F8FAFC"),
    TEXT = common.bgr(theme.color_text_osc or theme.text_color or "F8FAFC"),
    FONT_SIZE = theme.font_size_osc or theme.font_size or 16,
    BARBG = common.bgr(theme.color_bar_bg_osc or theme.surface_color or "0D1117"),
    ALPHA_BAR_BG = theme.alpha_bar_bg_osc or theme.alpha_bar_bg or "1C",
    TRACK_FG = common.bgr(theme.color_track_fg_osc or theme.accent_color or "63B8FF"),
    TRACK_BG = common.bgr(theme.color_track_bg_osc or "303845"),
    SLIDER_RAIL = common.bgr(theme.color_slider_rail_osc or "1E293B"),
    THUMB_WCOLOR = common.bgr(theme.thumb_color or theme.color_track_fg_osc or theme.accent_color or "F8FAFC"),
    ICON_DIM_A = theme.alpha_icon_dim_osc or theme.alpha_icon_dim or "60",

    BAR_HEIGHT = theme.bar_height_osc or theme.bar_height or 100,
    BAR_SIDE_INSET = theme.bar_side_inset_osc or theme.bar_side_inset or 0,
    BAR_Y_ANCHOR =
    theme.bar_y_anchor_osc == "top" and "top" or theme.bar_y_anchor_osc == "center" and "center" or "bottom",
    BAR_TOP_INSET = theme.bar_top_inset_osc or 0,
    BAR_BOTTOM_INSET = theme.bar_bottom_inset_osc or theme.bar_bottom_inset or 0,
    BAR_RADIUS = theme.bar_radius_osc or theme.bar_radius or 0,
    AUTOHIDE_SEC = theme.bar_autohide_sec_osc or theme.bar_autohide_sec or 0.4,

    THUMB_WW = theme.thumb_width or 4,
    THUMB_WH = theme.thumb_height or 10,
    THUMB_WRADIUS = theme.thumb_radius or 5,
    SEEK_BORDER_COLOR = common.bgr(theme.seek_border_color_osc or "FFFFFF"),
    SEEK_BORDER_ALPHA = theme.seek_border_alpha_osc or "FF",
    SEEK_BORDER_WIDTH = theme.seek_border_width_osc or 1,
    THUMB_WBORDER_COLOR = common.bgr(theme.thumb_border_color_osc or "000000"),
    THUMB_WBORDER_ALPHA = theme.thumb_border_alpha_osc or "FF",
    THUMB_WBORDER_WIDTH = theme.thumb_border_width_osc or 1,
    SEEK_Y_OFFSET = theme.seek_y_offset or 14,
    SEEK_HEIGHT_NORMAL = theme.seek_height_normal or 6,
    SEEK_HEIGHT_HOVER = theme.seek_height_hover or 10,
    SEEK_SIDE_INSET = theme.seek_side_inset_osc or theme.side_margin or 24,
    BUTTON_LEFT_INSET = theme.button_left_inset_osc or theme.side_margin or 24,
    BUTTON_RIGHT_INSET = theme.button_right_inset_osc or theme.side_margin or 24,
    BUTTON_Y_ANCHOR = theme.button_y_anchor_osc == "bottom" and "bottom" or "top",
    BUTTON_ROW_OFFSET = theme.button_row_offset_osc or theme.button_row_offset or 60,

    ICON_SPACING = theme.icon_spacing or 36,
    ICON_SIZE = icon_size,
    TIME_ITEM_WIDTH = theme.time_item_width_osc or 150,
    TIME_LABEL_OFFSET_Y = theme.time_label_offset_y or 16,
    TIME_LABEL_OUTLINE_WIDTH =
    theme.time_label_outline_osc and (theme.time_label_outline_width_osc or 2) or 0,
    TIME_LABEL_OUTLINE_COLOR = common.bgr(theme.time_label_outline_color_osc or "000000"),
    TIME_LABEL_OUTLINE_ALPHA = theme.time_label_outline_alpha_osc or "30",
    TIME_LABEL_SHADOW = theme.time_label_shadow_osc and 1 or 0,
    TIME_LABEL_SHADOW_X = theme.time_label_shadow_x_osc or 1,
    TIME_LABEL_SHADOW_Y = theme.time_label_shadow_y_osc or 1,
    TIME_LABEL_SHADOW_COLOR = common.bgr(theme.time_label_shadow_color_osc or "000000"),
    TIME_LABEL_SHADOW_ALPHA = theme.time_label_shadow_alpha_osc or "40",
    VOLUME_SLIDER_WIDTH = theme.volume_slider_width_osc or 110,
    VOLUME_SLIDER_HEIGHT = theme.volume_slider_height_osc or 6,
    VOLUME_SLIDER_THUMB_WIDTH = theme.volume_slider_thumb_width_osc or 4,
    VOLUME_SLIDER_THUMB_HEIGHT = theme.volume_slider_thumb_height_osc or 12,
    VOLUME_SLIDER_RADIUS = theme.volume_slider_radius_osc or 3,
    VOLUME_SLIDER_COLOR = common.bgr(theme.volume_slider_color_osc or "FFFFFF"),
    VOLUME_SLIDER_TRACK_COLOR = common.bgr(theme.volume_slider_track_color_osc or "444444"),
    VOLUME_SLIDER_MUTE = theme.volume_slider_mute_osc ~= false,
    VOLUME_SLIDER_MUTE_WIDTH = theme.volume_slider_mute_width_osc or theme.icon_size or 24,
    VOLUME_SLIDER_MUTE_GAP = theme.volume_slider_mute_gap_osc or 8,
    VOLUME_SLIDER_PAD_LEFT = theme.volume_slider_pad_left_osc or 6,
    VOLUME_SLIDER_PAD_RIGHT = theme.volume_slider_pad_right_osc or 6,
    ICON_BG_ENABLED = theme.icon_bg_enabled_osc or false,
    ICON_BG_COLOR = common.bgr(theme.icon_bg_color_osc or theme.surface_color or "0D1117"),
    ICON_BG_ALPHA = theme.icon_bg_alpha_osc or "20",
    ICON_BG_PAD_X = theme.icon_bg_pad_x_osc
    or math.max(0, (icon_bg_width - icon_size) / 2),
    ICON_BG_HEIGHT = icon_bg_height,
    ICON_BG_RADIUS = theme.icon_bg_radius_osc or 0,
    ICON_BORDER_ENABLED = theme.icon_border_enabled_osc or false,
    ICON_BORDER_COLOR = common.bgr(theme.icon_border_color_osc or "FFFFFF"),
    ICON_BORDER_ALPHA = theme.icon_border_alpha_osc or "FF",
    ICON_BORDER_WIDTH = theme.icon_border_width_osc or 1,
    ICON_GROUP_BG_ENABLED = theme.icon_group_bg_enabled_osc or false,
    ICON_GROUP_BG_COLOR = common.bgr(theme.icon_group_bg_color_osc or theme.surface_color or "0D1117"),
    ICON_GROUP_BG_ALPHA = theme.icon_group_bg_alpha_osc or "40",
    ICON_GROUP_BG_PADDING = theme.icon_group_bg_padding_osc or 8,
    ICON_GROUP_BG_HEIGHT = theme.icon_group_bg_height_osc
    or (icon_bg_height + 16),
    ICON_GROUP_BG_RADIUS = theme.icon_group_bg_radius_osc or 0,
    ICON_GROUP_BORDER_ENABLED = theme.icon_group_border_enabled_osc or false,
    ICON_GROUP_BORDER_COLOR = common.bgr(theme.icon_group_border_color_osc or "FFFFFF"),
    ICON_GROUP_BORDER_ALPHA = theme.icon_group_border_alpha_osc or "FF",
    ICON_GROUP_BORDER_WIDTH = theme.icon_group_border_width_osc or 1,

    CHAPTER_TOOLTIP_FONT = theme.font_chapter_tooltip or theme.font_text or "Inter",
    CHAPTER_TOOLTIP_FONT_SIZE = theme.chapter_tooltip_size or 18,
    CHAPTER_TOOLTIP_FONT_COLOR = common.bgr(theme.chapter_tooltip_text_color or "FFFFFF"),
    CHAPTER_TOOLTIP_FONT_ALPHA = theme.chapter_tooltip_text_alpha or "00",
    CHAPTER_MARK_COLOR = common.bgr(theme.color_chapter_mark or theme.background_color or "0A0C10"),
    CHAPTER_MARK_ALPHA = theme.alpha_chapter_mark or "20",
    CHAPTER_MARK_W = theme.chapter_mark_width or 2,
    CHAPTER_HOVER_PX = theme.chapter_hover_px or 8,
    CHAPTER_TOOLTIP_OFFSET_Y = theme.chapter_tooltip_offset_y or 36,
    CHAPTER_TOOLTIP_BG_COLOR = common.bgr(theme.chapter_tooltip_bg_color or theme.background_color or "0A0C10"),
    CHAPTER_TOOLTIP_BG_ALPHA = theme.chapter_tooltip_bg_alpha or "00",
    CHAPTER_TOOLTIP_RADIUS = theme.chapter_tooltip_radius or 8,
    CHAPTER_TOOLTIP_PAD_X = theme.chapter_tooltip_pad_x or 8,
    CHAPTER_TOOLTIP_PAD_Y = theme.chapter_tooltip_pad_y or 10,
}
local ICON = {
    play = "\238\128\183", -- U+E037
    pause = "\238\128\180", -- U+E034
    prev = "\238\129\133", -- U+E045
    next = "\238\129\132", -- U+E044
    stop = "\238\129\135", -- U+E047
    volume_up = "\238\129\144", -- U+E050
    volume_off = "\238\129\143", -- U+E04F
    add = "\238\133\133", -- U+E145
    fullscreen = "\238\151\144", -- U+E5D0
    seek_back = "\238\129\153", -- U+E059
    seek_forward = "\238\129\150",
    -- U+E056
    playlist = "\238\129\159", -- U+E05F
    add_file = "\238\137\141", -- U+E24D
    add_folder = "\238\139\140", -- U+E2CC
    add_url = "\238\133\151", -- U+E157
    subs = "\238\129\136", -- U+E048
    settings = "\238\162\184" -- U+E8B8 (tune/sliders)
}

--------------------------------------------------------------------------------
-- YOUTUBE CHAPTER LOADER
--------------------------------------------------------------------------------

local chapters_load_pending = false

local function load_youtube_chapters()
    if chapters_load_pending then
        return -- Already loading
    end
    local path = mp.get_property("path")
    if not path then
        return
    end
    if not (path:find("youtube%.com") or path:find("youtu%.be")) then
        return
    end
    chapters_load_pending = true
    mp.command_native_async(
        {
            name = "subprocess",
            playback_only = false,
            capture_stdout = true,
            args = {"yt-dlp", "-J", "--no-warnings", "--quiet", path}
        },
        function(success, result)
            chapters_load_pending = false
            if not success or not result or result.status ~= 0 or not result.stdout then
                msg.warn("yt-dlp failed or returned no data")
                return
            end
            local json = utils.parse_json(result.stdout)
            if json and json.chapters then
                local yt_chapters = {}
                for i, ch in ipairs(json.chapters) do
                    yt_chapters[#yt_chapters + 1] = {
                        time = ch.start_time,
                        title = ch.title or ("Chapter " .. i)
                    }
                end
                if #yt_chapters > 0 then
                    mp.set_property_native("chapter-list", yt_chapters)
                end
            end
        end
    )
end

mp.register_script_message("load-chapters-if-needed", function()
    local existing = mp.get_property_native("chapter-list", {})
    if #existing == 0 then
        load_youtube_chapters()
    end
end)

--------------------------------------------------------------------------------
-- STATE
--------------------------------------------------------------------------------

local osd = mp.create_osd_overlay("ass-events")
local screen_w, screen_h = mp.get_osd_size()
osd.res_x = screen_w
osd.res_y = screen_h
local mouse_x, mouse_y = -1, -1

local bar_visible = true
local hide_timer = nil
local file_loaded = false

local duration, position = 0, 0
local paused = true
local muted = false
local volume = 100

local volume_popup_open = false
local add_menu_open = false
local settings_menu_open = false
local volume_dragging = false
local volume_slider_dragging = false
local seek_dragging = false
local hitboxes = {}
local popup_geo = nil
local add_menu_geo = nil
local settings_menu_geo = nil
local chapters = {}
local hovered_chapter = nil
local settings_menu_scroll = 0
local settings_menu_max_scroll = 0
local last_subtitle_sid = nil
local last_osc_hover = nil
local settings_track_list_mode = nil
local settings_active_tab = nil
local render_timer = nil

--------------------------------------------------------------------------------
-- HELPERS
--------------------------------------------------------------------------------

local function fmt_time(t)
    if not t or t ~= t or t < 0 then
        return "00:00"
    end
    t = math.floor(t)
    local h = math.floor(t / 3600)
    local m = math.floor((t % 3600) / 60)
    local s = t % 60
    if h > 0 then
        return string.format("%d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end

local function utf8_char_count(str)
    local _, count = str:gsub("[^\128-\191]", "")
    return count
end

local function add_hitbox(name, x1, y1, x2, y2, cb)
    common.add_hitbox(hitboxes, name, x1, y1, x2, y2, cb)
end
local function point_in(px, py, b)
    return common.point_in(px, py, b)
end
local function draw_icon(ass, glyph, cx, cy, size, color, alpha)
    common.draw_icon(ass, cfg.ICON_FONT, glyph, cx, cy, size, color, alpha)
end

local function draw_time_label(ass, text, x, y, align)
    ass:new_event()
    ass:append(
        string.format(
            "{\\pos(%d,%d)\\an%d\\fn%s\\fs%d\\1c&H%s&\\1a&H10&" ..
                "\\3c&H%s&\\3a&H%s&\\bord%d\\shad%d\\xshad%d\\yshad%d" .. "\\4c&H%s&\\4a&H%s&\\b0}%s",
            x,
            y,
            align,
            cfg.UI_FONT,
            cfg.FONT_SIZE,
            cfg.TEXT,
            cfg.TIME_LABEL_OUTLINE_COLOR,
            cfg.TIME_LABEL_OUTLINE_ALPHA,
            cfg.TIME_LABEL_OUTLINE_WIDTH,
            cfg.TIME_LABEL_SHADOW,
            cfg.TIME_LABEL_SHADOW_X,
            cfg.TIME_LABEL_SHADOW_Y,
            cfg.TIME_LABEL_SHADOW_COLOR,
            cfg.TIME_LABEL_SHADOW_ALPHA,
            text
        )
    )
end

local function draw_volume_slider(ass, x, y)
    local slider_width = cfg.VOLUME_SLIDER_WIDTH

    local slider_x1

    if cfg.VOLUME_SLIDER_MUTE then
        local mute_width = cfg.VOLUME_SLIDER_MUTE_WIDTH
        local total_item_width =
            mute_width + cfg.VOLUME_SLIDER_MUTE_GAP + slider_width +
			cfg.VOLUME_SLIDER_PAD_LEFT + cfg.VOLUME_SLIDER_PAD_RIGHT

        local mute_x = x - total_item_width / 2 + mute_width / 2 + cfg.VOLUME_SLIDER_PAD_LEFT

        draw_icon(ass, muted and ICON.volume_off or ICON.volume_up, mute_x, y, cfg.ICON_SIZE, cfg.ICON_COLOR, "00")

        slider_x1 = x + total_item_width / 2 - slider_width - cfg.VOLUME_SLIDER_PAD_RIGHT
    else
        local total_item_width = slider_width + cfg.VOLUME_SLIDER_PAD_LEFT + cfg.VOLUME_SLIDER_PAD_RIGHT

        slider_x1 = x - total_item_width / 2 + cfg.VOLUME_SLIDER_PAD_LEFT
    end

    local slider_x2 = slider_x1 + slider_width

    local track_y1 = y - cfg.VOLUME_SLIDER_HEIGHT / 2
    local track_y2 = y + cfg.VOLUME_SLIDER_HEIGHT / 2

    local ratio = math.min(1, math.max(0, volume / 100))
    local thumb_x = slider_x1 + (slider_x2 - slider_x1) * ratio

    common.draw_rrect(
        ass,
        slider_x1,
        track_y1,
        slider_x2,
        track_y2,
        cfg.VOLUME_SLIDER_RADIUS,
        cfg.VOLUME_SLIDER_TRACK_COLOR,
        "00"
    )

    if thumb_x > slider_x1 then
        common.draw_rrect(ass, slider_x1, track_y1, thumb_x,
		track_y2, cfg.VOLUME_SLIDER_RADIUS, cfg.VOLUME_SLIDER_COLOR, "00")
    end

    common.draw_rrect(
        ass,
        thumb_x - cfg.VOLUME_SLIDER_THUMB_WIDTH,
        y - cfg.VOLUME_SLIDER_THUMB_HEIGHT,
        thumb_x + cfg.VOLUME_SLIDER_THUMB_WIDTH,
        y + cfg.VOLUME_SLIDER_THUMB_HEIGHT,
        cfg.VOLUME_SLIDER_THUMB_WIDTH,
        cfg.VOLUME_SLIDER_COLOR,
        "00"
    )
end

local function draw_item_background(ass, cx, cy, content_w)
    if not cfg.ICON_BG_ENABLED then
        return
    end
    common.draw_rrect(
        ass,
        cx - (content_w / 2 + cfg.ICON_BG_PAD_X),
        cy - cfg.ICON_BG_HEIGHT / 2,
        cx + (content_w / 2 + cfg.ICON_BG_PAD_X),
        cy + cfg.ICON_BG_HEIGHT / 2,
        cfg.ICON_BG_RADIUS,
        cfg.ICON_BG_COLOR,
        cfg.ICON_BG_ALPHA
    )
end

local function draw_rrect_outline(ass, x1, y1, x2, y2, radius, color, alpha, width)
    if not width or width <= 0 or alpha == "FF" then
        return
    end
    ass:new_event()
    ass:append(string.format("{\\pos(0,0)\\an7\\1a&HFF&\\3c&H%s&\\3a&H%s&\\bord%d\\shad0}", color, alpha, width))
    ass:draw_start()
    ass:round_rect_cw(x1, y1, x2, y2, radius)
    ass:draw_stop()
end

local function draw_item_border(ass, cx, cy, content_w)
    if not cfg.ICON_BORDER_ENABLED then
        return
    end
    local x1 = cx - (content_w / 2 + cfg.ICON_BG_PAD_X)
    local x2 = cx + (content_w / 2 + cfg.ICON_BG_PAD_X)
    local y1 = cy - cfg.ICON_BG_HEIGHT / 2
    local y2 = cy + cfg.ICON_BG_HEIGHT / 2
    draw_rrect_outline(ass, x1, y1, x2, y2, cfg.ICON_BG_RADIUS,
	cfg.ICON_BORDER_COLOR, cfg.ICON_BORDER_ALPHA, cfg.ICON_BORDER_WIDTH)
end

local function draw_icon_group_background(ass, buttons, row_y)
    if not cfg.ICON_GROUP_BG_ENABLED or #buttons == 0 then
        return
    end
    local x1 = math.huge
    local x2 = -math.huge
    for _, button in ipairs(buttons) do
        x1 = math.min(x1, button.x - button.width / 2 - cfg.ICON_BG_PAD_X)
        x2 = math.max(x2, button.x + button.width / 2 + cfg.ICON_BG_PAD_X)
    end
    x1 = x1 - cfg.ICON_GROUP_BG_PADDING
    x2 = x2 + cfg.ICON_GROUP_BG_PADDING
    local y1 = row_y - cfg.ICON_GROUP_BG_HEIGHT / 2
    local y2 = row_y + cfg.ICON_GROUP_BG_HEIGHT / 2
    common.draw_rrect(ass, x1, y1, x2, y2, cfg.ICON_GROUP_BG_RADIUS, cfg.ICON_GROUP_BG_COLOR, cfg.ICON_GROUP_BG_ALPHA)
    if cfg.ICON_GROUP_BORDER_ENABLED then
        draw_rrect_outline(
            ass,
            x1,
            y1,
            x2,
            y2,
            cfg.ICON_GROUP_BG_RADIUS,
            cfg.ICON_GROUP_BORDER_COLOR,
            cfg.ICON_GROUP_BORDER_ALPHA,
            cfg.ICON_GROUP_BORDER_WIDTH
        )
    end
end

local function playlist_script_loaded()
    return common.is_script_loaded("cadre_playlist")
end

local function run_playlist_action(action, fallback)
    if playlist_script_loaded() then
        mp.commandv("script-message", action)
    else
        mp.command(fallback)
    end
end

local DEFAULT_BUTTON_LAYOUT = {
    left = {"prev", "play", "next", "stop"},
    center = {},
    right = {"volume", "add", "settings", "subtitle", "fullscreen", "playlist"}
}

local function configured_button_layout()
    local layout = {left = {}, center = {}, right = {}}
    local configured = false
    local has_named_button = false

    for _, group in ipairs(
        {
            {name = "left", prefix = "L"},
            {name = "center", prefix = "C"},
            {name = "right", prefix = "R"}
        }
    ) do
        for i = 1, 6 do
            local value = theme["osc_" .. group.prefix .. i]
            if value ~= nil then
                configured = true
            end
            if type(value) == "string" and value ~= "" then
                has_named_button = true
                layout[group.name][#layout[group.name] + 1] = value
            end
        end
    end

    if not configured then
        return DEFAULT_BUTTON_LAYOUT, true
    end
    return layout, has_named_button
end

local function get_volume_slider_geometry(button)
    local slider_x1

    if cfg.VOLUME_SLIDER_MUTE then
        local mute_width = cfg.VOLUME_SLIDER_MUTE_WIDTH
        local total_item_width =
            mute_width + cfg.VOLUME_SLIDER_MUTE_GAP + cfg.VOLUME_SLIDER_WIDTH +
			cfg.VOLUME_SLIDER_PAD_LEFT + cfg.VOLUME_SLIDER_PAD_RIGHT

        slider_x1 = button.x + total_item_width / 2 - cfg.VOLUME_SLIDER_WIDTH - cfg.VOLUME_SLIDER_PAD_RIGHT
    else
        local total_item_width = cfg.VOLUME_SLIDER_WIDTH + cfg.VOLUME_SLIDER_PAD_LEFT + cfg.VOLUME_SLIDER_PAD_RIGHT

        slider_x1 = button.x - total_item_width / 2 + cfg.VOLUME_SLIDER_PAD_LEFT
    end

    return {
        slider_x1 = slider_x1,
        slider_x2 = slider_x1 + cfg.VOLUME_SLIDER_WIDTH
    }
end

local function set_volume_from_y(py, geo)
    local r = (geo.track_y2 - py) / (geo.track_y2 - geo.track_y1)
    mp.set_property_number("volume", math.min(1, math.max(0, r)) * 100)
end

local function set_volume_from_x(px, button)
    if not px or not button then
        return
    end

    local geo = get_volume_slider_geometry(button)
    local slider_w = geo.slider_x2 - geo.slider_x1

    local ratio = (px - geo.slider_x1) / slider_w
    ratio = math.min(1, math.max(0, ratio))

    mp.set_property_number("volume", ratio * 100)
end


local function get_subtitle_tracks()
    local all_tracks = mp.get_property_native("track-list", {})
    local tracks = {}
    for _, track in ipairs(all_tracks) do
        if track.type == "sub" then
            tracks[#tracks + 1] = track
        end
    end
    return tracks
end

local function subtitle_track_text(track, index)
    local title = track.title
    local language = track.lang
    if title and title ~= "" then
        return title, language
    end
    if language and language ~= "" then
        return language, nil
    end
    if track["external-filename"] and track["external-filename"] ~= "" then
        local filename = track["external-filename"]
        filename = filename:match("([^/\\]+)$") or filename
        filename = filename:gsub("%.[^%.]+$", "")
        if filename ~= "" then
            return filename, nil
        end
    end
    return "Track " .. tostring(index), nil
end

local BUTTONS = {
    prev = {
        icon = ICON.prev,
        click = function()
            run_playlist_action("playlist-prev", "playlist-prev")
        end
    },
    seek_back = {
        icon = ICON.seek_back,
        click = function()
            mp.commandv("seek", -10, "relative")
        end
    },
    play = {
        icon = function()
            return paused and ICON.play or ICON.pause
        end,
        click = function()
            mp.commandv("cycle", "pause")
        end
    },
    pause = {
        icon = ICON.pause,
        click = function()
            mp.set_property_bool("pause", true)
        end
    },
    seek_forward = {
        icon = ICON.seek_forward,
        click = function()
            mp.commandv("seek", 10, "relative")
        end
    },
    next = {
        icon = ICON.next,
        click = function()
            run_playlist_action("playlist-next", "playlist-next")
        end
    },
    stop = {
        icon = ICON.stop,
        click = function()
            mp.commandv("stop", "keep-playlist")
        end
    },
    volume = {
        icon = function()
            return (muted or volume == 0) and ICON.volume_off or ICON.volume_up
        end,
        click = function()
            volume_popup_open = not volume_popup_open
            add_menu_open = false
        end
    },
    volume_slider = {
        kind = "volume_slider",
        click = function(px, _, button)
            if not button then
                return
            end

            volume_slider_dragging = true
            set_volume_from_x(px, button)
        end
    },
    mute = {
        icon = function()
            return muted and ICON.volume_off or ICON.volume_up
        end,
        click = function()
            mp.commandv("cycle", "mute")
        end
    },
    add = {
        icon = ICON.add,
        click = function()
            add_menu_open = not add_menu_open
            volume_popup_open = false
        end
    },
    fullscreen = {
        icon = ICON.fullscreen,
        click = function()
            mp.commandv("cycle", "fullscreen")
        end
    },
    playlist = {
        icon = ICON.playlist,
        alpha = function()
            return mp.get_property_native("user-data/cadre_playlist/visible", false) and "00" or "60"
        end,
        click = function()
            run_playlist_action("toggle-playlist", "show-text ${playlist}")
        end
    },
    time = {
        kind = "time",
        click = function()
        end
    },
    subtitle = {
        icon = ICON.subs,

        alpha = function()
            local sid = mp.get_property_native("sid")
            local visible = mp.get_property_bool("sub-visibility", true)
            if sid == nil or sid == "no" then
                return "60"
            end
            for _, track in ipairs(mp.get_property_native("track-list", {})) do
                if track.type == "sub" and track.id == sid then
                    return visible and "00" or "60"
                end
            end
            return "60"
        end,
        click = function()
            local sid = mp.get_property_native("sid")
            local has_selected_track = sid ~= nil and sid ~= "no"
            if has_selected_track then
                mp.commandv("cycle", "sub-visibility")
                return
            end
            if last_subtitle_sid ~= nil then
                for _, track in ipairs(get_subtitle_tracks()) do
                    if track.id == last_subtitle_sid then
                        mp.set_property_number("sid", last_subtitle_sid)
                        mp.set_property_bool("sub-visibility", true)
                        return
                    end
                end
            end
            local tracks = get_subtitle_tracks()
            if #tracks == 0 then
                return
            end
            last_subtitle_sid = tracks[1].id
            mp.set_property_number("sid", last_subtitle_sid)
            mp.set_property_bool("sub-visibility", true)
        end
    },
    settings = {
        icon = ICON.settings,
        click = function()
            settings_menu_open = not settings_menu_open
            volume_popup_open = false
            add_menu_open = false

            if settings_menu_open then
                settings_active_tab = "video"
                settings_menu_scroll = 0
            end
        end
    }
}

local function normalize_chapters(raw)
    local out = {}
    if type(raw) ~= "table" then
        return out
    end
    for i, c in ipairs(raw) do
        local t = c.time
        if type(t) == "number" then
            out[#out + 1] = {
                time = t,
                title = (c.title and c.title ~= "" and c.title) or ("Chapter " .. i)
            }
        end
    end
    table.sort(
        out,
        function(a, b)
            return a.time < b.time
        end
    )
    return out
end

local function ratio_to_x(bar_x1, bar_w, ratio)
    return bar_x1 + bar_w * math.min(1, math.max(0, ratio))
end

local function draw_chapter_marks(ass, bar_x1, bar_x2, bar_w, seek_y, track_h, dur)
    if not dur or dur <= 0 or #chapters == 0 then
        return
    end
    local half_h = track_h / 2
    for _, c in ipairs(chapters) do
        if c.time > 0 and c.time < dur then
            local cx = ratio_to_x(bar_x1, bar_w, c.time / dur)
            local mx1 = math.max(bar_x1, cx - cfg.CHAPTER_MARK_W)
            local mx2 = math.min(bar_x2, cx + cfg.CHAPTER_MARK_W)
            if mx2 > mx1 then
                common.draw_rrect(
                    ass,
                    mx1,
                    seek_y - half_h,
                    mx2,
                    seek_y + half_h,
                    0,
                    cfg.CHAPTER_MARK_COLOR,
                    cfg.CHAPTER_MARK_ALPHA
                )
            end
        end
    end
end

local function find_hovered_chapter(bar_x1, bar_w, dur, px)
    if not dur or dur <= 0 or #chapters == 0 then
        return nil
    end
    for _, c in ipairs(chapters) do
        if c.time > 0 and c.time < dur then
            local cx = ratio_to_x(bar_x1, bar_w, c.time / dur)
            if math.abs(px - cx) <= cfg.CHAPTER_HOVER_PX then
                return c
            end
        end
    end
    return nil
end

local function button_dimensions(id)
    if id == "time" then
        return cfg.TIME_ITEM_WIDTH, cfg.FONT_SIZE
    end

    if id == "volume_slider" then
        local width = cfg.VOLUME_SLIDER_WIDTH + cfg.VOLUME_SLIDER_PAD_LEFT + cfg.VOLUME_SLIDER_PAD_RIGHT

        if cfg.VOLUME_SLIDER_MUTE then
            width =
                cfg.VOLUME_SLIDER_MUTE_WIDTH + cfg.VOLUME_SLIDER_MUTE_GAP +
				cfg.VOLUME_SLIDER_WIDTH + cfg.VOLUME_SLIDER_PAD_LEFT +
                cfg.VOLUME_SLIDER_PAD_RIGHT
        end

        local height = math.max(cfg.VOLUME_SLIDER_HEIGHT, cfg.VOLUME_SLIDER_THUMB_HEIGHT, cfg.ICON_SIZE)

        return width, height
    end

    return cfg.ICON_SIZE, cfg.ICON_SIZE
end

--------------------------------------------------------------------------------
-- LAYOUT
--------------------------------------------------------------------------------

local function get_layout()
    local natural_x1 = cfg.BAR_SIDE_INSET
    local natural_x2 = screen_w - cfg.BAR_SIDE_INSET
    local natural_w = natural_x2 - natural_x1
    local BAR_MAX_WIDTH = theme.max_bar_width_osc or screen_w

    local pill_x1, pill_x2
    if natural_w > BAR_MAX_WIDTH then
        local cx = screen_w / 2
        pill_x1 = cx - BAR_MAX_WIDTH / 2
        pill_x2 = cx + BAR_MAX_WIDTH / 2
    else
        pill_x1 = natural_x1
        pill_x2 = natural_x2
    end

    local pill_y1, pill_y2
    if cfg.BAR_Y_ANCHOR == "top" then
        pill_y1 = cfg.BAR_TOP_INSET
        pill_y2 = pill_y1 + cfg.BAR_HEIGHT
    elseif cfg.BAR_Y_ANCHOR == "center" then
        pill_y1 = (screen_h - cfg.BAR_HEIGHT) / 2
        pill_y2 = pill_y1 + cfg.BAR_HEIGHT
    else
        pill_y2 = screen_h - cfg.BAR_BOTTOM_INSET
        pill_y1 = pill_y2 - cfg.BAR_HEIGHT
    end

    local seek_y = pill_y1 + cfg.SEEK_Y_OFFSET
    local row_y = cfg.BUTTON_Y_ANCHOR == "bottom" and pill_y2 - cfg.BUTTON_ROW_OFFSET or pill_y1 + cfg.BUTTON_ROW_OFFSET
    local spacing = cfg.ICON_SPACING

    local seek_x1, seek_x2 = pill_x1 + cfg.SEEK_SIDE_INSET, pill_x2 - cfg.SEEK_SIDE_INSET
    local button_x1, button_x2 = pill_x1 + cfg.BUTTON_LEFT_INSET, pill_x2 - cfg.BUTTON_RIGHT_INSET

    local button_layout, has_named_button = configured_button_layout()
    local positions = {left = {}, center = {}, right = {}, by_id = {}}

    local function valid_group_buttons(group)
        local valid = {}
        for _, id in ipairs(button_layout[group]) do
            if BUTTONS[id] then
                valid[#valid + 1] = id
            else
                msg.warn("cadre_osc: unknown button '" .. id .. "' in " .. group .. " layout")
            end
        end
        return valid
    end

    local function place_group(group, first_edge, direction)
        local ids = valid_group_buttons(group)
        local cursor = first_edge
        local gap = math.max(0, spacing - cfg.ICON_SIZE)
        for index = 1, #ids do
            local id = direction < 0 and ids[#ids - index + 1] or ids[index]
            local width, height = button_dimensions(id)
            local x = direction > 0 and cursor + width / 2 or cursor - width / 2
            local button = {id = id, x = x, width = width, height = height}
            positions[group][#positions[group] + 1] = button
            positions.by_id[id] = button.x
            if direction > 0 then
                cursor = cursor + width + gap
            else
                cursor = cursor - width - gap
            end
        end
    end

    local function place_all_groups()
        place_group("left", button_x1, 1)
        place_group("right", button_x2, -1)

        local center_ids = valid_group_buttons("center")
        local center_width = 0
        local center_gap = math.max(0, spacing - cfg.ICON_SIZE)
        for _, id in ipairs(center_ids) do
            local width = button_dimensions(id)
            center_width = center_width + width
        end
        center_width = center_width + math.max(0, #center_ids - 1) * center_gap
        place_group("center", screen_w / 2 - center_width / 2, 1)
    end

    place_all_groups()
    if has_named_button and #positions.left == 0 and #positions.center == 0 and #positions.right == 0 then
        msg.warn("cadre_osc: no valid configured buttons; using default layout")
        button_layout = DEFAULT_BUTTON_LAYOUT
        positions = {left = {}, center = {}, right = {}, by_id = {}}
        place_all_groups()
    end

    return {
        pill_x1 = pill_x1,
        pill_x2 = pill_x2,
        pill_y1 = pill_y1,
        pill_y2 = pill_y2,
        seek_x1 = seek_x1,
        seek_x2 = seek_x2,
        button_x1 = button_x1,
        button_x2 = button_x2,
        seek_y = seek_y,
        row_y = row_y,
        buttons = positions
    }
end

--------------------------------------------------------------------------------
-- VOLUME FLYOUT
--------------------------------------------------------------------------------

local function compute_popup_geo(L)
    local card_w, card_h = 44, 158
    local cx = L.buttons.by_id.volume
    if not cx then
        return nil
    end
    local card_x1, card_x2 = cx - card_w / 2, cx + card_w / 2
    local card_y2 = L.pill_y1 - 10
    local card_y1 = card_y2 - card_h
    local track_y1, track_y2 = card_y1 + 18, card_y2 - 54
    local mute_y = card_y2 - 18
    return {
        cx = cx,
        card_x1 = card_x1,
        card_x2 = card_x2,
        card_y1 = card_y1,
        card_y2 = card_y2,
        track_y1 = track_y1,
        track_y2 = track_y2,
        mute_y = mute_y
    }
end

local function render_volume_popup(ass, geo)
    common.draw_rrect(ass, geo.card_x1, geo.card_y1, geo.card_x2, geo.card_y2, 10, cfg.BARBG, "10")

    ass:new_event()
    ass:append(string.format("{\\pos(0,0)\\an7\\1c&H%s&\\1a&H00&\\bord0\\shad0}", cfg.SLIDER_RAIL))
    ass:draw_start()
    ass:round_rect_cw(geo.cx - 2, geo.track_y1, geo.cx + 2, geo.track_y2, 2)
    ass:draw_stop()

    local vol_ratio = math.min(1, math.max(0, volume / 100))
    local fill_y1 = geo.track_y2 - (geo.track_y2 - geo.track_y1) * vol_ratio

    common.draw_rrect(ass, geo.cx - 2, fill_y1, geo.cx + 2, geo.track_y2, 2, cfg.TRACK_FG, "00")

    ass:new_event()
    ass:append("{\\pos(0,0)\\an7\\1c&HFFFFFF&\\1a&H00&\\bord0\\shad0}")
    ass:draw_start()
    ass:round_rect_cw(geo.cx - 6, fill_y1 - 6, geo.cx + 6, fill_y1 + 6, 6)
    ass:draw_stop()

    common.draw_text(ass, math.floor(volume) .. "%", geo.cx, geo.card_y2 - 38, cfg.FONT_SIZE, cfg.TEXT, "10", 2, false)

    draw_icon(
        ass,
        muted and ICON.volume_off or ICON.volume_up,
        geo.cx,
        geo.mute_y,
        18,
        cfg.ICON_COLOR,
        muted and "00" or "40"
    )

    add_hitbox(
        "volume_mute",
        geo.cx - 16,
        geo.mute_y - 14,
        geo.cx + 16,
        geo.mute_y + 14,
        function()
            mp.commandv("cycle", "mute")
        end
    )

    add_hitbox(
        "volume_track",
        geo.cx - 14,
        geo.track_y1 - 12,
        geo.cx + 14,
        geo.track_y2 + 12,
        function(_, py)
            volume_dragging = true
            set_volume_from_y(py, geo)
        end
    )
    add_hitbox(
        "volume_card_bg",
        geo.card_x1,
        geo.card_y1,
        geo.card_x2,
        geo.card_y2,
        function()
        end
    )
end

--------------------------------------------------------------------------------
-- ADD-FILE FLYOUT MENU
--------------------------------------------------------------------------------

local function compute_add_menu_geo(L)
    local card_w, card_h = 190, 3 * 36 + 12
    local cx = L.buttons.by_id.add
    if not cx then
        return nil
    end
    local card_x1, card_x2 = cx - card_w / 2, cx + card_w / 2
    local card_y2 = L.pill_y1 - 10
    local card_y1 = card_y2 - card_h
    return {cx = cx, card_x1 = card_x1, card_x2 = card_x2, card_y1 = card_y1, card_y2 = card_y2, row_h = 36}
end

local function render_add_menu(ass, geo)
    common.draw_rrect(ass, geo.card_x1, geo.card_y1, geo.card_x2, geo.card_y2, 10, cfg.BARBG, "10")

    local entries = {
        {label = "Add file", icon = ICON.add_file, cb = common.do_add_file},
        {label = "Add folder", icon = ICON.add_folder, cb = common.do_add_folder},
        {label = "Add URL", icon = ICON.add_url, cb = common.do_add_url}
    }

    for i, e in ipairs(entries) do
        local row_y1 = geo.card_y1 + 6 + (i - 1) * geo.row_h
        local row_y2 = row_y1 + geo.row_h
        local mid_y = (row_y1 + row_y2) / 2
        draw_icon(ass, e.icon, geo.card_x1 + 24, mid_y, 16, cfg.ICON_COLOR, cfg.ICON_DIM_A)
        common.draw_text(ass, e.label, geo.card_x1 + 42, mid_y, 16, cfg.TEXT, "00", 4, false)
        add_hitbox(
            "add_menu_" .. i,
            geo.card_x1,
            row_y1,
            geo.card_x2,
            row_y2,
            function()
                add_menu_open = false
                e.cb()
            end
        )
    end
end

--------------------------------------------------------------------------------
-- UNIFIED SETTINGS DIALOG
--------------------------------------------------------------------------------

local SET_MENU_WIDTH   = 380
local SET_MENU_HEIGHT  = 500
local SET_MENU_PAD     = 18
local SET_MENU_RADIUS  = 14
local SET_MENU_ROW_H   = 38
local SET_MENU_HEADER_H = 52
local SET_MENU_TAB_H   = 40
local SET_MENU_FOOTER_H = 46
local SET_MENU_SECTION_TITLE_H = 30

-- Compute the geometry for the unified settings panel.
local function compute_settings_menu_geo()
    local margin = 20
    local card_w = math.min(SET_MENU_WIDTH, screen_w - margin * 2)
    local card_h = math.min(SET_MENU_HEIGHT, screen_h - margin * 2)
    local card_x1 = math.floor((screen_w - card_w) / 2)
    local card_y1 = math.floor((screen_h - card_h) / 2)
    local card_x2 = card_x1 + card_w
    local card_y2 = card_y1 + card_h

    local cx1 = card_x1 + SET_MENU_PAD
    local cx2 = card_x2 - SET_MENU_PAD

    local header_y1 = card_y1
    local header_y2 = header_y1 + SET_MENU_HEADER_H
    local tab_y1    = header_y2
    local tab_y2    = tab_y1 + SET_MENU_TAB_H
    local footer_y1 = card_y2 - SET_MENU_FOOTER_H
    local footer_y2 = card_y2
    local body_y1   = tab_y2 + 4
    local body_y2   = footer_y1 - 4

    return {
        card_x1 = card_x1, card_x2 = card_x2,
        card_y1 = card_y1, card_y2 = card_y2,
        cx1 = cx1, cx2 = cx2,
        header_y1 = header_y1, header_y2 = header_y2,
        tab_y1 = tab_y1, tab_y2 = tab_y2,
        body_y1 = body_y1, body_y2 = body_y2,
        footer_y1 = footer_y1, footer_y2 = footer_y2,
    }
end

-- Thin separator line.
local function draw_sep(ass, geo, y)
    common.draw_rrect(ass, geo.cx1, y, geo.cx2, y + 1, 0, cfg.TRACK_BG, "50")
end

-- Small +/- stepper button.
local function draw_step_btn(ass, x, y, symbol)
    common.draw_rrect(ass, x - 14, y - 14, x + 14, y + 14, 7, cfg.TRACK_BG, "20")
    common.draw_text(ass, symbol, x, y, cfg.FONT_SIZE + 1, cfg.TEXT, "00", 5, false)
end

-- A full label | [−] value [+] row. Returns the row bottom y.
local function draw_step_row(ass, geo, row_y, label, value_str,
                              minus_name, minus_cb, plus_name, plus_cb)
    local cy        = row_y + SET_MENU_ROW_H / 2
    local RPAD      = 16
    local minus_x   = geo.cx2 - RPAD - 84
    local val_x     = geo.cx2 - RPAD - 42
    local plus_x    = geo.cx2 - RPAD - 2

    common.draw_text(ass, label,     geo.cx1, cy, cfg.FONT_SIZE - 1, cfg.TEXT, "00", 4, false)
    draw_step_btn(ass, minus_x, cy, "−")
    draw_step_btn(ass, plus_x,  cy, "+")
    common.draw_text(ass, value_str, val_x,    cy, cfg.FONT_SIZE - 1, cfg.TEXT, "00", 5, false)

    add_hitbox(minus_name, minus_x - 18, row_y, minus_x + 18, row_y + SET_MENU_ROW_H, minus_cb)
    add_hitbox(plus_name,  plus_x  - 18, row_y, plus_x  + 18, row_y + SET_MENU_ROW_H, plus_cb)
end


local measure_osd = mp.create_osd_overlay("ass-events")
    measure_osd.hidden = true
    measure_osd.compute_bounds = true

local function measure_text_width(text, font_size, font)
    local f = font or cfg.UI_FONT
    local osd_w, osd_h = mp.get_osd_size()

    measure_osd.res_x = osd_w
    measure_osd.res_y = osd_h

    measure_osd.data =
        string.format(
        "{\\pos(1000,1000)\\an5\\fn%s\\fs%d" .. "\\1c&HFFFFFF&\\1a&H00&\\bord0\\shad0\\b0}%s",
        f,
        font_size,
        text
    )

    local res = measure_osd:update()

    if res and res.x0 and res.x1 then
        return res.x1 - res.x0
    end

    -- Fallback only if libass does not return bounds.
    return utf8_char_count(text) * font_size * 0.5
end

-- Scrollable subtitle track list row.
local function draw_subtitle_track_row(ass, geo, row_y, title, language, selected, hbname, cb)
    local vy1 = math.max(row_y, geo.body_y1)
    local vy2 = math.min(row_y + SET_MENU_ROW_H, geo.body_y2)

    if vy2 - vy1 < SET_MENU_ROW_H then
        return
    end
    local center = row_y + SET_MENU_ROW_H / 2

    -- Measure how much space language will take
    local lang_w = 0
    if language and language ~= "" then
        lang_w = measure_text_width(language, cfg.FONT_SIZE - 2, cfg.UI_FONT)
    end

    local text_start = geo.cx1 + 40
    local right_margin = 12
    local max_title_w = math.max(20, geo.cx2 - right_margin - text_start - lang_w)

    -- Width-safe truncation
    local safe_title = title
    if measure_text_width(title, cfg.FONT_SIZE - 1, cfg.UI_FONT) > max_title_w then
        local lo, hi = 0, utf8_char_count(title)
        while lo < hi do
            local mid = math.ceil((lo + hi) / 2)
            local cand = title:sub(1, mid) .. "…"
            if measure_text_width(cand, cfg.FONT_SIZE - 1, cfg.UI_FONT) <= max_title_w then
                lo = mid
            else
                hi = mid - 1
            end
        end
        safe_title = title:sub(1, lo) .. "…"
    end

    if selected then
        common.draw_rrect(ass, geo.cx1, vy1 + 2, geo.cx2 - 8, vy2 - 2, 6, cfg.TRACK_FG, "D0")
    end

    common.draw_text(ass, selected and "●" or "○", geo.cx1 + 14, center,
        cfg.FONT_SIZE, selected and cfg.TRACK_FG or cfg.ICON_COLOR,
        selected and "00" or cfg.ICON_DIM_A, 5, false)

    common.draw_text(ass, safe_title, text_start, center,
        cfg.FONT_SIZE - 1, cfg.TEXT, "00", 4, false)

    if language and language ~= "" then
        common.draw_text(ass, language, geo.cx2 - 12, center,
            cfg.FONT_SIZE - 2, cfg.TEXT, "35", 6, false)
    end

    add_hitbox(hbname, geo.cx1, vy1, geo.cx2, vy2, cb)
end

-- Section heading inside a tab body.
local function draw_section_title(ass, geo, y, text)
    common.draw_text(
        ass, text, geo.cx1, y + SET_MENU_SECTION_TITLE_H / 2,
        cfg.FONT_SIZE - 2, cfg.TEXT, "40", 4, false
    )
end

-- Subtitles tab
local function render_subtitles_tab(ass, geo)
    local sub_delay   = mp.get_property_number("sub-delay",        0)    or 0
    local sub_scale   = mp.get_property_number("sub-scale",        1.0)  or 1.0
    local sub_pos     = mp.get_property_number("sub-pos",          100)  or 100
    local sub_outline = mp.get_property_number("sub-outline-size", 1.65) or 0
    local sub_shadow  = mp.get_property_number("sub-shadow-offset",0)    or 0

    local y = geo.body_y1 + 2

    draw_step_row(ass, geo, y,
        "Delay",   string.format("%.1f s", sub_delay),
        "set_sub_delay_minus",  function() mp.commandv("add", "sub-delay", -0.1) end,
        "set_sub_delay_plus",   function() mp.commandv("add", "sub-delay",  0.1) end)
    y = y + SET_MENU_ROW_H

    draw_step_row(ass, geo, y,
        "Scale",   string.format("%d%%", math.floor(sub_scale * 100 + 0.5)),
        "set_sub_scale_minus",  function() mp.set_property_number("sub-scale", math.max(0.5, sub_scale - 0.1)) end,
        "set_sub_scale_plus",   function() mp.set_property_number("sub-scale", math.min(3.0, sub_scale + 0.1)) end)
    y = y + SET_MENU_ROW_H

    draw_step_row(ass, geo, y,
        "Position", string.format("%d%%", math.floor(sub_pos + 0.5)),
        "set_sub_pos_minus",
        function() mp.set_property_number("sub-pos", math.max(0,   sub_pos - 1)) end,
        "set_sub_pos_plus",
        function() mp.set_property_number("sub-pos", math.min(150, sub_pos + 1)) end)
    y = y + SET_MENU_ROW_H

    draw_step_row(ass, geo, y,
        "Outline",  string.format("%.2f", sub_outline),
        "set_sub_outline_minus",
        function() mp.set_property_number("sub-outline-size", math.max(0,  sub_outline - 0.15)) end,
        "set_sub_outline_plus",
        function() mp.set_property_number("sub-outline-size", math.min(10, sub_outline + 0.15)) end)
    y = y + SET_MENU_ROW_H

    draw_step_row(ass, geo, y,
        "Shadow",   string.format("%.1f", sub_shadow),
        "set_sub_shadow_minus",
        function() mp.set_property_number("sub-shadow-offset", math.max(0,  sub_shadow - 0.5)) end,
        "set_sub_shadow_plus",
        function() mp.set_property_number("sub-shadow-offset", math.min(10, sub_shadow + 0.5)) end)
    y = y + SET_MENU_ROW_H

    draw_sep(ass, geo, y + 2)
    y = y + 10

    -- Tracks section heading
    draw_section_title(ass, geo, y, "Tracks")
    y = y + SET_MENU_SECTION_TITLE_H
    draw_sep(ass, geo, y)
    y = y + 2

    -- Scrollable track list
    local sub_tracks = get_subtitle_tracks()
    local current_sid_native = mp.get_property_native("sid")
    local current_sid = mp.get_property("sid")

    local track_area_y1 = y

    local track_area_y2 = geo.footer_y1 - 10

    if track_area_y2 < track_area_y1 + SET_MENU_ROW_H then
        track_area_y2 = track_area_y1 + SET_MENU_ROW_H
    end

    local list_h = track_area_y2 - track_area_y1
    local visible_rows = math.max(
        1,
        math.floor(list_h / SET_MENU_ROW_H)
    )

    local total_rows = #sub_tracks + 1

    settings_menu_max_scroll = math.max(
        0,
        total_rows - visible_rows
    )

    settings_menu_scroll = math.max(
        0,
        math.min(settings_menu_scroll, settings_menu_max_scroll)
    )

    local first_y = track_area_y1 - settings_menu_scroll * SET_MENU_ROW_H

    local sub_geo = {
        cx1 = geo.cx1,
        cx2 = geo.cx2,
        body_y1 = track_area_y1,
        body_y2 = track_area_y2,
    }

    local disabled = (current_sid == "no")

    draw_subtitle_track_row(
        ass,
        sub_geo,
        first_y,
        "Disable subtitles",
        nil,
        disabled,
        "set_sub_disable",
        function()
            mp.set_property("sid", "no")
        end
    )

    for i, track in ipairs(sub_tracks) do
        local row_y = first_y + i * SET_MENU_ROW_H
        local title, language = subtitle_track_text(track, i)

        draw_subtitle_track_row(
            ass,
            sub_geo,
            row_y,
            title,
            language,
            current_sid_native == track.id,
            "set_sub_track_" .. i,
            function()
                last_subtitle_sid = track.id
                mp.set_property_number("sid", track.id)
                mp.set_property_bool("sub-visibility", true)
            end
        )
    end

    if settings_menu_max_scroll > 0 then
        local sb_x1 = geo.cx2 - 5
        local sb_x2 = geo.cx2 - 2

        common.draw_rrect(
            ass,
            sb_x1,
            track_area_y1 + 2,
            sb_x2,
            track_area_y2 - 2,
            2,
            cfg.TRACK_BG,
            "30"
        )

        local thumb_h = math.max(
            20,
            list_h * visible_rows / total_rows
        )

        local thumb_y =
            track_area_y1 +
            (list_h - thumb_h) *
            settings_menu_scroll / settings_menu_max_scroll

        common.draw_rrect(
            ass,
            sb_x1 - 1,
            thumb_y,
            sb_x2 + 1,
            thumb_y + thumb_h,
            3,
            cfg.TRACK_FG,
            "00"
        )
    end
end

-- Video tab
local function render_video_tab(ass, geo)
    if not settings_track_list_mode then
        settings_track_list_mode = "audio"
    end

    local speed = mp.get_property_number("speed", 1.0) or 1.0
    local keepasp = mp.get_property_bool("keepaspect", true)
    local unscaled = mp.get_property("video-unscaled") or "no"
    local aspect = mp.get_property_number("video-aspect-override", -1) or -1

    local y = geo.body_y1 + 4

    -- Speed
    draw_step_row(
        ass,
        geo,
        y,
        "Speed",
        string.format("%.2fx", speed),
        "set_speed_minus",
        function()
            mp.set_property_number("speed", math.max(0.25, speed - 0.25))
        end,
        "set_speed_plus",
        function()
            mp.set_property_number("speed", math.min(4.0, speed + 0.25))
        end
    )

    y = y + SET_MENU_ROW_H
    draw_sep(ass, geo, y + 2)
    y = y + 6

    -- Aspect Ratio
    draw_section_title(ass, geo, y, "Aspect Ratio")
    y = y + SET_MENU_SECTION_TITLE_H

    local asp_choices = {
        {label = "Auto", value = -1, current = aspect < 0},
        {label = "4:3", value = 4 / 3, current = math.abs(aspect - 4 / 3) < 0.02},
        {label = "16:9", value = 16 / 9, current = math.abs(aspect - 16 / 9) < 0.02},
        {label = "2.39:1", value = 2.39, current = math.abs(aspect - 2.39) < 0.02},
    }

    local chip_w = 62
    local chip_h = 26
    local chip_gap = 6
    local chip_cy = y + SET_MENU_ROW_H / 2
    local total_w = #asp_choices * chip_w + (#asp_choices - 1) * chip_gap
    local start_x = geo.cx2 - total_w - 14

    for i, choice in ipairs(asp_choices) do
        local cx = start_x + (i - 1) * (chip_w + chip_gap) + chip_w / 2
        local x1 = cx - chip_w / 2
        local x2 = cx + chip_w / 2
        local y1 = chip_cy - chip_h / 2
        local y2 = chip_cy + chip_h / 2

        if choice.current then
            common.draw_rrect(ass, x1, y1, x2, y2, 6, cfg.TRACK_FG, "D0")
            common.draw_text(ass, choice.label, cx, chip_cy,
                cfg.FONT_SIZE - 3, cfg.TEXT, "00", 5, false)
        else
            common.draw_rrect(ass, x1, y1, x2, y2, 6, cfg.TRACK_BG, "20")
            common.draw_text(ass, choice.label, cx, chip_cy,
                cfg.FONT_SIZE - 3, cfg.TEXT, "30", 5, false)
        end

        local value = choice.value

        add_hitbox(
            "set_asp_" .. i,
            x1,
            y,
            x2,
            y + SET_MENU_ROW_H,
            function()
                if value < 0 then
                    mp.set_property("video-aspect-override", "-1")
                else
                    mp.set_property_number("video-aspect-override", value)
                end
            end
        )
    end

    y = y + SET_MENU_ROW_H
    draw_sep(ass, geo, y + 2)
    y = y + 12

    -- Display Mode
    draw_section_title(ass, geo, y, "Display Mode")
    y = y + SET_MENU_SECTION_TITLE_H

    local is_unscaled = unscaled ~= "no" and unscaled ~= "" and unscaled ~= false
    local is_fill = not is_unscaled and not keepasp
    local is_normal = not is_unscaled and keepasp

    local display_choices = {
        {label = "Normal", current = is_normal},
        {label = "Fill", current = is_fill},
        {label = "Unscaled", current = is_unscaled},
    }

    local display_chip_w = 74
    local display_chip_h = 26
    local display_chip_gap = 6
    local display_cy = y + SET_MENU_ROW_H / 2
    local display_total_w =
        #display_choices * display_chip_w +
        (#display_choices - 1) * display_chip_gap
    local display_start_x = geo.cx2 - display_total_w - 14

    for i, choice in ipairs(display_choices) do
        local cx =
            display_start_x +
            (i - 1) * (display_chip_w + display_chip_gap) +
            display_chip_w / 2

        local x1 = cx - display_chip_w / 2
        local x2 = cx + display_chip_w / 2
        local y1 = display_cy - display_chip_h / 2
        local y2 = display_cy + display_chip_h / 2

        if choice.current then
            common.draw_rrect(ass, x1, y1, x2, y2, 6, cfg.TRACK_FG, "D0")
            common.draw_text(ass, choice.label, cx, display_cy,
                cfg.FONT_SIZE - 3, cfg.TEXT, "00", 5, false)
        else
            common.draw_rrect(ass, x1, y1, x2, y2, 6, cfg.TRACK_BG, "20")
            common.draw_text(ass, choice.label, cx, display_cy,
                cfg.FONT_SIZE - 3, cfg.TEXT, "30", 5, false)
        end

        local index = i

        add_hitbox(
            "set_display_" .. i,
            x1,
            y,
            x2,
            y + SET_MENU_ROW_H,
            function()
                if index == 1 then
                    mp.set_property_bool("keepaspect", true)
                    mp.set_property("video-unscaled", "no")
                elseif index == 2 then
                    mp.set_property_bool("keepaspect", false)
                    mp.set_property("video-unscaled", "no")
                else
                    mp.set_property_bool("keepaspect", true)
                    mp.set_property("video-unscaled", "yes")
                end
            end
        )
    end

    y = y + SET_MENU_ROW_H
    draw_sep(ass, geo, y + 2)
    y = y + 2

    local audio_tracks = {}

    for _, track in ipairs(mp.get_property_native("track-list", {})) do
        if track.type == "audio" then
            audio_tracks[#audio_tracks + 1] = track
        end
    end

    local editions = mp.get_property_native("edition-list", {}) or {}

    -- Audio / Editions tabs
    local tab_y1 = y
    local tab_y2 = y + SET_MENU_TAB_H
    local tab_w = (geo.cx2 - geo.cx1) / 2
    local tab_cy = (tab_y1 + tab_y2) / 2

    local audio_tab_x1 = geo.cx1
    local audio_tab_x2 = audio_tab_x1 + tab_w

    local edition_tab_x1 = audio_tab_x2
    local edition_tab_x2 = geo.cx2

    local audio_active = settings_track_list_mode == "audio"
    local edition_active = settings_track_list_mode == "edition"

    -- Audio tab text
    common.draw_text(
        ass,
        "Audio (" .. tostring(#audio_tracks) .. ")",
        (audio_tab_x1 + audio_tab_x2) / 2,
        tab_cy,
        cfg.FONT_SIZE - 1,
        audio_active and cfg.TRACK_FG or cfg.TEXT,
        audio_active and "00" or "40",
        5,
        false
    )

    -- Editions tab text
    common.draw_text(
        ass,
        "Editions (" .. tostring(#editions) .. ")",
        (edition_tab_x1 + edition_tab_x2) / 2,
        tab_cy,
        cfg.FONT_SIZE - 1,
        edition_active and cfg.TRACK_FG or cfg.TEXT,
        edition_active and "00" or "40",
        5,
        false
    )

    -- Accent underline for active tab
    if audio_active then
        common.draw_rrect(
            ass,
            audio_tab_x1 + 8,
            tab_y2 - 3,
            audio_tab_x2 - 8,
            tab_y2,
            1,
            cfg.TRACK_FG,
            "00"
        )
    else
        common.draw_rrect(
            ass,
            edition_tab_x1 + 8,
            tab_y2 - 3,
            edition_tab_x2 - 8,
            tab_y2,
            1,
            cfg.TRACK_FG,
            "00"
        )
    end

    draw_sep(ass, geo, tab_y2)

    add_hitbox(
        "set_selector_audio",
        audio_tab_x1,
        tab_y1,
        audio_tab_x2,
        tab_y2,
        function()
            settings_track_list_mode = "audio"
            settings_menu_scroll = 0
        end
    )

    add_hitbox(
        "set_selector_edition",
        edition_tab_x1,
        tab_y1,
        edition_tab_x2,
        tab_y2,
        function()
            settings_track_list_mode = "edition"
            settings_menu_scroll = 0
        end
    )

    y = tab_y2 + 1

    local list_y1 = y
    local list_y2 = geo.body_y2
    local list_geo = {
        cx1 = geo.cx1,
        cx2 = geo.cx2,
        body_y1 = list_y1,
        body_y2 = list_y2,
    }

    local rows = {}
    local current_id
    local current_aid
    local disabled
    local disable_name
    local disable_cb
    local show_disable_row
    local item_prefix

    if settings_track_list_mode == "audio" then
        current_id = mp.get_property_native("aid")
        current_aid = mp.get_property("aid")
        show_disable_row = true
        disabled = (current_aid == "no")
        disable_name = "set_audio_disable"
        item_prefix = "set_audio_track_"

        disable_cb = function()
            mp.set_property("aid", "no")
        end

        for i, track in ipairs(audio_tracks) do
            local title = track.title
            local language = track.lang

            if not title or title == "" then
                if language and language ~= "" then
                    title = language
                    language = nil
                else
                    title = "Audio track " .. tostring(i)
                end
            end

            rows[#rows + 1] = {
                id = track.id,
                title = title,
                language = language,
                callback = function()
                    mp.set_property_number("aid", track.id)
                end
            }
        end
    else
        current_id = mp.get_property_number("current-edition", -1)
        show_disable_row = false
        item_prefix = "set_edition_"

        for i, edition in ipairs(editions) do
            local edition_id = edition.id
            if edition_id == nil then
                edition_id = i - 1
            end

            local title = edition.title
            if not title or title == "" then
                title = "Edition " .. tostring(edition_id + 1)
            end

            if edition.default then
                title = title .. " (default)"
            end

            rows[#rows + 1] = {
                id = edition_id,
                title = title,
                language = nil,
                callback = function()
                    mp.set_property_number("edition", edition_id)
                end
            }
        end
    end

    local total_rows = #rows + (show_disable_row and 1 or 0)
    local viewport_h = list_y2 - list_y1
    local visible_rows = math.max(
        1,
        math.floor((viewport_h + 2) / SET_MENU_ROW_H)
    )
    settings_menu_max_scroll = math.max(0, total_rows - visible_rows)
    settings_menu_scroll = math.max(
        0,
        math.min(settings_menu_scroll, settings_menu_max_scroll)
    )

    local first_y = list_y1 - settings_menu_scroll * SET_MENU_ROW_H
    local offset = 0

    if show_disable_row then
        draw_subtitle_track_row(
            ass,
            list_geo,
            first_y,
            "Disable audio",
            nil,
            disabled,
            disable_name,
            disable_cb
        )

        offset = 1
    end

    for i, row in ipairs(rows) do
        local row_y = first_y + (offset + i - 1) * SET_MENU_ROW_H

        draw_subtitle_track_row(
            ass,
            list_geo,
            row_y,
            row.title,
            row.language,
            current_id == row.id,
            item_prefix .. i,
            row.callback
        )
    end

    -- Scrollbar only for this fixed list area
    if settings_menu_max_scroll > 0 and total_rows > 0 then
        local sb_x1 = geo.cx2 - 5
        local sb_x2 = geo.cx2 - 2

        common.draw_rrect(
            ass,
            sb_x1,
            list_y1 + 2,
            sb_x2,
            list_y2 - 2,
            2,
            cfg.TRACK_BG,
            "30"
        )

        local thumb_h = math.max(
            20,
            viewport_h * visible_rows / total_rows
        )

        local thumb_y =
            list_y1 +
            (viewport_h - thumb_h) *
            settings_menu_scroll / settings_menu_max_scroll

        common.draw_rrect(
            ass,
            sb_x1 - 1,
            thumb_y,
            sb_x2 + 1,
            thumb_y + thumb_h,
            3,
            cfg.TRACK_FG,
            "00"
        )
    end
end

-- Main unified render
local function render_settings_menu(ass, geo)
    if settings_active_tab ~= "subtitles" and settings_active_tab ~= "video" then
        settings_active_tab = "video"
    end
    -- Background card
    common.draw_rrect(ass, geo.card_x1, geo.card_y1, geo.card_x2, geo.card_y2,
        SET_MENU_RADIUS, cfg.BARBG, "00")
    draw_rrect_outline(ass, geo.card_x1, geo.card_y1, geo.card_x2, geo.card_y2,
        SET_MENU_RADIUS, cfg.ICON_COLOR, "B0", 1)

    -- Header
    common.draw_text(ass, "Settings",
        geo.cx1, geo.header_y1 + SET_MENU_HEADER_H / 2,
        cfg.FONT_SIZE + 2, cfg.TEXT, "00", 4, false)
    common.draw_text(ass, "×",
        geo.cx2 - 4, geo.header_y1 + SET_MENU_HEADER_H / 2,
        cfg.FONT_SIZE + 6, cfg.ICON_COLOR, "00", 5, false)
    add_hitbox("set_close",
        geo.cx2 - 42, geo.header_y1 + 6,
        geo.cx2 + 4,  geo.header_y2 - 6,
        function()
            settings_menu_open  = false
            settings_menu_scroll = 0
        end)
    draw_sep(ass, geo, geo.header_y2)

    -- Tab bar
    local tabs = { {id = "subtitles", label = "Subtitles"}, {id = "video", label = "Video"} }
    local tab_w = (geo.cx2 - geo.cx1) / #tabs
    for i, tab in ipairs(tabs) do
        local tx1   = geo.cx1 + (i - 1) * tab_w
        local tx2   = tx1 + tab_w
        local tab_cy = geo.tab_y1 + SET_MENU_TAB_H / 2
        local active = (settings_active_tab == tab.id)
        if active then
            -- Accent underline
            common.draw_rrect(ass, tx1 + 6, geo.tab_y2 - 3, tx2 - 6, geo.tab_y2, 1,
                cfg.TRACK_FG, "00")
        end
        common.draw_text(ass, tab.label, (tx1 + tx2) / 2, tab_cy,
            cfg.FONT_SIZE - 1,
            active and cfg.TRACK_FG or cfg.TEXT,
            active and "00" or "40",
            5, false)
        local tid = tab.id
        add_hitbox("set_tab_" .. i, tx1, geo.tab_y1, tx2, geo.tab_y2,
            function()
                settings_active_tab  = tid
                settings_menu_scroll = 0
            end)
    end
    draw_sep(ass, geo, geo.tab_y2)

    -- Tab body
    if settings_active_tab == "subtitles" then
        render_subtitles_tab(ass, geo)
    else
        render_video_tab(ass, geo)
    end

    -- Footer
    draw_sep(ass, geo, geo.footer_y1)

    if settings_active_tab == "subtitles" then
        common.draw_text(ass, "Reset",
            geo.cx1 + 28, geo.footer_y1 + SET_MENU_FOOTER_H / 2,
            cfg.FONT_SIZE, cfg.TEXT, "35", 5, false)
        add_hitbox("set_sub_reset", geo.cx1, geo.footer_y1, geo.cx1 + 110, geo.footer_y2,
            function()
                mp.set_property_number("sub-delay",        0)
                mp.set_property_number("sub-scale",        1.0)
                mp.set_property_number("sub-pos",          100)
                mp.set_property_number("sub-outline-size", 1.65)
                mp.set_property_number("sub-shadow-offset",0)
            end)
    else
        common.draw_text(ass, "Reset",
            geo.cx1 + 28, geo.footer_y1 + SET_MENU_FOOTER_H / 2,
            cfg.FONT_SIZE, cfg.TEXT, "35", 5, false)
        add_hitbox("set_vid_reset", geo.cx1, geo.footer_y1, geo.cx1 + 120, geo.footer_y2,
            function()
                mp.set_property_number("speed", 1.0)
                mp.set_property_bool("keepaspect", true)
                mp.set_property("video-unscaled", "no")
                mp.set_property("video-aspect-override", "-1")
            end)
    end

    common.draw_text(ass, "Done",
        geo.cx2 - 26, geo.footer_y1 + SET_MENU_FOOTER_H / 2,
        cfg.FONT_SIZE - 1, cfg.TRACK_FG, "00", 5, false)
    add_hitbox("set_done", geo.cx2 - 110, geo.footer_y1, geo.cx2, geo.footer_y2,
        function()
            settings_menu_open  = false
            settings_menu_scroll = 0
        end)
end

--------------------------------------------------------------------------------
-- MAIN RENDER
--------------------------------------------------------------------------------

local function render()
    hitboxes = common.new_hitboxes()
    local ass = assdraw.ass_new()

    if not bar_visible then
        osd.data = ""
        local w, h = mp.get_osd_size()
        osd.res_x = w
        osd.res_y = h
        osd:update()
        popup_geo = nil
        add_menu_geo = nil
        return
    end

    position = position or 0
    duration = duration or 0
    volume = volume or 100

    local L = get_layout()

    ass:new_event()
    ass:append(string.format("{\\pos(0,0)\\an7\\1c&H%s&\\1a&H%s&\\bord0\\shad0}", cfg.BARBG, cfg.ALPHA_BAR_BG))
    ass:draw_start()
    ass:round_rect_cw(L.pill_x1, L.pill_y1, L.pill_x2, L.pill_y2, cfg.BAR_RADIUS)
    ass:draw_stop()

    local hovering_seek =
        (mouse_y >= L.seek_y - 8 and mouse_y <= L.seek_y + 8 and mouse_x >= L.seek_x1 and mouse_x <= L.seek_x2)
    local track_h = hovering_seek and cfg.SEEK_HEIGHT_HOVER or cfg.SEEK_HEIGHT_NORMAL
    local bar_x1, bar_x2 = L.seek_x1, L.seek_x2
    local bar_w = bar_x2 - bar_x1

    common.draw_rrect(ass, bar_x1, L.seek_y - track_h / 2,
	bar_x2, L.seek_y + track_h / 2, track_h / 2, cfg.TRACK_BG, "00")

    local ratio = (duration and duration > 0) and math.min(1, math.max(0, position / duration)) or 0
    local filled_x = bar_x1 + bar_w * ratio
    if filled_x > bar_x1 then
        common.draw_rrect(
            ass,
            bar_x1,
            L.seek_y - track_h / 2,
            filled_x,
            L.seek_y + track_h / 2,
            track_h / 2,
            cfg.TRACK_FG,
            "00"
        )
    end

    draw_chapter_marks(ass, bar_x1, bar_x2, bar_w, L.seek_y, track_h, duration)

    draw_rrect_outline(
        ass,
        bar_x1,
        L.seek_y - track_h / 2,
        bar_x2,
        L.seek_y + track_h / 2,
        track_h / 2,
        cfg.SEEK_BORDER_COLOR,
        cfg.SEEK_BORDER_ALPHA,
        cfg.SEEK_BORDER_WIDTH
    )

    common.draw_rrect(
        ass,
        filled_x - cfg.THUMB_WW,
        L.seek_y - cfg.THUMB_WH,
        filled_x + cfg.THUMB_WW,
        L.seek_y + cfg.THUMB_WH,
        cfg.THUMB_WRADIUS,
        cfg.THUMB_WCOLOR,
        "00"
    )
    draw_rrect_outline(
        ass,
        filled_x - cfg.THUMB_WW,
        L.seek_y - cfg.THUMB_WH,
        filled_x + cfg.THUMB_WW,
        L.seek_y + cfg.THUMB_WH,
        cfg.THUMB_WRADIUS,
        cfg.THUMB_WBORDER_COLOR,
        cfg.THUMB_WBORDER_ALPHA,
        cfg.THUMB_WBORDER_WIDTH
    )

    if hovering_seek and hovered_chapter and hovered_chapter.title then
        local text_w = measure_text_width(
            hovered_chapter.title,
            cfg.CHAPTER_TOOLTIP_FONT_SIZE,
            cfg.CHAPTER_TOOLTIP_FONT
        )

        text_w = text_w + 2

        local pad_x = cfg.CHAPTER_TOOLTIP_PAD_X or 0
        local pad_y = cfg.CHAPTER_TOOLTIP_PAD_Y or 3

        local pill_w = text_w + pad_x * 2
        local pill_h = cfg.CHAPTER_TOOLTIP_FONT_SIZE + pad_y * 2

        local max_pill_w = (bar_x2 - bar_x1) - 12
        pill_w = math.min(pill_w, max_pill_w)

        local half_w = pill_w / 2

        local target_x = math.min(
            bar_x2 - half_w - 6,
            math.max(bar_x1 + half_w + 6, mouse_x)
        )

        local center_y = L.seek_y - cfg.CHAPTER_TOOLTIP_OFFSET_Y

        local box_x1 = target_x - half_w
        local box_x2 = target_x + half_w
        local box_y1 = center_y - pill_h / 2
        local box_y2 = center_y + pill_h / 2

        common.draw_rrect(
            ass,
            box_x1,
            box_y1,
            box_x2,
            box_y2,
            cfg.CHAPTER_TOOLTIP_RADIUS,
            cfg.CHAPTER_TOOLTIP_BG_COLOR,
            cfg.CHAPTER_TOOLTIP_BG_ALPHA
        )
        common.draw_text(
            ass,
            hovered_chapter.title,
            target_x,
            center_y,
            cfg.CHAPTER_TOOLTIP_FONT_SIZE,
            cfg.CHAPTER_TOOLTIP_FONT_COLOR,
            cfg.CHAPTER_TOOLTIP_FONT_ALPHA,
            5,
            false,
            cfg.CHAPTER_TOOLTIP_FONT
        )
    end
	add_hitbox(
        "seekbar",
        bar_x1,
        L.seek_y - 10,
        bar_x2,
        L.seek_y + 10,
        function(px)
            seek_dragging = true
            if duration and duration > 0 then
                local r = (px - bar_x1) / bar_w
                mp.commandv("seek", math.min(1, math.max(0, r)) * duration, "absolute")
            end
        end
    )

    for _, group in ipairs({"left", "center", "right"}) do
        draw_icon_group_background(ass, L.buttons[group], L.row_y)
        for _, button in ipairs(L.buttons[group]) do
            local definition = BUTTONS[button.id]
            draw_item_background(ass, button.x, L.row_y, button.width)
            draw_item_border(ass, button.x, L.row_y, button.width)

            if definition.kind == "time" then
                draw_time_label(ass, fmt_time(position) .. " / " .. fmt_time(duration), button.x, L.row_y, 5)
            elseif definition.kind == "volume_slider" then
                draw_volume_slider(ass, button.x, L.row_y)
            else
                local glyph = type(definition.icon) == "function" and definition.icon() or definition.icon
                local alpha = definition.alpha and definition.alpha() or cfg.ICON_DIM_A
                draw_icon(ass, glyph, button.x, L.row_y, cfg.ICON_SIZE, cfg.ICON_COLOR, alpha)
            end

            local item_pad_x = cfg.ICON_BG_ENABLED and cfg.ICON_BG_PAD_X or 0
            local hitbox_half_w = math.max(16, button.width / 2 + item_pad_x)
            local hitbox_half_h = math.max(16, cfg.ICON_BG_ENABLED and cfg.ICON_BG_HEIGHT / 2 or button.height / 2)

            if definition.kind == "volume_slider" and cfg.VOLUME_SLIDER_MUTE then
                local mute_width = cfg.VOLUME_SLIDER_MUTE_WIDTH
                local total_item_width = button.width
                local mute_x = button.x - total_item_width / 2 + mute_width / 2

                add_hitbox(
                    "button_volume_slider_mute",
                    mute_x - mute_width / 2,
                    L.row_y - hitbox_half_h,
                    mute_x + mute_width / 2,
                    L.row_y + hitbox_half_h,
                    function()
                        mp.commandv("cycle", "mute")
                    end
                )

                local geo = get_volume_slider_geometry(button)

                add_hitbox(
                    "button_volume_slider_track",
                    geo.slider_x1 - cfg.VOLUME_SLIDER_THUMB_WIDTH - 4,
                    L.row_y - hitbox_half_h,
                    geo.slider_x2 + cfg.VOLUME_SLIDER_THUMB_WIDTH + 4,
                    L.row_y + hitbox_half_h,
                    function(px, py)
                        definition.click(px, py, button)
                    end
                )
            else
                add_hitbox(
                    "button_" .. button.id,
                    button.x - hitbox_half_w,
                    L.row_y - hitbox_half_h,
                    button.x + hitbox_half_w,
                    L.row_y + hitbox_half_h,
                    function(px, py)
                        definition.click(px, py, button)
                    end
                )
            end
        end
    end

    local time_label_y = L.seek_y + cfg.TIME_LABEL_OFFSET_Y + 3
    if not L.buttons.by_id.time then
        draw_time_label(ass, fmt_time(position), bar_x1, time_label_y, 4)
        draw_time_label(ass, fmt_time(duration), bar_x2, time_label_y, 6)
    end

    if volume_popup_open and L.buttons.by_id.volume then
        popup_geo = compute_popup_geo(L)
        render_volume_popup(ass, popup_geo)
    else
        volume_popup_open = false
        popup_geo = nil
    end

    if add_menu_open and L.buttons.by_id.add then
        add_menu_geo = compute_add_menu_geo(L)
        render_add_menu(ass, add_menu_geo)
    else
        add_menu_open = false
        add_menu_geo = nil
    end

    if settings_menu_open then
        settings_menu_geo = compute_settings_menu_geo()
        render_settings_menu(ass, settings_menu_geo)
    else
        settings_menu_open = false
        settings_menu_geo = nil
    end

    local w, h = mp.get_osd_size()
    osd.data = ass.text
    osd.res_x = w
    osd.res_y = h
    osd:update()
end

local function schedule_render()
    if render_timer then
        return -- Already scheduled
    end
    render_timer = mp.add_timeout(
        0.016, -- ~60fps frame time
        function()
            render_timer = nil
            render()
        end
    )
end

--------------------------------------------------------------------------------
-- VISIBILITY
--------------------------------------------------------------------------------

local function mouse_in_active_zone()
    if volume_dragging or volume_slider_dragging then
        return true
    end

    local L = get_layout()
    if mouse_y >= L.pill_y1 - 20 and mouse_x >= L.pill_x1 - 20 and mouse_x <= L.pill_x2 + 20 then
        return true
    end

    if popup_geo
        and mouse_x >= popup_geo.card_x1 - 14
        and mouse_x <= popup_geo.card_x2 + 14
        and mouse_y >= popup_geo.card_y1 - 14
        and mouse_y <= popup_geo.card_y2 + 14 then
        return true
    end

    if add_menu_geo
        and mouse_x >= add_menu_geo.card_x1 - 14
        and mouse_x <= add_menu_geo.card_x2 + 14
        and mouse_y >= add_menu_geo.card_y1 - 14
        and mouse_y <= add_menu_geo.card_y2 + 14 then
        return true
    end

    if settings_menu_geo
        and mouse_x >= settings_menu_geo.card_x1 - 10
        and mouse_x <= settings_menu_geo.card_x2 + 10
        and mouse_y >= settings_menu_geo.card_y1 - 10
        and mouse_y <= settings_menu_geo.card_y2 + 10 then
        return true
    end

    return false
end

local function restart_hide_timer()
    if hide_timer then
        hide_timer:kill()
    end
    hide_timer =
        mp.add_timeout(
        cfg.AUTOHIDE_SEC,
        function()
            if volume_dragging or volume_slider_dragging or mouse_in_active_zone() then
                restart_hide_timer()
            else
                bar_visible = false
                volume_popup_open = false
                add_menu_open = false
                render()
            end
        end
    )
end

local function show_bar()
    if not bar_visible then
        bar_visible = true
        render()
    end
    restart_hide_timer()
end

local function toggle_bar()
    if bar_visible then
        if hide_timer then
            hide_timer:kill()
        end
        bar_visible = false
        volume_popup_open = false
        add_menu_open = false
        settings_menu_open = false
        settings_menu_geo = nil
        settings_menu_scroll = 0
        render()
    else
        show_bar()
    end
end

mp.register_script_message("cadre-osc-toggle", toggle_bar)
mp.register_script_message("open-file-dialog", common.do_add_file)
mp.register_script_message("open-folder-dialog", common.do_add_folder)
mp.register_script_message("open-url-dialog", common.do_add_url)
mp.add_key_binding(nil, "cadre_osc_toggle", toggle_bar)
mp.add_key_binding(nil, "open-file-dialog", common.do_add_file)
mp.add_key_binding(nil, "open-folder-dialog", common.do_add_folder)
mp.add_key_binding(nil, "open-url-dialog", common.do_add_url)

local function update_thumbnail_preview()
    local L = get_layout()
    local bar_x1, bar_x2 = L.seek_x1, L.seek_x2
    local hovering_seek =
        (mouse_y >= L.seek_y - 10 and mouse_y <= L.seek_y + 10 and mouse_x >= bar_x1 and mouse_x <= bar_x2)

    if hovering_seek and duration and duration > 0 and not thumbfast.disabled then
        local ratio = (mouse_x - bar_x1) / (bar_x2 - bar_x1)
        local hovered_seconds = duration * math.min(1, math.max(0, ratio))
        local display_width = mp.get_property_number("osd-width", screen_w)
        mp.commandv(
            "script-message-to",
            "thumbfast",
            "thumb",
            hovered_seconds,
            math.min(display_width - thumbfast.width - 10, math.max(10, mouse_x - thumbfast.width / 2)),
            L.seek_y - 10 - thumbfast.height
        )
    elseif thumbfast.available then
        mp.commandv("script-message-to", "thumbfast", "clear")
    end
end

--------------------------------------------------------------------------------
-- INPUT
--------------------------------------------------------------------------------

local function point_in_own_ui(px, py)
    local L = get_layout()

    -- Main OSC control-bar region.
    if px >= L.pill_x1 and px <= L.pill_x2 and py >= L.pill_y1 and py <= L.pill_y2 then
        return true
    end

    -- Volume flyout.
    if
        popup_geo and px >= popup_geo.card_x1 and px <= popup_geo.card_x2 and py >= popup_geo.card_y1 and
            py <= popup_geo.card_y2
     then
        return true
    end

    -- Add-file flyout.
    if
        add_menu_geo and px >= add_menu_geo.card_x1 and px <= add_menu_geo.card_x2 and py >= add_menu_geo.card_y1 and
            py <= add_menu_geo.card_y2
     then
        return true
    end

    -- Subtitle settings dialog.
    if
        settings_menu_geo and px >= settings_menu_geo.card_x1 and px <= settings_menu_geo.card_x2 and
            py >= settings_menu_geo.card_y1 and
            py <= settings_menu_geo.card_y2
     then
        return true
    end

    return false
end

local function point_in_published_bounds(prefix, px, py)
    local visible = mp.get_property_native("user-data/" .. prefix .. "/visible", false)
    if not visible then
        return false
    end
    local x1 = mp.get_property_native("user-data/" .. prefix .. "/x1", -1)
    local y1 = mp.get_property_native("user-data/" .. prefix .. "/y1", -1)
    local x2 = mp.get_property_native("user-data/" .. prefix .. "/x2", -1)
    local y2 = mp.get_property_native("user-data/" .. prefix .. "/y2", -1)
    return px >= x1 and px <= x2 and py >= y1 and py <= y2
end

local function point_in_playlist_ui(px, py)
    return point_in_published_bounds("cadre_playlist", px, py)
end

local function point_in_titlebar_ui(px, py)
    return point_in_published_bounds("cadre_titlebar", px, py)
end

local function on_mouse_move()
    local in_playlist_area = point_in_playlist_ui(mouse_x, mouse_y)
    local in_titlebar_area = point_in_titlebar_ui(mouse_x, mouse_y)
    local in_osd_area = point_in_own_ui(mouse_x, mouse_y) or in_playlist_area or in_titlebar_area
    if not in_titlebar_area then
        mp.set_property_bool("window-dragging", not in_osd_area)
    end

    if volume_dragging and popup_geo then
        local clamped_y = math.min(popup_geo.track_y2, math.max(popup_geo.track_y1, mouse_y))
        set_volume_from_y(clamped_y, popup_geo)
        render()
        return
    end

    if volume_slider_dragging then
        local slider_button = nil
        local current_layout = get_layout()

        for _, group in ipairs({"left", "center", "right"}) do
            for _, button in ipairs(current_layout.buttons[group]) do
                if button.id == "volume_slider" then
                    slider_button = button
                    break
                end
            end

            if slider_button then
                break
            end
        end

        if slider_button then
            set_volume_from_x(mouse_x, slider_button)
            render()
            return
        end
    end

    if seek_dragging then
        local L = get_layout()
        local bar_x1, bar_x2 = L.seek_x1, L.seek_x2
        local bar_w = bar_x2 - bar_x1
        if duration and duration > 0 then
            local r = (mouse_x - bar_x1) / bar_w
            mp.commandv("seek", math.min(1, math.max(0, r)) * duration, "absolute")
        end
        render()
        return
    end

    if not file_loaded then
        bar_visible = true
        render()
        return
    end

    update_thumbnail_preview()

    local function update_hovered_chapter()
        local L = get_layout()
        local bar_x1, bar_x2 = L.seek_x1, L.seek_x2
        local hovering_seek =
            (mouse_y >= L.seek_y - 10 and mouse_y <= L.seek_y + 10 and mouse_x >= bar_x1 and mouse_x <= bar_x2)

        local new_hovered = nil
        if hovering_seek then
            new_hovered = find_hovered_chapter(bar_x1, bar_x2 - bar_x1, duration, mouse_x)
        end

        if new_hovered ~= hovered_chapter then
            hovered_chapter = new_hovered
            if bar_visible then
                render()
            end
        end
    end

    update_hovered_chapter()
    local hovering_hitbox = false
    for _, b in ipairs(hitboxes) do
        if point_in(mouse_x, mouse_y, b) then
            hovering_hitbox = true
            break
        end
    end
    local hover_state = hovering_hitbox

    if hover_state ~= last_osc_hover then
        last_osc_hover = hover_state

        mp.commandv(
            "script-message",
            "python-bridge",
            "osc-hover",
            tostring(hover_state)
        )
    end

    if mouse_in_active_zone() then
        show_bar()
    elseif bar_visible then
        render()
    end
end

local function on_mbtn_left(event)
    if event.event == "down" or event.event == "press" then
        local in_playlist_area = point_in_playlist_ui(mouse_x, mouse_y)
        local in_titlebar_area = point_in_titlebar_ui(mouse_x, mouse_y)
        local in_osd_area = point_in_own_ui(mouse_x, mouse_y) or in_playlist_area or in_titlebar_area

        mp.commandv("script-message", "python-bridge", "osd-hit", tostring(in_osd_area))

        if in_titlebar_area then
            mp.commandv("script-message-to", "cadre_titlebar", "titlebar-mbtn-left-down")
            return
        end

        if in_playlist_area then
            mp.commandv("script-message-to", "cadre_playlist", "playlist-mbtn-left-down", event.key_name or "")
            return
        end

        if not in_osd_area then
            if not bar_visible then
                show_bar()
            end
            return
        end

        if not bar_visible then
            show_bar()
            return
        end

        if volume_popup_open and popup_geo then
            local in_popup =
                mouse_x >= popup_geo.card_x1 and mouse_x <= popup_geo.card_x2 and mouse_y >= popup_geo.card_y1 and
                mouse_y <= popup_geo.card_y2
            if in_popup then
                for _, b in ipairs(hitboxes) do
                    if
                        (b.name == "volume_track" or b.name == "volume_mute" or b.name == "volume_card_bg") and
                            point_in(mouse_x, mouse_y, b)
                     then
                        b.cb(mouse_x, mouse_y)
                        render()
                        return
                    end
                end
                return
            else
                volume_popup_open = false
                render()
            end
        end

        if add_menu_open and add_menu_geo then
          local in_menu = mouse_x >= add_menu_geo.card_x1
              and mouse_x <= add_menu_geo.card_x2
              and mouse_y >= add_menu_geo.card_y1
              and mouse_y <= add_menu_geo.card_y2

          if in_menu then
                for _, b in ipairs(hitboxes) do
                    if b.name:match("^add_menu_") and point_in(mouse_x, mouse_y, b) then
                        b.cb()
                        render()
                        return
                    end
                end
                return
            else
                add_menu_open = false
                render()
            end
        end
        if settings_menu_open and settings_menu_geo then
            local in_settings_menu =
                mouse_x >= settings_menu_geo.card_x1 and mouse_x <= settings_menu_geo.card_x2 and
                mouse_y >= settings_menu_geo.card_y1 and
                mouse_y <= settings_menu_geo.card_y2

            if in_settings_menu then
                -- Settings hitboxes are appended last; search backward for top priority.
                for i = #hitboxes, 1, -1 do
                    local b = hitboxes[i]

                    if b.name:match("^set_") and point_in(mouse_x, mouse_y, b) then
                        b.cb(mouse_x, mouse_y)
                        render()
                        return
                    end
                end

                -- Blank area inside the modal is consumed, not passed through.
                return
            else
                -- Clicking outside the settings dialog closes it.
                settings_menu_open = false
                settings_menu_geo = nil
                settings_menu_scroll = 0
                render()
                return
            end
        end

        for _, b in ipairs(hitboxes) do
            if point_in(mouse_x, mouse_y, b) then
                if b.name == "seekbar" or b.name == "volume_track" or b.name == "button_volume_slider_track" then
                    b.cb(mouse_x, mouse_y)
                else
                    b.cb()
                end

                render()
                return
            end
        end
    elseif event.event == "up" or event.event == "release" then
        mp.commandv("script-message-to", "cadre_playlist", "playlist-mbtn-left-up", event.key_name or "")
        mp.commandv("script-message-to", "cadre_titlebar", "titlebar-mbtn-left-up")
        volume_dragging = false
        volume_slider_dragging = false
        seek_dragging = false
    end
end

mp.observe_property(
    "mouse-pos",
    "native",
    function(_, pos)
        if pos then
            mouse_x = pos.x or -1
            mouse_y = pos.y or -1
            on_mouse_move()
        end
    end
)
mp.add_forced_key_binding("MBTN_LEFT", "cadre_mbtn_left", on_mbtn_left, {complex = true})
mp.add_forced_key_binding("Ctrl+MBTN_LEFT", "cadre_ctrl_mbtn_left", on_mbtn_left, {complex = true})
mp.add_forced_key_binding("Shift+MBTN_LEFT", "cadre_shift_mbtn_left", on_mbtn_left, {complex = true})
mp.add_forced_key_binding("Ctrl+Shift+MBTN_LEFT", "cadre_ctrl_shift_mbtn_left", on_mbtn_left, {complex = true})
mp.register_event(
    "client-message",
    function()
    end
)
mp.add_key_binding(
    "MBTN_LEFT_DBL",
    "cadre_mbtn_left_dbl",
    function()
        local in_playlist_area = point_in_playlist_ui(mouse_x, mouse_y)
        local in_titlebar_area = point_in_titlebar_ui(mouse_x, mouse_y)
        if in_playlist_area or in_titlebar_area then
            return
        end
        if point_in_own_ui(mouse_x, mouse_y) then
            return
        end
        mp.commandv("cycle", "fullscreen")
    end
)
--------------------------------------------------------------------------------
-- MOUSE WHEEL
--------------------------------------------------------------------------------

mp.add_key_binding(
    "WHEEL_UP",
    "cadre_wheel_up",
    function()
        local L = get_layout()

        -- Subtitle dialog owns the wheel only while it is open.
        if settings_menu_open then
            settings_menu_scroll = math.max(0, settings_menu_scroll - 1)
            render()
            return
        end

        -- Vertical volume popup.
        if
            volume_popup_open and popup_geo and mouse_x >= popup_geo.card_x1 and mouse_x <= popup_geo.card_x2 and
                mouse_y >= popup_geo.card_y1 and
                mouse_y <= popup_geo.card_y2
         then
            mp.commandv("add", "volume", 2)
            return
        end

        -- Seekbar.
        if mouse_x >= L.seek_x1 and mouse_x <= L.seek_x2 and mouse_y >= L.seek_y - 12 and mouse_y <= L.seek_y + 12 then
            mp.commandv("seek", 5, "relative")
            return
        end

        -- Inline horizontal volume slider, if "volume_slider" is in the layout.
        for _, group in ipairs({"left", "center", "right"}) do
            for _, button in ipairs(L.buttons[group]) do
                if button.id == "volume_slider" then
                    local geo = get_volume_slider_geometry(button)

                    if
                        mouse_x >= geo.slider_x1 - 8 and mouse_x <= geo.slider_x2 + 8 and mouse_y >= L.row_y - 18 and
                            mouse_y <= L.row_y + 18
                     then
                        mp.commandv("add", "volume", 2)
                        return
                    end
                end
            end
        end
    end,
    {repeatable = true}
)

mp.add_key_binding(
    "WHEEL_DOWN",
    "cadre_wheel_down",
    function()
        local L = get_layout()

        -- Subtitle dialog owns the wheel only while it is open.
        if settings_menu_open then
            settings_menu_scroll = math.min(settings_menu_max_scroll, settings_menu_scroll + 1)
            render()
            return
        end

        -- Vertical volume popup.
        if
            volume_popup_open and popup_geo and mouse_x >= popup_geo.card_x1 and mouse_x <= popup_geo.card_x2 and
                mouse_y >= popup_geo.card_y1 and
                mouse_y <= popup_geo.card_y2
         then
            mp.commandv("add", "volume", -2)
            return
        end

        -- Seekbar.
        if mouse_x >= L.seek_x1 and mouse_x <= L.seek_x2 and mouse_y >= L.seek_y - 12 and mouse_y <= L.seek_y + 12 then
            mp.commandv("seek", -5, "relative")
            return
        end

        -- Inline horizontal volume slider, if "volume_slider" is in the layout.
        for _, group in ipairs({"left", "center", "right"}) do
            for _, button in ipairs(L.buttons[group]) do
                if button.id == "volume_slider" then
                    local geo = get_volume_slider_geometry(button)

                    if
                        mouse_x >= geo.slider_x1 - 8 and mouse_x <= geo.slider_x2 + 8 and mouse_y >= L.row_y - 18 and
                            mouse_y <= L.row_y + 18
                     then
                        mp.commandv("add", "volume", -2)
                        return
                    end
                end
            end
        end
    end,
    {repeatable = true}
)

--------------------------------------------------------------------------------
-- PROPERTY OBSERVERS
--------------------------------------------------------------------------------

mp.observe_property(
    "osd-dimensions",
    "native",
    function(_, val)
        if not val or not val.w or not val.h or val.w <= 0 or val.h <= 0 then
            return
        end
        if screen_w ~= val.w or screen_h ~= val.h then
            screen_w = val.w
            screen_h = val.h
            osd.res_x = screen_w
            osd.res_y = screen_h
            if file_loaded then
                render()
            end
        end
    end
)

mp.observe_property(
    "duration",
    "number",
    function(_, v)
        duration = v or 0
        schedule_render()
    end
)
mp.observe_property(
    "time-pos",
    "number",
    function(_, v)
        position = v or 0
        if bar_visible then
            schedule_render()
        end
    end
)
mp.observe_property(
    "pause",
    "bool",
    function(_, v)
        paused = v
        schedule_render()
    end
)
mp.observe_property(
    "mute",
    "bool",
    function(_, v)
        muted = v
        schedule_render()
    end
)
mp.observe_property(
    "volume",
    "number",
    function(_, v)
        volume = v or 100
        schedule_render()
    end
)

mp.observe_property(
    "chapter-list",
    "native",
    function(_, raw)
        chapters = normalize_chapters(raw)
        hovered_chapter = nil
        render()
    end
)

mp.register_event(
    "playback-restart",
    function()
        local raw = mp.get_property_native("chapter-list", {})
        local normalized = normalize_chapters(raw)
        if #normalized ~= #chapters then
            chapters = normalized
            render()
        end
    end
)

local file_init_timer = nil

local function on_file_initialized()
    if not file_loaded then
        file_loaded = true
        last_subtitle_sid = nil
        last_osc_hover = nil
        bar_visible = true
    end
    render()
end

mp.register_event(
    "file-loaded",
    function()
        -- Use a micro-timer to batch rapid-fire events
        if file_init_timer then
            file_init_timer:kill()
        end
        file_init_timer = mp.add_timeout(
            0.05,
            function()
                on_file_initialized()

                -- NEW: auto-load chapters if none exist
                local existing = mp.get_property_native("chapter-list", {})
                if #existing == 0 then
                    load_youtube_chapters()
                end

                file_init_timer = nil
            end
        )
    end
)

mp.observe_property(
    "path",
    "string",
    function(_, v)
        if v ~= nil and v ~= "" and not file_loaded then
            -- Path changed but file-loaded hasn't fired yet (edge case)
            if file_init_timer then
                file_init_timer:kill()
            end
            file_init_timer = mp.add_timeout(
                0.05,
                function()
                    on_file_initialized()
                    file_init_timer = nil
                end
            )
        end
    end
)

render()
