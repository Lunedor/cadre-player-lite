--[[
cadre_osc.lua (control bar)
]]

local mp = require 'mp'
local assdraw = require 'mp.assdraw'
local utils = require 'mp.utils'
local msg = require 'mp.msg'

local common_path = mp.find_config_file("scripts/cadre_common.lua")
local common = dofile(common_path)
common.register_script("cadre_osc")

local thumbfast = { width = 0, height = 0, disabled = true, available = false }
mp.register_script_message("thumbfast-info", function(json)
  local data = utils.parse_json(json)
  if type(data) ~= "table" or not data.width or not data.height then
    msg.error("thumbfast-info: received json didn't produce a table with thumbnail information")
  else
    thumbfast = data
  end
end)

--------------------------------------------------------------------------------
-- CONFIG
--------------------------------------------------------------------------------

local theme = dofile(mp.find_config_file("scripts/cadre_theme.lua"))

local UI_FONT = theme.font_ui or theme.font_text or "Inter"
local ICON_FONT = theme.font_icon_osc or theme.font_icon or "Material Icons Outlined"
local ICON_COLOR = common.bgr(theme.color_icon_osc or theme.text_color or "F8FAFC")
local TEXT = common.bgr(theme.color_text_osc or theme.text_color or "F8FAFC")
local FONT_SIZE = theme.font_size_osc or theme.font_size or 16
local BARBG = common.bgr(theme.color_bar_bg_osc or theme.surface_color or "0D1117")
local ALPHA_BAR_BG = theme.alpha_bar_bg_osc or theme.alpha_bar_bg or "1C"
local TRACK_FG = common.bgr(theme.color_track_fg_osc or theme.accent_color or "63B8FF")
local TRACK_BG = common.bgr(theme.color_track_bg_osc or "303845")
local SLIDER_RAIL = common.bgr(theme.color_slider_rail_osc or "1E293B")
local THUMB_COLOR = common.bgr(theme.thumb_color or theme.color_track_fg_osc or theme.accent_color or "F8FAFC")
local ICON_DIM_A = theme.alpha_icon_dim_osc or theme.alpha_icon_dim or "60"

local BAR_HEIGHT = theme.bar_height_osc or theme.bar_height or 100
local BAR_SIDE_INSET = theme.bar_side_inset_osc or theme.bar_side_inset or 0
local BAR_Y_ANCHOR = theme.bar_y_anchor_osc == "top" and "top"
  or theme.bar_y_anchor_osc == "center" and "center"
  or "bottom"
local BAR_TOP_INSET = theme.bar_top_inset_osc or 0
local BAR_BOTTOM_INSET = theme.bar_bottom_inset_osc or theme.bar_bottom_inset or 0
local BAR_RADIUS = theme.bar_radius_osc or theme.bar_radius or 0
local AUTOHIDE_SEC = theme.bar_autohide_sec_osc or theme.bar_autohide_sec or 0.4

local THUMB_W = theme.thumb_width or 4
local THUMB_H = theme.thumb_height or 10
local THUMB_RADIUS = theme.thumb_radius or 5
local SEEK_BORDER_COLOR = common.bgr(theme.seek_border_color_osc or "FFFFFF")
local SEEK_BORDER_ALPHA = theme.seek_border_alpha_osc or "FF"
local SEEK_BORDER_WIDTH = theme.seek_border_width_osc or 1
local THUMB_BORDER_COLOR = common.bgr(theme.thumb_border_color_osc or "000000")
local THUMB_BORDER_ALPHA = theme.thumb_border_alpha_osc or "FF"
local THUMB_BORDER_WIDTH = theme.thumb_border_width_osc or 1
local SEEK_Y_OFFSET = theme.seek_y_offset or 14
local SEEK_HEIGHT_NORMAL = theme.seek_height_normal or 6
local SEEK_HEIGHT_HOVER = theme.seek_height_hover or 10
local SEEK_SIDE_INSET = theme.seek_side_inset_osc or theme.side_margin or 24
local BUTTON_LEFT_INSET = theme.button_left_inset_osc or theme.side_margin or 24
local BUTTON_RIGHT_INSET = theme.button_right_inset_osc or theme.side_margin or 24
local BUTTON_Y_ANCHOR = theme.button_y_anchor_osc == "bottom" and "bottom" or "top"
local BUTTON_ROW_OFFSET = theme.button_row_offset_osc or theme.button_row_offset or 60

local ICON_SPACING = theme.icon_spacing or 36
local ICON_SIZE = theme.icon_size or 24
local TIME_ITEM_WIDTH = theme.time_item_width_osc or 150
local TIME_LABEL_OFFSET_Y = theme.time_label_offset_y or 16
local TIME_LABEL_OUTLINE_WIDTH = theme.time_label_outline_osc and (theme.time_label_outline_width_osc or 2) or 0
local TIME_LABEL_OUTLINE_COLOR = common.bgr(theme.time_label_outline_color_osc or "000000")
local TIME_LABEL_OUTLINE_ALPHA = theme.time_label_outline_alpha_osc or "30"
local TIME_LABEL_SHADOW = theme.time_label_shadow_osc and 1 or 0
local TIME_LABEL_SHADOW_X = theme.time_label_shadow_x_osc or 1
local TIME_LABEL_SHADOW_Y = theme.time_label_shadow_y_osc or 1
local TIME_LABEL_SHADOW_COLOR = common.bgr(theme.time_label_shadow_color_osc or "000000")
local TIME_LABEL_SHADOW_ALPHA = theme.time_label_shadow_alpha_osc or "40"
local VOLUME_SLIDER_WIDTH = theme.volume_slider_width_osc or 110
local VOLUME_SLIDER_HEIGHT = theme.volume_slider_height_osc or 6
local VOLUME_SLIDER_THUMB_WIDTH = theme.volume_slider_thumb_width_osc or 4
local VOLUME_SLIDER_THUMB_HEIGHT = theme.volume_slider_thumb_height_osc or 12
local VOLUME_SLIDER_RADIUS = theme.volume_slider_radius_osc or 3
local VOLUME_SLIDER_COLOR = common.bgr(theme.volume_slider_color_osc or "FFFFFF")
local VOLUME_SLIDER_TRACK_COLOR = common.bgr(theme.volume_slider_track_color_osc or "444444")
local VOLUME_SLIDER_MUTE = theme.volume_slider_mute_osc ~= false
local VOLUME_SLIDER_MUTE_WIDTH = theme.volume_slider_mute_width_osc or ICON_SIZE
local VOLUME_SLIDER_MUTE_GAP = theme.volume_slider_mute_gap_osc or 8
local VOLUME_SLIDER_PAD_LEFT = theme.volume_slider_pad_left_osc or 6
local VOLUME_SLIDER_PAD_RIGHT = theme.volume_slider_pad_right_osc or 6
local ICON_BG_ENABLED = theme.icon_bg_enabled_osc or false
local ICON_BG_COLOR = common.bgr(theme.icon_bg_color_osc or theme.surface_color or "0D1117")
local ICON_BG_ALPHA = theme.icon_bg_alpha_osc or "20"
local ICON_BG_PAD_X = theme.icon_bg_pad_x_osc
  or math.max(0, ((theme.icon_bg_width_osc or ICON_SIZE + 12) - ICON_SIZE) / 2)
