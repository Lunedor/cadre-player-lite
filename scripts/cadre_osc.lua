--[[
cadre_osc.lua (control bar)
]]

local mp = require 'mp'
local assdraw = require 'mp.assdraw'
local utils = require 'mp.utils'
local msg = require 'mp.msg'

local common_path = mp.find_config_file("scripts/cadre_common.lua")
local common = dofile(common_path)

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

local ICON_FONT = "Material Icons Outlined"
local ICON_COLOR = common.bgr(theme.color_icon_osc or theme.color_icon or "F2E8F0")
local TEXT = common.bgr(theme.color_text_osc or theme.color_text or "F1F5F9")
local BARBG = common.bgr(theme.color_bar_bg_osc or theme.color_bar_bg or "0F1115")
local ALPHA_BAR_BG = theme.alpha_bar_bg_osc or theme.alpha_bar_bg or "18"
local TRACK_FG = common.bgr(theme.color_track_fg_osc or theme.color_track_fg or "FFFFFF")
local TRACK_BG = common.bgr(theme.color_track_bg_osc or theme.color_track_bg or "2B303C")
local SLIDER_RAIL = common.bgr(theme.color_slider_rail_osc or theme.color_slider_rail or theme.color_track_bg or "2B303C")
local ICON_DIM_A = theme.color_icon_dim or "60"
local BAR_RADIUS = theme.bar_radius or 0
local BAR_SIDE_INSET = theme.bar_side_inset or 16
local BAR_BOTTOM_INSET = theme.bar_bottom_inset or 30
local AUTOHIDE_SEC = theme.bar_autohide_sec or 0.5
local THUMB_W = theme.thumb_width or 4  -- Half-width of the current position indicator
local THUMB_H = theme.thumb_height or 8  -- Half-height of the current position indicator
local THUMB_RADIUS = theme.thumb_radius or 2    -- Controls the shape (0 = square, 6 = circle)
local THUMB_COLOR = common.bgr(theme.thumb_color or theme.color_track_fg_osc or theme.color_track_fg or "FFFFFF")
local BAR_HEIGHT = theme.bar_height or 90
local SEEK_Y_OFFSET = theme.seek_y_offset or 15   -- Padding from the top of the background to the seek bar
local ICON_ROW_OFFSET = theme.icon_row_offset or 60 -- Padding from the top of the background to the icons
local ICON_SPACING = theme.icon_spacing or 38    -- Horizontal space between each icon
local SEEK_HEIGHT_NORMAL = theme.seek_height_normal or 10
local SEEK_HEIGHT_HOVER = theme.seek_height_hover or 12
local TIME_LABEL_OFFSET_Y = theme.time_label_offset_y or 15
local SIDE_MARGIN = theme.side_margin or 20
local ICON_SIZE = theme.icon_size or 26

local ICON = {
  play = "\u{E037}",
  pause = "\u{E034}",
  prev = "\u{E045}",
  next = "\u{E044}",
  stop = "\u{E047}",
  volume_up = "\u{E050}",
  volume_off = "\u{E04F}",
  add = "\u{E145}",
  fullscreen = "\u{E5D0}",
  playlist = "\u{E05F}",
  add_file = "\u{E24D}",
  add_folder = "\u{E2CC}",
  add_url = "\u{E157}",
}

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
local seek_dragging = false
local hitboxes = {}
local popup_geo = nil
local add_menu_geo = nil

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

local function add_hitbox(name, x1, y1, x2, y2, cb) common.add_hitbox(hitboxes, name, x1, y1, x2, y2, cb) end
local function point_in(px, py, b) return common.point_in(px, py, b) end
local function draw_icon(ass, glyph, cx, cy, size, color, alpha) common.draw_icon(ass, ICON_FONT, glyph, cx, cy, size, color, alpha) end

--------------------------------------------------------------------------------
-- LAYOUT
--------------------------------------------------------------------------------