local ICON_BG_HEIGHT = theme.icon_bg_height_osc or theme.icon_bg_height or ICON_SIZE + 12
local ICON_BG_RADIUS = theme.icon_bg_radius_osc or 0
local ICON_BORDER_ENABLED = theme.icon_border_enabled_osc or false
local ICON_BORDER_COLOR = common.bgr(theme.icon_border_color_osc or "FFFFFF")
local ICON_BORDER_ALPHA = theme.icon_border_alpha_osc or "FF"
local ICON_BORDER_WIDTH = theme.icon_border_width_osc or 1
local ICON_GROUP_BG_ENABLED = theme.icon_group_bg_enabled_osc or false
local ICON_GROUP_BG_COLOR = common.bgr(theme.icon_group_bg_color_osc or theme.surface_color or "0D1117")
local ICON_GROUP_BG_ALPHA = theme.icon_group_bg_alpha_osc or "40"
local ICON_GROUP_BG_PADDING = theme.icon_group_bg_padding_osc or 8
local ICON_GROUP_BG_HEIGHT = theme.icon_group_bg_height_osc or ICON_BG_HEIGHT + 16
local ICON_GROUP_BG_RADIUS = theme.icon_group_bg_radius_osc or 0
local ICON_GROUP_BORDER_ENABLED = theme.icon_group_border_enabled_osc or false
local ICON_GROUP_BORDER_COLOR = common.bgr(theme.icon_group_border_color_osc or "FFFFFF")
local ICON_GROUP_BORDER_ALPHA = theme.icon_group_border_alpha_osc or "FF"
local ICON_GROUP_BORDER_WIDTH = theme.icon_group_border_width_osc or 1

local CHAPTER_TOOLTIP_FONT = theme.font_chapter_tooltip or theme.font_text or "Inter"
local CHAPTER_MARK_COLOR = common.bgr(theme.color_chapter_mark or theme.background_color or "0A0C10")
local CHAPTER_MARK_ALPHA = theme.alpha_chapter_mark or "20"
local CHAPTER_MARK_W = theme.chapter_mark_width or 2
local CHAPTER_HOVER_PX = theme.chapter_hover_px or 8
local CHAPTER_TOOLTIP_FONT_SIZE = theme.chapter_tooltip_size or 18
local CHAPTER_TOOLTIP_OFFSET_Y = theme.chapter_tooltip_offset_y or 36
local CHAPTER_TOOLTIP_BG_COLOR = common.bgr(theme.chapter_tooltip_bg_color or theme.background_color or "0A0C10")
local CHAPTER_TOOLTIP_BG_ALPHA = theme.chapter_tooltip_bg_alpha or "00"
local CHAPTER_TOOLTIP_RADIUS = theme.chapter_tooltip_radius or 8
local CHAPTER_TOOLTIP_PAD_X = theme.chapter_tooltip_pad_x or 8
local CHAPTER_TOOLTIP_PAD_Y = theme.chapter_tooltip_pad_y or 10

local ICON = {
  play = "\238\128\183",        -- U+E037
  pause = "\238\128\180",       -- U+E034
  prev = "\238\129\133",        -- U+E045
  next = "\238\129\132",        -- U+E044
  stop = "\238\129\135",        -- U+E047
  volume_up = "\238\129\144",   -- U+E050
  volume_off = "\238\129\143",  -- U+E04F
  add = "\238\133\133",         -- U+E145
  fullscreen = "\238\151\144",  -- U+E5D0
  seek_back = "\238\129\153",   -- U+E059
  seek_forward = "\238\129\150",-- U+E056
  playlist = "\238\129\159",    -- U+E05F
  add_file = "\238\137\141",    -- U+E24D
  add_folder = "\238\139\140",  -- U+E2CC
  add_url = "\238\133\151",     -- U+E157
}

--------------------------------------------------------------------------------
-- YOUTUBE CHAPTER LOADER
--------------------------------------------------------------------------------

local function load_youtube_chapters()
  local path = mp.get_property("path")
    if not path then return end
        if not (path:find("youtube%.com") or path:find("youtu%.be")) then return end

        local res = mp.command_native({
            name = "subprocess",
            playback_only = false,
            capture_stdout = true,
            args = {"yt-dlp", "-J", "--no-warnings", "--quiet", path}
        })

        if res and res.status == 0 and res.stdout then
            local json = utils.parse_json(res.stdout)
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
end

mp.register_event("file-loaded", load_youtube_chapters)

--------------------------------------------------------------------------------
-- STATE
--------------------------------------------------------------------------------

local osd = mp.create_osd_overlay("ass-events")
local screen_w, screen_h = 1280, 720
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
local volume_dragging = false
local volume_slider_dragging = false
local seek_dragging = false
local hitboxes = {}
local popup_geo = nil
local add_menu_geo = nil

local chapters = {}
local hovered_chapter = nil

--------------------------------------------------------------------------------
-- HELPERS
--------------------------------------------------------------------------------

local function fmt_time(t)
  if not t or t ~= t or t < 0 then return "00:00" end
  t = math.floor(t)
  local h = math.floor(t / 3600)
  local m = math.floor((t % 3600) / 60)
  local s = t % 60
  if h > 0 then return string.format("%d:%02d:%02d", h, m, s) end
  return string.format("%02d:%02d", m, s)
end

local function utf8_char_count(str)
    local _, count = str:gsub("[^\128-\191]", "")
    return count
end

local function add_hitbox(name, x1, y1, x2, y2, cb) common.add_hitbox(hitboxes, name, x1, y1, x2, y2, cb) end
local function point_in(px, py, b) return common.point_in(px, py, b) end
local function draw_icon(ass, glyph, cx, cy, size, color, alpha) common.draw_icon(ass, ICON_FONT, glyph, cx, cy, size, color, alpha) end

local function draw_time_label(ass, text, x, y, align)
  ass:new_event()
  ass:append(string.format(
    "{\\pos(%d,%d)\\an%d\\fn%s\\fs%d\\1c&H%s&\\1a&H10&"
      .. "\\3c&H%s&\\3a&H%s&\\bord%d\\shad%d\\xshad%d\\yshad%d"
      .. "\\4c&H%s&\\4a&H%s&\\b0}%s",
    x, y, align, UI_FONT, FONT_SIZE, TEXT,
    TIME_LABEL_OUTLINE_COLOR, TIME_LABEL_OUTLINE_ALPHA, TIME_LABEL_OUTLINE_WIDTH,
    TIME_LABEL_SHADOW, TIME_LABEL_SHADOW_X, TIME_LABEL_SHADOW_Y,
    TIME_LABEL_SHADOW_COLOR, TIME_LABEL_SHADOW_ALPHA, text
  ))
end

local function draw_volume_slider(ass, x, y)
  local slider_width = VOLUME_SLIDER_WIDTH

  local slider_x1

  if VOLUME_SLIDER_MUTE then
    local mute_width = VOLUME_SLIDER_MUTE_WIDTH
    local total_item_width = mute_width
      + VOLUME_SLIDER_MUTE_GAP
      + slider_width
      + VOLUME_SLIDER_PAD_LEFT
      + VOLUME_SLIDER_PAD_RIGHT

    local mute_x = x - total_item_width / 2 + mute_width / 2 + VOLUME_SLIDER_PAD_LEFT

    draw_icon(
      ass,
      muted and ICON.volume_off or ICON.volume_up,
      mute_x,
      y,
      ICON_SIZE,
      ICON_COLOR,
      "00"
    )

    slider_x1 = x
      + total_item_width / 2
      - slider_width
      - VOLUME_SLIDER_PAD_RIGHT
  else
    local total_item_width = slider_width
      + VOLUME_SLIDER_PAD_LEFT
      + VOLUME_SLIDER_PAD_RIGHT

    slider_x1 = x
      - total_item_width / 2
      + VOLUME_SLIDER_PAD_LEFT
  end

  local slider_x2 = slider_x1 + slider_width

  local track_y1 = y - VOLUME_SLIDER_HEIGHT / 2
  local track_y2 = y + VOLUME_SLIDER_HEIGHT / 2

  local ratio = math.min(1, math.max(0, volume / 100))
  local thumb_x = slider_x1 + (slider_x2 - slider_x1) * ratio

  common.draw_rrect(
    ass,
    slider_x1,
    track_y1,
    slider_x2,
    track_y2,
    VOLUME_SLIDER_RADIUS,
    VOLUME_SLIDER_TRACK_COLOR,
    "00"
  )

  if thumb_x > slider_x1 then
    common.draw_rrect(
      ass,
      slider_x1,
      track_y1,
      thumb_x,
      track_y2,
      VOLUME_SLIDER_RADIUS,
      VOLUME_SLIDER_COLOR,
      "00"
    )
  end

  common.draw_rrect(
    ass,
    thumb_x - VOLUME_SLIDER_THUMB_WIDTH,
    y - VOLUME_SLIDER_THUMB_HEIGHT,
    thumb_x + VOLUME_SLIDER_THUMB_WIDTH,
    y + VOLUME_SLIDER_THUMB_HEIGHT,
    VOLUME_SLIDER_THUMB_WIDTH,
    VOLUME_SLIDER_COLOR,
    "00"
  )
end

local function draw_item_background(ass, cx, cy, content_w)
  if not ICON_BG_ENABLED then return end
  common.draw_rrect(
    ass,
    cx - (content_w / 2 + ICON_BG_PAD_X),
    cy - ICON_BG_HEIGHT / 2,
    cx + (content_w / 2 + ICON_BG_PAD_X),
    cy + ICON_BG_HEIGHT / 2,
    ICON_BG_RADIUS,
    ICON_BG_COLOR,
    ICON_BG_ALPHA
  )
end

local function draw_rrect_outline(ass, x1, y1, x2, y2, radius, color, alpha, width)
  if not width or width <= 0 or alpha == "FF" then return end
  ass:new_event()
  ass:append(string.format(
    "{\\pos(0,0)\\an7\\1a&HFF&\\3c&H%s&\\3a&H%s&\\bord%d\\shad0}",
    color, alpha, width
  ))
  ass:draw_start()
  ass:round_rect_cw(x1, y1, x2, y2, radius)
  ass:draw_stop()
end

local function draw_item_border(ass, cx, cy, content_w)
  if not ICON_BORDER_ENABLED then return end
  local x1 = cx - (content_w / 2 + ICON_BG_PAD_X)
  local x2 = cx + (content_w / 2 + ICON_BG_PAD_X)
  local y1 = cy - ICON_BG_HEIGHT / 2
  local y2 = cy + ICON_BG_HEIGHT / 2
  draw_rrect_outline(
    ass,
    x1,
    y1,
    x2,
    y2,
    ICON_BG_RADIUS,
    ICON_BORDER_COLOR,
    ICON_BORDER_ALPHA,
    ICON_BORDER_WIDTH
  )