local function get_layout()
  local natural_x1 = BAR_SIDE_INSET
  local natural_x2 = screen_w - BAR_SIDE_INSET
  local natural_w = natural_x2 - natural_x1
  local BAR_MAX_WIDTH = theme.max_bar_width or screen_w

  local pill_x1, pill_x2
  if natural_w > BAR_MAX_WIDTH then
    local cx = screen_w / 2
    pill_x1 = cx - BAR_MAX_WIDTH / 2
    pill_x2 = cx + BAR_MAX_WIDTH / 2
  else
    pill_x1 = natural_x1
    pill_x2 = natural_x2
  end

  local pill_y2 = screen_h - BAR_BOTTOM_INSET
  local pill_y1 = pill_y2 - BAR_HEIGHT

  local seek_y = pill_y1 + SEEK_Y_OFFSET
  local row_y = pill_y1 + ICON_ROW_OFFSET
  local spacing = ICON_SPACING

  local bar_x1, bar_x2 = pill_x1 + SIDE_MARGIN, pill_x2 - SIDE_MARGIN
  local icon_half = ICON_SIZE / 2

  local x = bar_x1 + icon_half
  local prev_x = x; x = x + spacing
  local play_x = x; x = x + spacing
  local next_x = x; x = x + spacing
  local stop_x = x; x = x + spacing
  local time_x = x + 16

  local rx = bar_x2 - icon_half
  local playlist_x = rx; rx = rx - spacing
  local fullscreen_x = rx; rx = rx - spacing
  local add_x = rx; rx = rx - spacing
  local volume_x = rx

  return {
    pill_x1 = pill_x1, pill_x2 = pill_x2, pill_y1 = pill_y1, pill_y2 = pill_y2,
    bar_x1 = bar_x1, bar_x2 = bar_x2,
    seek_y = seek_y, row_y = row_y,
    prev_x = prev_x, play_x = play_x, next_x = next_x, stop_x = stop_x, time_x = time_x,
    volume_x = volume_x, add_x = add_x,
    fullscreen_x = fullscreen_x, playlist_x = playlist_x,
  }
end

--------------------------------------------------------------------------------
-- VOLUME FLYOUT
--------------------------------------------------------------------------------

local function compute_popup_geo(L)
  local card_w, card_h = 44, 130
  local cx = L.volume_x
  local card_x1, card_x2 = cx - card_w / 2, cx + card_w / 2
  local card_y2 = L.pill_y1 - 10
  local card_y1 = card_y2 - card_h
  local track_y1, track_y2 = card_y1 + 18, card_y2 - 28
  return { cx = cx, card_x1 = card_x1, card_x2 = card_x2, card_y1 = card_y1, card_y2 = card_y2, track_y1 = track_y1, track_y2 = track_y2 }
end

local function set_volume_from_y(py, geo)
  local r = (geo.track_y2 - py) / (geo.track_y2 - geo.track_y1)
  mp.set_property_number("volume", math.min(1, math.max(0, r)) * 100)
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

  common.draw_text(ass, math.floor(volume) .. "%", geo.cx, geo.card_y2 - 10, 14, TEXT, "10", 2, false)

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
  local cx = L.add_x
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

  local hovering_seek = (mouse_y >= L.seek_y - 8 and mouse_y <= L.seek_y + 8 and mouse_x >= L.pill_x1 + SIDE_MARGIN and mouse_x <= L.pill_x2 - SIDE_MARGIN)
  local track_h = hovering_seek and SEEK_HEIGHT_HOVER or SEEK_HEIGHT_NORMAL
  local bar_x1, bar_x2 = L.pill_x1 + SIDE_MARGIN, L.pill_x2 - SIDE_MARGIN
  local bar_w = bar_x2 - bar_x1

  common.draw_rrect(ass, bar_x1, L.seek_y - track_h / 2, bar_x2, L.seek_y + track_h / 2, track_h / 2, TRACK_BG, "00")

  local ratio = (duration and duration > 0) and math.min(1, math.max(0, position / duration)) or 0
  local filled_x = bar_x1 + bar_w * ratio
  if filled_x > bar_x1 then
    common.draw_rrect(ass, bar_x1, L.seek_y - track_h / 2, filled_x, L.seek_y + track_h / 2, track_h / 2, TRACK_FG, "00")
  end

  common.draw_rrect(ass, filled_x - THUMB_W, L.seek_y - THUMB_H, filled_x + THUMB_W, L.seek_y + THUMB_H, THUMB_RADIUS, THUMB_COLOR, "00")

  add_hitbox("seekbar", bar_x1, L.seek_y - 10, bar_x2, L.seek_y + 10, function(px)
    seek_dragging = true
    if duration and duration > 0 then
      local r = (px - bar_x1) / bar_w
      mp.commandv("seek", math.min(1, math.max(0, r)) * duration, "absolute")
    end
  end)

  local dim = ICON_DIM_A

  draw_icon(ass, ICON.prev, L.prev_x, L.row_y, ICON_SIZE, ICON_COLOR, dim)
  add_hitbox("prev", L.prev_x - 16, L.row_y - 16, L.prev_x + 16, L.row_y + 16, function()
    mp.commandv("script-message", "playlist-prev")
  end)

  draw_icon(ass, paused and ICON.play or ICON.pause, L.play_x, L.row_y, ICON_SIZE, ICON_COLOR, dim)
  add_hitbox("playpause", L.play_x - 16, L.row_y - 16, L.play_x + 16, L.row_y + 16, function()
    mp.commandv("cycle", "pause")
  end)

  draw_icon(ass, ICON.next, L.next_x, L.row_y, ICON_SIZE, ICON_COLOR, dim)
  add_hitbox("next", L.next_x - 16, L.row_y - 16, L.next_x + 16, L.row_y + 16, function()
    mp.commandv("script-message", "playlist-next")
  end)

  draw_icon(ass, ICON.stop, L.stop_x, L.row_y, ICON_SIZE, ICON_COLOR, dim)
  add_hitbox("stop", L.stop_x - 16, L.row_y - 16, L.stop_x + 16, L.row_y + 16, function()
    mp.commandv("stop", "keep-playlist")
  end)

  local time_label_y = L.seek_y + TIME_LABEL_OFFSET_Y + 3
  common.draw_text(ass, fmt_time(position), bar_x1, time_label_y, 16, TEXT, "10", 4, false)
  common.draw_text(ass, fmt_time(duration), bar_x2, time_label_y, 16, TEXT, "10", 6, false)

  draw_icon(ass, (muted or volume == 0) and ICON.volume_off or ICON.volume_up, L.volume_x, L.row_y, ICON_SIZE, ICON_COLOR, dim)
  add_hitbox("volume", L.volume_x - 16, L.row_y - 16, L.volume_x + 16, L.row_y + 16, function()
    volume_popup_open = not volume_popup_open
    add_menu_open = false
  end)

  draw_icon(ass, ICON.add, L.add_x, L.row_y, ICON_SIZE, ICON_COLOR, dim)
  add_hitbox("add", L.add_x - 16, L.row_y - 16, L.add_x + 16, L.row_y + 16, function()
    add_menu_open = not add_menu_open
    volume_popup_open = false
  end)

  draw_icon(ass, ICON.fullscreen, L.fullscreen_x, L.row_y, ICON_SIZE, ICON_COLOR, dim)
  add_hitbox("fullscreen", L.fullscreen_x - 16, L.row_y - 16, L.fullscreen_x + 16, L.row_y + 16, function()
    mp.commandv("cycle", "fullscreen")
  end)

  local pl_visible = mp.get_property_native("user-data/cadre_playlist/visible", false)
  draw_icon(ass, ICON.playlist, L.playlist_x, L.row_y, ICON_SIZE, ICON_COLOR, pl_visible and "00" or "60")
  add_hitbox("playlist", L.playlist_x - 16, L.row_y - 16, L.playlist_x + 16, L.row_y + 16, function()
    mp.commandv("script-message", "toggle-playlist")
  end)

  if volume_popup_open then
    popup_geo = compute_popup_geo(L)
    render_volume_popup(ass, popup_geo)
  else
    popup_geo = nil
  end

  if add_menu_open then
    add_menu_geo = compute_add_menu_geo(L)
    render_add_menu(ass, add_menu_geo)
  else
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
  if volume_dragging then return true end
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
    if volume_dragging or mouse_in_active_zone() then
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