end

local function draw_icon_group_background(ass, buttons, row_y)
  if not ICON_GROUP_BG_ENABLED or #buttons == 0 then return end
  local x1 = math.huge
  local x2 = -math.huge
  for _, button in ipairs(buttons) do
    x1 = math.min(x1, button.x - button.width / 2 - ICON_BG_PAD_X)
    x2 = math.max(x2, button.x + button.width / 2 + ICON_BG_PAD_X)
  end
  x1 = x1 - ICON_GROUP_BG_PADDING
  x2 = x2 + ICON_GROUP_BG_PADDING
  local y1 = row_y - ICON_GROUP_BG_HEIGHT / 2
  local y2 = row_y + ICON_GROUP_BG_HEIGHT / 2
  common.draw_rrect(ass, x1, y1, x2, y2, ICON_GROUP_BG_RADIUS, ICON_GROUP_BG_COLOR, ICON_GROUP_BG_ALPHA)
  if ICON_GROUP_BORDER_ENABLED then
    draw_rrect_outline(
      ass,
      x1,
      y1,
      x2,
      y2,
      ICON_GROUP_BG_RADIUS,
      ICON_GROUP_BORDER_COLOR,
      ICON_GROUP_BORDER_ALPHA,
      ICON_GROUP_BORDER_WIDTH
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
  left = { "prev", "play", "next", "stop" },
  center = {},
  right = { "volume", "add", "fullscreen", "playlist" },
}

local function configured_button_layout()
  local layout = { left = {}, center = {}, right = {} }
  local configured = false
  local has_named_button = false

  for _, group in ipairs({
    { name = "left", prefix = "L" },
    { name = "center", prefix = "C" },
    { name = "right", prefix = "R" },
  }) do
    for i = 1, 6 do
      local value = theme["osc_" .. group.prefix .. i]
      if value ~= nil then configured = true end
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

  if VOLUME_SLIDER_MUTE then
    local mute_width = VOLUME_SLIDER_MUTE_WIDTH
    local total_item_width = mute_width
      + VOLUME_SLIDER_MUTE_GAP
      + VOLUME_SLIDER_WIDTH
      + VOLUME_SLIDER_PAD_LEFT
      + VOLUME_SLIDER_PAD_RIGHT

    slider_x1 = button.x
      + total_item_width / 2
      - VOLUME_SLIDER_WIDTH
      - VOLUME_SLIDER_PAD_RIGHT
  else
    local total_item_width = VOLUME_SLIDER_WIDTH
      + VOLUME_SLIDER_PAD_LEFT
      + VOLUME_SLIDER_PAD_RIGHT

    slider_x1 = button.x
      - total_item_width / 2
      + VOLUME_SLIDER_PAD_LEFT
  end

  return {
    slider_x1 = slider_x1,
    slider_x2 = slider_x1 + VOLUME_SLIDER_WIDTH,
  }
end

local function set_volume_from_y(py, geo)
  local r = (geo.track_y2 - py) / (geo.track_y2 - geo.track_y1)
  mp.set_property_number("volume", math.min(1, math.max(0, r)) * 100)
end

local function set_volume_from_x(px, button)
  if not px or not button then return end

  local geo = get_volume_slider_geometry(button)
  local slider_w = geo.slider_x2 - geo.slider_x1

  local ratio = (px - geo.slider_x1) / slider_w
  ratio = math.min(1, math.max(0, ratio))

  mp.set_property_number("volume", ratio * 100)
end

local BUTTONS = {
  prev = {
    icon = ICON.prev,
    click = function() run_playlist_action("playlist-prev", "playlist-prev") end,
  },
  seek_back = {
    icon = ICON.seek_back,
    click = function() mp.commandv("seek", -10, "relative") end,
  },
  play = {
    icon = function() return paused and ICON.play or ICON.pause end,
    click = function() mp.commandv("cycle", "pause") end,
  },
  pause = {
    icon = ICON.pause,
    click = function() mp.set_property_bool("pause", true) end,
  },
  seek_forward = {
    icon = ICON.seek_forward,
    click = function() mp.commandv("seek", 10, "relative") end,
  },
  next = {
    icon = ICON.next,
    click = function() run_playlist_action("playlist-next", "playlist-next") end,
  },
  stop = {
    icon = ICON.stop,
    click = function() mp.commandv("stop", "keep-playlist") end,
  },
  volume = {
    icon = function()
    return (muted or volume == 0) and ICON.volume_off or ICON.volume_up
    end,

    click = function()
    volume_popup_open = not volume_popup_open
    add_menu_open = false
    end,
  },
  volume_slider = {
    kind = "volume_slider",

    click = function(px, py, button)
    if not button then return end

    volume_slider_dragging = true
    set_volume_from_x(px, button)
    end,
  },
  mute = {
    icon = function()
    return muted and ICON.volume_off or ICON.volume_up
    end,

    click = function()
    mp.commandv("cycle", "mute")
    end,
  },
  add = {
    icon = ICON.add,
    click = function()
      add_menu_open = not add_menu_open
      volume_popup_open = false
    end,
  },
  fullscreen = {
    icon = ICON.fullscreen,
    click = function() mp.commandv("cycle", "fullscreen") end,
  },
  playlist = {
    icon = ICON.playlist,
    alpha = function()
      return mp.get_property_native("user-data/cadre_playlist/visible", false) and "00" or "60"
    end,
    click = function() run_playlist_action("toggle-playlist", "show-text ${playlist}") end,
  },
  time = {
    kind = "time",
    click = function() end,
  },
}

local function normalize_chapters(raw)
    local out = {}
    if type(raw) ~= "table" then return out end
    for i, c in ipairs(raw) do
        local t = c.time
        if type(t) == "number" then
            out[#out + 1] = {
                time = t,
                title = (c.title and c.title ~= "" and c.title) or ("Chapter " .. i),
            }
        end
    end
    table.sort(out, function(a, b) return a.time < b.time end)
    return out
end