local function update_thumbnail_preview()
  local L = get_layout()
  local bar_x1, bar_x2 = L.pill_x1 + SIDE_MARGIN, L.pill_x2 - SIDE_MARGIN
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

  if seek_dragging then
    local L = get_layout()
    local bar_x1, bar_x2 = L.pill_x1 + SIDE_MARGIN, L.pill_x2 - SIDE_MARGIN
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
      mp.commandv("script-message-to", "cadre_playlist", "playlist-mbtn-left-down")

      local in_playlist_area = point_in_playlist_ui(mouse_x, mouse_y)
      local in_titlebar_area = point_in_titlebar_ui(mouse_x, mouse_y)
      local in_osd_area = point_in_own_ui(mouse_x, mouse_y) or in_playlist_area or in_titlebar_area

      mp.commandv("script-message", "python-bridge", "osd-hit", tostring(in_osd_area))

      if in_titlebar_area then
          mp.commandv("script-message-to", "cadre_titlebar", "titlebar-mbtn-left-down")
          return
      end

      if in_playlist_area then
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
                  if (b.name == "volume_track" or b.name == "volume_card_bg") and point_in(mouse_x, mouse_y, b) then
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
              if b.name == "seekbar" or b.name == "volume_track" then
                  b.cb(mouse_x, mouse_y)
              else
                  b.cb()
              end
              render()
              return
          end
      end

  elseif event.event == "up" or event.event == "release" then
      mp.commandv("script-message-to", "cadre_playlist", "playlist-mbtn-left-up")
      mp.commandv("script-message-to", "cadre_titlebar", "titlebar-mbtn-left-up")
      volume_dragging = false
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
  -- Force your script to rebuild hitboxes and redraw now that true dimensions exist
  render() 
end)

mp.observe_property("duration", "number", function(_, v) duration = v or 0; render() end)
mp.observe_property("time-pos", "number", function(_, v) position = v or 0; if bar_visible then render() end end)
mp.observe_property("pause", "bool", function(_, v) paused = v; render() end)
mp.observe_property("mute", "bool", function(_, v) muted = v; render() end)
mp.observe_property("volume", "number", function(_, v) volume = v or 100; render() end)

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