local function ratio_to_x(bar_x1, bar_w, ratio)
    return bar_x1 + bar_w * math.min(1, math.max(0, ratio))
end

local function draw_chapter_marks(ass, bar_x1, bar_x2, bar_w, seek_y, track_h, dur)
    if not dur or dur <= 0 or #chapters == 0 then return end
    local half_h = track_h / 2
    for _, c in ipairs(chapters) do
        if c.time > 0 and c.time < dur then
            local cx = ratio_to_x(bar_x1, bar_w, c.time / dur)
            local mx1 = math.max(bar_x1, cx - CHAPTER_MARK_W)
            local mx2 = math.min(bar_x2, cx + CHAPTER_MARK_W)
            if mx2 > mx1 then
                common.draw_rrect(ass, mx1, seek_y - half_h, mx2, seek_y + half_h, 0, CHAPTER_MARK_COLOR, CHAPTER_MARK_ALPHA)
            end
        end
    end
end

local function find_hovered_chapter(bar_x1, bar_w, dur, px)
    if not dur or dur <= 0 or #chapters == 0 then return nil end
    for _, c in ipairs(chapters) do
        if c.time > 0 and c.time < dur then
            local cx = ratio_to_x(bar_x1, bar_w, c.time / dur)
            if math.abs(px - cx) <= CHAPTER_HOVER_PX then
                return c
            end
        end
    end
    return nil
end

local function button_dimensions(id)
  if id == "time" then
    return TIME_ITEM_WIDTH, FONT_SIZE
  end

  if id == "volume_slider" then
  local width = VOLUME_SLIDER_WIDTH
    + VOLUME_SLIDER_PAD_LEFT
    + VOLUME_SLIDER_PAD_RIGHT

  if VOLUME_SLIDER_MUTE then
    width = VOLUME_SLIDER_MUTE_WIDTH
      + VOLUME_SLIDER_MUTE_GAP
      + VOLUME_SLIDER_WIDTH
      + VOLUME_SLIDER_PAD_LEFT
      + VOLUME_SLIDER_PAD_RIGHT
  end

  local height = math.max(
    VOLUME_SLIDER_HEIGHT,
      VOLUME_SLIDER_THUMB_HEIGHT,
      ICON_SIZE
    )

    return width, height
  end

  return ICON_SIZE, ICON_SIZE
end

--------------------------------------------------------------------------------
-- LAYOUT
--------------------------------------------------------------------------------

local function get_layout()
  local natural_x1 = BAR_SIDE_INSET
  local natural_x2 = screen_w - BAR_SIDE_INSET
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
  if BAR_Y_ANCHOR == "top" then
    pill_y1 = BAR_TOP_INSET
    pill_y2 = pill_y1 + BAR_HEIGHT
  elseif BAR_Y_ANCHOR == "center" then
    pill_y1 = (screen_h - BAR_HEIGHT) / 2
    pill_y2 = pill_y1 + BAR_HEIGHT
  else
    pill_y2 = screen_h - BAR_BOTTOM_INSET
    pill_y1 = pill_y2 - BAR_HEIGHT
  end

  local seek_y = pill_y1 + SEEK_Y_OFFSET
  local row_y = BUTTON_Y_ANCHOR == "bottom"
    and pill_y2 - BUTTON_ROW_OFFSET
    or pill_y1 + BUTTON_ROW_OFFSET
  local spacing = ICON_SPACING

  local seek_x1, seek_x2 = pill_x1 + SEEK_SIDE_INSET, pill_x2 - SEEK_SIDE_INSET
  local button_x1, button_x2 = pill_x1 + BUTTON_LEFT_INSET, pill_x2 - BUTTON_RIGHT_INSET

  local button_layout, has_named_button = configured_button_layout()
  local positions = { left = {}, center = {}, right = {}, by_id = {} }

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
    local gap = math.max(0, spacing - ICON_SIZE)
    for index = 1, #ids do
      local id = direction < 0 and ids[#ids - index + 1] or ids[index]
      local width, height = button_dimensions(id)
      local x = direction > 0 and cursor + width / 2 or cursor - width / 2
      local button = { id = id, x = x, width = width, height = height }
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
    local center_gap = math.max(0, spacing - ICON_SIZE)
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
    positions = { left = {}, center = {}, right = {}, by_id = {} }
    place_all_groups()
  end

  return {
    pill_x1 = pill_x1, pill_x2 = pill_x2, pill_y1 = pill_y1, pill_y2 = pill_y2,
    seek_x1 = seek_x1, seek_x2 = seek_x2,
    button_x1 = button_x1, button_x2 = button_x2,
    seek_y = seek_y, row_y = row_y,
    buttons = positions,
  }
end

--------------------------------------------------------------------------------
-- VOLUME FLYOUT
--------------------------------------------------------------------------------

local function compute_popup_geo(L)
  local card_w, card_h = 44, 158
  local cx = L.buttons.by_id.volume
  if not cx then return nil end
  local card_x1, card_x2 = cx - card_w / 2, cx + card_w / 2
  local card_y2 = L.pill_y1 - 10
  local card_y1 = card_y2 - card_h
  local track_y1, track_y2 = card_y1 + 18, card_y2 - 54
  local mute_y = card_y2 - 18
  return {
    cx = cx,
    card_x1 = card_x1, card_x2 = card_x2,
    card_y1 = card_y1, card_y2 = card_y2,
    track_y1 = track_y1, track_y2 = track_y2,
    mute_y = mute_y,
  }
end

local function render_volume_popup(ass, geo)
  common.draw_rrect(ass, geo.card_x1, geo.card_y1, geo.card_x2, geo.card_y2, 10, BARBG, "10")

  ass:new_event()
  ass:append(string.format("{\\pos(0,0)\\an7\\1c&H%s&\\1a&H00&\\bord0\\shad0}", SLIDER_RAIL))
  ass:draw_start()
  ass:round_rect_cw(geo.cx - 2, geo.track_y1, geo.cx + 2, geo.track_y2, 2)
  ass:draw_stop()

  local vol_ratio = math.min(1, math.max(0, volume / 100))
  local fill_y1 = geo.track_y2 - (geo.track_y2 - geo.track_y1) * vol_ratio

  common.draw_rrect(ass, geo.cx - 2, fill_y1, geo.cx + 2, geo.track_y2, 2, TRACK_FG, "00")

  ass:new_event()
  ass:append("{\\pos(0,0)\\an7\\1c&HFFFFFF&\\1a&H00&\\bord0\\shad0}")
  ass:draw_start()
  ass:round_rect_cw(geo.cx - 6, fill_y1 - 6, geo.cx + 6, fill_y1 + 6, 6)
  ass:draw_stop()

  common.draw_text(ass, math.floor(volume) .. "%", geo.cx, geo.card_y2 - 38, FONT_SIZE, TEXT, "10", 2, false)

  draw_icon(ass, muted and ICON.volume_off or ICON.volume_up, geo.cx, geo.mute_y, 18, ICON_COLOR, muted and "00" or "40")

  add_hitbox("volume_mute", geo.cx - 16, geo.mute_y - 14, geo.cx + 16, geo.mute_y + 14, function()
    mp.commandv("cycle", "mute")
  end)

  add_hitbox("volume_track", geo.cx - 14, geo.track_y1 - 12, geo.cx + 14, geo.track_y2 + 12, function(px, py)
    volume_dragging = true
    set_volume_from_y(py, geo)
  end)
  add_hitbox("volume_card_bg", geo.card_x1, geo.card_y1, geo.card_x2, geo.card_y2, function() end)
end

--------------------------------------------------------------------------------
-- ADD-FILE FLYOUT MENU
--------------------------------------------------------------------------------

local function compute_add_menu_geo(L)
  local card_w, card_h = 190, 3 * 36 + 12
  local cx = L.buttons.by_id.add
  if not cx then return nil end
  local card_x1, card_x2 = cx - card_w / 2, cx + card_w / 2
  local card_y2 = L.pill_y1 - 10
  local card_y1 = card_y2 - card_h
  return { cx = cx, card_x1 = card_x1, card_x2 = card_x2, card_y1 = card_y1, card_y2 = card_y2, row_h = 36 }
end

local function render_add_menu(ass, geo)
  common.draw_rrect(ass, geo.card_x1, geo.card_y1, geo.card_x2, geo.card_y2, 10, BARBG, "10")

  local entries = {
    { label = "Add file",   icon = ICON.add_file,   cb = common.do_add_file },
    { label = "Add folder", icon = ICON.add_folder, cb = common.do_add_folder },
    { label = "Add URL",    icon = ICON.add_url,    cb = common.do_add_url },
  }

  for i, e in ipairs(entries) do
    local row_y1 = geo.card_y1 + 6 + (i - 1) * geo.row_h
    local row_y2 = row_y1 + geo.row_h
    local mid_y = (row_y1 + row_y2) / 2
    draw_icon(ass, e.icon, geo.card_x1 + 24, mid_y, 16, ICON_COLOR, dim)
    common.draw_text(ass, e.label, geo.card_x1 + 42, mid_y, 16, TEXT, "00", 4, false)
    add_hitbox("add_menu_" .. i, geo.card_x1, row_y1, geo.card_x2, row_y2, function()
      add_menu_open = false
      e.cb()
    end)
  end
end

--------------------------------------------------------------------------------
-- MAIN RENDER
--------------------------------------------------------------------------------

local function render()
  hitboxes = common.new_hitboxes()
  local ass = assdraw.ass_new()

  if not bar_visible then
    osd.data = ""
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
  ass:append(string.format("{\\pos(0,0)\\an7\\1c&H%s&\\1a&H%s&\\bord0\\shad0}", BARBG, ALPHA_BAR_BG))
  ass:draw_start()
  ass:round_rect_cw(L.pill_x1, L.pill_y1, L.pill_x2, L.pill_y2, BAR_RADIUS)
  ass:draw_stop()

  local hovering_seek = (mouse_y >= L.seek_y - 8 and mouse_y <= L.seek_y + 8 and mouse_x >= L.seek_x1 and mouse_x <= L.seek_x2)
  local track_h = hovering_seek and SEEK_HEIGHT_HOVER or SEEK_HEIGHT_NORMAL
  local bar_x1, bar_x2 = L.seek_x1, L.seek_x2
  local bar_w = bar_x2 - bar_x1

  common.draw_rrect(ass, bar_x1, L.seek_y - track_h / 2, bar_x2, L.seek_y + track_h / 2, track_h / 2, TRACK_BG, "00")

  local ratio = (duration and duration > 0) and math.min(1, math.max(0, position / duration)) or 0
  local filled_x = bar_x1 + bar_w * ratio
  if filled_x > bar_x1 then
    common.draw_rrect(ass, bar_x1, L.seek_y - track_h / 2, filled_x, L.seek_y + track_h / 2, track_h / 2, TRACK_FG, "00")
  end  

  draw_chapter_marks(ass, bar_x1, bar_x2, bar_w, L.seek_y, track_h, duration)

  draw_rrect_outline(
    ass,
    bar_x1,
    L.seek_y - track_h / 2,
    bar_x2,
    L.seek_y + track_h / 2,
    track_h / 2,
    SEEK_BORDER_COLOR,
    SEEK_BORDER_ALPHA,
    SEEK_BORDER_WIDTH
  )

  common.draw_rrect(ass, filled_x - THUMB_W, L.seek_y - THUMB_H, filled_x + THUMB_W, L.seek_y + THUMB_H, THUMB_RADIUS, THUMB_COLOR, "00")
  draw_rrect_outline(
    ass,
    filled_x - THUMB_W,
    L.seek_y - THUMB_H,
    filled_x + THUMB_W,
    L.seek_y + THUMB_H,
    THUMB_RADIUS,
    THUMB_BORDER_COLOR,
    THUMB_BORDER_ALPHA,
    THUMB_BORDER_WIDTH
  )

  local measure_osd = mp.create_osd_overlay("ass-events")
  measure_osd.hidden = true
  measure_osd.compute_bounds = true


  local function measure_text_width(text, font_size, font)
      local f = font or UI_FONT
      local osd_w, osd_h = mp.get_osd_size()

      measure_osd.res_x = osd_w
      measure_osd.res_y = osd_h

      measure_osd.data = string.format(
          "{\\pos(1000,1000)\\an5\\fn%s\\fs%d"
          .. "\\1c&HFFFFFF&\\1a&H00&\\bord0\\shad0\\b0}%s",
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

  if hovering_seek and hovered_chapter and hovered_chapter.title then
      local text_w = measure_text_width(
          hovered_chapter.title,
          CHAPTER_TOOLTIP_FONT_SIZE,
          UI_FONT
      )

      text_w = text_w + 2

      local pad_x = CHAPTER_TOOLTIP_PAD_X or 0
      local pad_y = CHAPTER_TOOLTIP_PAD_Y or 3

      local pill_w = text_w + pad_x * 2
      local pill_h = CHAPTER_TOOLTIP_FONT_SIZE + pad_y * 2

      local max_pill_w = (bar_x2 - bar_x1) - 12
      pill_w = math.min(pill_w, max_pill_w)

      local half_w = pill_w / 2

      local target_x = math.min(
          bar_x2 - half_w - 6,
          math.max(bar_x1 + half_w + 6, mouse_x)
      )

      local center_y = L.seek_y - CHAPTER_TOOLTIP_OFFSET_Y

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
          CHAPTER_TOOLTIP_RADIUS,
          CHAPTER_TOOLTIP_BG_COLOR,
          CHAPTER_TOOLTIP_BG_ALPHA
      )

      common.draw_text(
          ass,
          hovered_chapter.title,
          target_x,
          center_y,
          CHAPTER_TOOLTIP_FONT_SIZE,
          TEXT,
          "00",
          5,
          false
      )
  end
  add_hitbox("seekbar", bar_x1, L.seek_y - 10, bar_x2, L.seek_y + 10, function(px)
    seek_dragging = true
    if duration and duration > 0 then
    local r = (px - bar_x1) / bar_w
    mp.commandv("seek", math.min(1, math.max(0, r)) * duration, "absolute")
    end
  end)

  local dim = ICON_DIM_A
  for _, group in ipairs({ "left", "center", "right" }) do
    draw_icon_group_background(ass, L.buttons[group], L.row_y)
    for _, button in ipairs(L.buttons[group]) do
      local definition = BUTTONS[button.id]
      draw_item_background(ass, button.x, L.row_y, button.width)
      draw_item_border(ass, button.x, L.row_y, button.width)

      if definition.kind == "time" then
        draw_time_label(
          ass,
          fmt_time(position) .. " / " .. fmt_time(duration),
          button.x,
          L.row_y,
          5
        )

        elseif definition.kind == "volume_slider" then
          draw_volume_slider(ass, button.x, L.row_y)

        else
          local glyph = type(definition.icon) == "function" and definition.icon() or definition.icon
          local alpha = definition.alpha and definition.alpha() or dim
          draw_icon(ass, glyph, button.x, L.row_y, ICON_SIZE, ICON_COLOR, alpha)
        end

      local item_pad_x = ICON_BG_ENABLED and ICON_BG_PAD_X or 0
      local hitbox_half_w = math.max(16, button.width / 2 + item_pad_x)
      local hitbox_half_h = math.max(16, ICON_BG_ENABLED and ICON_BG_HEIGHT / 2 or button.height / 2)

      if definition.kind == "volume_slider" and VOLUME_SLIDER_MUTE then
        local mute_width = VOLUME_SLIDER_MUTE_WIDTH
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
          geo.slider_x1 - VOLUME_SLIDER_THUMB_WIDTH - 4,
          L.row_y - hitbox_half_h,
          geo.slider_x2 + VOLUME_SLIDER_THUMB_WIDTH + 4,
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

  local time_label_y = L.seek_y + TIME_LABEL_OFFSET_Y + 3
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

  osd.data = ass.text
  osd.res_x = screen_w
  osd.res_y = screen_h
  osd:update()
end

--------------------------------------------------------------------------------
-- VISIBILITY
--------------------------------------------------------------------------------

local function mouse_in_active_zone()
  if volume_dragging or volume_slider_dragging then return true end
  local L = get_layout()
  if mouse_y >= L.pill_y1 - 20 and mouse_x >= L.pill_x1 - 20 and mouse_x <= L.pill_x2 + 20 then
    return true
  end
  if popup_geo and mouse_x >= popup_geo.card_x1 - 14 and mouse_x <= popup_geo.card_x2 + 14
    and mouse_y >= popup_geo.card_y1 - 14 and mouse_y <= popup_geo.card_y2 + 14 then
    return true
  end
  if add_menu_geo and mouse_x >= add_menu_geo.card_x1 - 14 and mouse_x <= add_menu_geo.card_x2 + 14
    and mouse_y >= add_menu_geo.card_y1 - 14 and mouse_y <= add_menu_geo.card_y2 + 14 then
    return true
  end
  return false
end

local function restart_hide_timer()
  if hide_timer then hide_timer:kill() end
  if not file_loaded then return end
  hide_timer = mp.add_timeout(AUTOHIDE_SEC, function()
    if volume_dragging or volume_slider_dragging or mouse_in_active_zone() then
      restart_hide_timer()
    else
      bar_visible = false
      volume_popup_open = false
      add_menu_open = false
      render()
    end
  end)
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
    if hide_timer then hide_timer:kill() end
    bar_visible = false
    volume_popup_open = false
    add_menu_open = false
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
  local hovering_seek = (mouse_y >= L.seek_y - 10 and mouse_y <= L.seek_y + 10
    and mouse_x >= bar_x1 and mouse_x <= bar_x2)

  if hovering_seek and duration and duration > 0 and not thumbfast.disabled then
    local ratio = (mouse_x - bar_x1) / (bar_x2 - bar_x1)
    local hovered_seconds = duration * math.min(1, math.max(0, ratio))
    local display_width = mp.get_property_number("osd-width", screen_w)
    mp.commandv("script-message-to", "thumbfast", "thumb",
      hovered_seconds,
      math.min(display_width - thumbfast.width - 10, math.max(10, mouse_x - thumbfast.width / 2)),
      L.seek_y - 10 - thumbfast.height)
  elseif thumbfast.available then
    mp.commandv("script-message-to", "thumbfast", "clear")
  end
end

--------------------------------------------------------------------------------
-- INPUT
--------------------------------------------------------------------------------

local function point_in_own_ui(px, py)
  local L = get_layout()
  if px >= L.pill_x1 and px <= L.pill_x2 and py >= L.pill_y1 and py <= L.pill_y2 then
    return true
  end
  if popup_geo and px >= popup_geo.card_x1 and px <= popup_geo.card_x2
    and py >= popup_geo.card_y1 and py <= popup_geo.card_y2 then
    return true
  end
  if add_menu_geo and px >= add_menu_geo.card_x1 and px <= add_menu_geo.card_x2
    and py >= add_menu_geo.card_y1 and py <= add_menu_geo.card_y2 then
    return true
  end
  return false
end

local function point_in_published_bounds(prefix, px, py)
  local visible = mp.get_property_native("user-data/" .. prefix .. "/visible", false)
  if not visible then return false end
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

    for _, group in ipairs({ "left", "center", "right" }) do
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
    local hovering_seek = (mouse_y >= L.seek_y - 10 and mouse_y <= L.seek_y + 10
        and mouse_x >= bar_x1 and mouse_x <= bar_x2)

    local new_hovered = nil
    if hovering_seek then
        new_hovered = find_hovered_chapter(bar_x1, bar_x2 - bar_x1, duration, mouse_x)
    end

    if new_hovered ~= hovered_chapter then
        hovered_chapter = new_hovered
        if bar_visible then render() end
    end
end

update_hovered_chapter()
  local hovering_hitbox = false
    for _, b in ipairs(hitboxes) do
      if point_in(mouse_x, mouse_y, b) then hovering_hitbox = true break end
    end
    mp.commandv("script-message", "python-bridge", "osc-hover", tostring(hovering_hitbox))

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
          if not bar_visible then show_bar() end
          return
      end

      if not bar_visible then
          show_bar()
          return
      end

      if volume_popup_open and popup_geo then
          local in_popup = mouse_x >= popup_geo.card_x1 and mouse_x <= popup_geo.card_x2
              and mouse_y >= popup_geo.card_y1 and mouse_y <= popup_geo.card_y2
          if in_popup then
              for _, b in ipairs(hitboxes) do
                  if (b.name == "volume_track" or b.name == "volume_mute" or b.name == "volume_card_bg")
                    and point_in(mouse_x, mouse_y, b) then
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
          local in_menu = mouse_x >= add_menu_geo.card_x1 and mouse_x <= add_menu_geo.card_x2
              and mouse_y >= add_menu_geo.card_y1 and mouse_y <= add_menu_geo.card_y2
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

      for _, b in ipairs(hitboxes) do
        if point_in(mouse_x, mouse_y, b) then
          if b.name == "seekbar"
            or b.name == "volume_track"
            or b.name == "button_volume_slider_track" then
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

mp.observe_property("mouse-pos", "native", function(_, pos)
  if pos then
    mouse_x = pos.x or -1
    mouse_y = pos.y or -1
    on_mouse_move()
  end
end)
mp.set_property_native("user-data/cadre_osc/mbtn_bound", true)
mp.add_forced_key_binding("MBTN_LEFT", "cadre_mbtn_left", on_mbtn_left, { complex = true })
mp.add_forced_key_binding("Ctrl+MBTN_LEFT", "cadre_ctrl_mbtn_left", on_mbtn_left, { complex = true })
mp.add_forced_key_binding("Shift+MBTN_LEFT", "cadre_shift_mbtn_left", on_mbtn_left, { complex = true })
mp.add_forced_key_binding("Ctrl+Shift+MBTN_LEFT", "cadre_ctrl_shift_mbtn_left", on_mbtn_left, { complex = true })
mp.register_event("client-message", function() end)
mp.add_key_binding("MBTN_LEFT_DBL", "cadre_mbtn_left_dbl", function()
  local in_playlist_area = point_in_playlist_ui(mouse_x, mouse_y)
  local in_titlebar_area = point_in_titlebar_ui(mouse_x, mouse_y)
  if in_playlist_area or in_titlebar_area then return end
  if point_in_own_ui(mouse_x, mouse_y) then return end
  mp.commandv("cycle", "fullscreen")
end)

--------------------------------------------------------------------------------
-- PROPERTY OBSERVERS
--------------------------------------------------------------------------------

mp.observe_property("osd-dimensions", "native", function(name, val)
  if not val then return end
  screen_w = val.w
  screen_h = val.h
  render() 
end)

mp.observe_property("duration", "number", function(_, v) duration = v or 0; render() end)
mp.observe_property("time-pos", "number", function(_, v) position = v or 0; if bar_visible then render() end end)
mp.observe_property("pause", "bool", function(_, v) paused = v; render() end)
mp.observe_property("mute", "bool", function(_, v) muted = v; render() end)
mp.observe_property("volume", "number", function(_, v) volume = v or 100; render() end)

mp.observe_property("chapter-list", "native", function(_, raw)
    chapters = normalize_chapters(raw)
    hovered_chapter = nil
    render()
end)

mp.register_event("playback-restart", function()
    local raw = mp.get_property_native("chapter-list", {})
    local normalized = normalize_chapters(raw)
    if #normalized ~= #chapters then
        chapters = normalized
        render()
    end
end)

mp.register_event("file-loaded", function()
    local existing = mp.get_property_native("chapter-list", {})
    if #existing == 0 then
    load_youtube_chapters()
    end
end)

mp.observe_property("path", "string", function(_, v)
  file_loaded = (v ~= nil and v ~= "")
  if file_loaded then
    restart_hide_timer()
  else
    bar_visible = true
    if hide_timer then hide_timer:kill() end
  end
  render()
end)

render()