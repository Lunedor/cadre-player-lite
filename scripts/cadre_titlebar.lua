--[[
cadre_titlebar.lua
- Button side is a setting: titlebar_button_side = "left" | "right"
  "left"  = macOS-style order: close, minimize, maximize/zoom (left to right),
            title centered in the remaining space to the right of the buttons.
  "right" = classic Windows order: minimize, maximize, close, ending at the
            right edge (default), title left-aligned near x=16.
- titlebar_show_mode = "auto" | "always" still controls startup visibility.
]]

local mp = require 'mp'
local assdraw = require 'mp.assdraw'
local msg = require 'mp.msg'

local common_path = mp.find_config_file("scripts/cadre_common.lua")
local common = dofile(common_path)
common.register_script("cadre_titlebar")

--------------------------------------------------------------------------------
-- CONFIG
--------------------------------------------------------------------------------
local theme = dofile(mp.find_config_file("scripts/cadre_theme.lua"))

local UI_FONT = theme.font_ui or theme.font_text or "Inter"
local ICON_FONT = "Segoe MDL2 Assets"
local TEXT = common.bgr(theme.color_text_tb or theme.text_color or "E2E8F0")
local TITLE_FONT_SIZE = theme.title_font_size_tb or theme.title_font_size or theme.font_size or 18
local BARBG = common.bgr(theme.color_bar_bg_tb or theme.surface_color or "07080B")
local DANGER = common.bgr(theme.color_danger_tb or theme.danger_color or "EF4444")
local HOVERBG = common.bgr(theme.color_hover_bg_tb or "181C26")

local BUTTONBG = common.bgr(
    theme.color_button_bg_tb or
    theme.color_hover_bg_tb or
    "181C26"
)

local BUTTON_PRESSEDBG = common.bgr(
    theme.color_button_pressed_bg_tb or
    theme.color_button_bg_tb or
    "181C26"
)

local CLOSEBG = common.bgr(
    theme.color_close_bg_tb or
    theme.color_danger_tb or
    "EF4444"
)

local ALPHA_BAR_BG = theme.alpha_bar_bg_tb or theme.alpha_bar_bg or "38"

local ALPHA_BUTTON_BG = theme.alpha_button_bg_tb or "20"
local ALPHA_BUTTON_PRESSED = theme.alpha_button_pressed_bg_tb or "38"
local ALPHA_CLOSE_BG = theme.alpha_close_bg_tb or "70"

local BUTTON_RADIUS = theme.button_radius_tb or 4
local CLOSE_BUTTON_RADIUS = theme.close_button_radius_tb or 4

local BAR_HEIGHT = theme.bar_height_tb or 36
local BUTTON_WIDTH = theme.button_width_tb or 44
local HOVER_STRIP_HEIGHT = theme.hover_strip_height_tb or 10
local HIDE_DELAY_SEC = theme.hide_delay_sec_tb or 0.35
local MAXIMIZE_COOLDOWN_SEC = theme.maximize_cooldown_sec_tb or 0.3

local SHOW_MODE = theme.titlebar_show_mode_tb or theme.titlebar_show_mode or "auto"
local BUTTON_SIDE = theme.titlebar_button_side_tb or theme.titlebar_button_side or "right"

local ICON = {
  minimize = "\238\164\161",   -- U+E921
  maximize = "\238\164\162",   -- U+E922
  restore = "\238\164\163",    -- U+E923
  close = "\238\162\187",      -- U+E8BB
}

--------------------------------------------------------------------------------
-- STATE
--------------------------------------------------------------------------------

local osd = mp.create_osd_overlay("ass-events")
local screen_w, screen_h = 1280, 720
local mouse_x, mouse_y = -1, -1
local bar_visible = false
local hitboxes = {}

local last_maximize_toggle_time = 0
local saved_geometry = ""
local fake_maximized = false
local is_maximized = false
local pressed_button = nil
local pressed_button_token = 0

local function draw_icon(ass, glyph, cx, cy, size, color, alpha)
  common.draw_icon(ass, ICON_FONT, glyph, cx, cy, size, color, alpha)
end

local function get_layout()
    if BUTTON_SIDE == "left" then
        return {
            x1 = 0,
            y1 = 0,
            x2 = screen_w,
            y2 = BAR_HEIGHT,

            close_x1 = 0,
            minimize_x1 = BUTTON_WIDTH,
            maximize_x1 = BUTTON_WIDTH * 2,

            title_x = BUTTON_WIDTH * 3
                + ((screen_w - BUTTON_WIDTH * 3) / 2),
            title_align = "center",
        }
    else
        return {
            x1 = 0,
            y1 = 0,
            x2 = screen_w,
            y2 = BAR_HEIGHT,

            close_x1 = screen_w - BUTTON_WIDTH,
            maximize_x1 = screen_w - BUTTON_WIDTH * 2,
            minimize_x1 = screen_w - BUTTON_WIDTH * 3,

            title_x = 16,
            title_align = "left",
        }
    end
end

--------------------------------------------------------------------------------
-- BOUNDS PUBLISHING
--------------------------------------------------------------------------------

local function publish_bounds(L)
  mp.set_property_native("user-data/cadre_titlebar/visible", bar_visible)
  if bar_visible and L then
    mp.set_property_native("user-data/cadre_titlebar/x1", L.x1)
    mp.set_property_native("user-data/cadre_titlebar/y1", L.y1)
    mp.set_property_native("user-data/cadre_titlebar/x2", L.x2)
    mp.set_property_native("user-data/cadre_titlebar/y2", L.y2)
  end
end

local function update_window_dragging()
  if not bar_visible then return end
  if common.is_script_loaded("cadre_osc")
    and mouse_y >= BAR_HEIGHT then
    return
  end
  local L = get_layout()
  local group_x1 = math.min(L.close_x1, L.minimize_x1, L.maximize_x1)
  local group_x2 = math.max(L.close_x1, L.minimize_x1, L.maximize_x1) + BUTTON_WIDTH
  local over_button = (mouse_x >= group_x1 and mouse_x < group_x2 and mouse_y < BAR_HEIGHT)
  local playlist_visible = mp.get_property_native("user-data/cadre_playlist/visible", false)
  local over_playlist = false
  if playlist_visible then
    local x1 = mp.get_property_native("user-data/cadre_playlist/x1", -1)
    local y1 = mp.get_property_native("user-data/cadre_playlist/y1", -1)
    local x2 = mp.get_property_native("user-data/cadre_playlist/x2", -1)
    local y2 = mp.get_property_native("user-data/cadre_playlist/y2", -1)
    over_playlist = mouse_x >= x1 and mouse_x <= x2 and mouse_y >= y1 and mouse_y <= y2
  end
  mp.set_property_bool("window-dragging", not over_button and not over_playlist)
end
--------------------------------------------------------------------------------
-- RENDER
--------------------------------------------------------------------------------

local function point_in(px, py, b) return common.point_in(px, py, b) end

local function render()
  hitboxes = common.new_hitboxes()
  local ass = assdraw.ass_new()

  local is_fullscreen = mp.get_property_bool("fullscreen", false)
  if is_fullscreen and bar_visible then
    bar_visible = false
  end

  if not bar_visible or is_fullscreen then
    osd.data = ""
    osd:update()
    publish_bounds(nil)
    return
  end

  local L = get_layout()
  publish_bounds(L)

  common.draw_rrect(ass, L.x1, L.y1, L.x2, L.y2, 0, BARBG, ALPHA_BAR_BG)

  local title = mp.get_property("media-title") or mp.get_property("filename") or "No file"
  local align_code = (L.title_align == "center") and 5 or 4
  common.draw_text(ass, title, L.title_x, BAR_HEIGHT / 2, TITLE_FONT_SIZE, TEXT, "00", align_code, false)

  local hover_min = mouse_x >= L.minimize_x1 and mouse_x < L.minimize_x1 + BUTTON_WIDTH and mouse_y < BAR_HEIGHT
  local hover_max = mouse_x >= L.maximize_x1 and mouse_x < L.maximize_x1 + BUTTON_WIDTH and mouse_y < BAR_HEIGHT
  local hover_close = mouse_x >= L.close_x1 and mouse_x < L.close_x1 + BUTTON_WIDTH and mouse_y < BAR_HEIGHT

  if hover_min or pressed_button == "minimize" then
        common.draw_rrect(
            ass,
            L.minimize_x1,
            0,
            L.minimize_x1 + BUTTON_WIDTH,
            BAR_HEIGHT,
            BUTTON_RADIUS,
            pressed_button == "minimize" and BUTTON_PRESSEDBG or BUTTONBG,
            pressed_button == "minimize"
                and ALPHA_BUTTON_PRESSED
                or ALPHA_BUTTON_BG
        )
    end

    if hover_max or pressed_button == "maximize" then
        common.draw_rrect(
            ass,
            L.maximize_x1,
            0,
            L.maximize_x1 + BUTTON_WIDTH,
            BAR_HEIGHT,
            BUTTON_RADIUS,
            pressed_button == "maximize" and BUTTON_PRESSEDBG or BUTTONBG,
            pressed_button == "maximize"
                and ALPHA_BUTTON_PRESSED
                or ALPHA_BUTTON_BG
        )
    end
  draw_icon(
      ass,
      ICON.minimize,
      L.minimize_x1 + BUTTON_WIDTH / 2,
      BAR_HEIGHT / 2,
      10,
      TEXT,
      "20"
  )
  common.add_hitbox(hitboxes, "minimize", L.minimize_x1, 0, L.minimize_x1 + BUTTON_WIDTH, BAR_HEIGHT, function()
    mp.commandv("cycle", "window-minimized")
  end)

  if hover_max or pressed_button == "maximize" then
    common.draw_rrect(
        ass,
        L.maximize_x1,
        0,
        L.maximize_x1 + BUTTON_WIDTH,
        BAR_HEIGHT,
        BUTTON_RADIUS,
        pressed_button == "maximize" and BUTTON_PRESSEDBG or BUTTONBG,
        pressed_button == "maximize"
            and ALPHA_BUTTON_PRESSED
            or ALPHA_BUTTON_BG
    )
  end
  draw_icon(
      ass,
      is_maximized and ICON.restore or ICON.maximize,
      L.maximize_x1 + BUTTON_WIDTH / 2,
      BAR_HEIGHT / 2,
      10,
      TEXT,
      "20"
  )
  common.add_hitbox(hitboxes, "maximize", L.maximize_x1, 0, L.maximize_x1 + BUTTON_WIDTH, BAR_HEIGHT, function()
    local now = mp.get_time()
    if now - last_maximize_toggle_time < MAXIMIZE_COOLDOWN_SEC then return end
    last_maximize_toggle_time = now

    if fake_maximized then
      fake_maximized = false
      is_maximized = false
      common.set_property_cached("geometry", saved_geometry)
    else
      saved_geometry = mp.get_property("geometry") or ""
      local wa = common.get_workarea()
      if wa then
        fake_maximized = true
        is_maximized = true
        common.set_property_cached("geometry", wa)
      else
        mp.commandv("cycle", "window-maximized")
      end
    end
    render()
  end)

  if hover_close then
        common.draw_rrect(
        ass,
        L.close_x1,
        0,
        L.close_x1 + BUTTON_WIDTH,
        BAR_HEIGHT,
        CLOSE_BUTTON_RADIUS,
        CLOSEBG,
        ALPHA_CLOSE_BG
    )
  end
  draw_icon(ass, ICON.close, L.close_x1 + BUTTON_WIDTH / 2, BAR_HEIGHT / 2, 10, TEXT, "20")
  common.add_hitbox(hitboxes, "close", L.close_x1, 0, L.close_x1 + BUTTON_WIDTH, BAR_HEIGHT, function()
    mp.commandv("quit")
  end)

  osd.data = ass.text
  osd.res_x = screen_w
  osd.res_y = screen_h
  osd:update()
end

local function set_pressed_button(name)
  if name ~= "minimize" and name ~= "maximize" then return end
  pressed_button = name
  pressed_button_token = pressed_button_token + 1
  local token = pressed_button_token
  render()
  mp.add_timeout(0.12, function()
    if pressed_button_token == token then
      pressed_button = nil
      render()
    end
  end)
end

local function clear_pressed_button()
  pressed_button_token = pressed_button_token + 1
  if pressed_button then
    pressed_button = nil
    render()
  end
end

--------------------------------------------------------------------------------
-- VISIBILITY
--------------------------------------------------------------------------------

local vis = common.new_visibility({
  hide_delay = HIDE_DELAY_SEC,
  in_zone = function()
    if mp.get_property_bool("fullscreen", false) then return false end
    return mouse_y >= 0 and mouse_y <= (bar_visible and BAR_HEIGHT or HOVER_STRIP_HEIGHT)
  end,
  on_show = function() bar_visible = true; render() end,
  on_hide = function() bar_visible = false; render() end,
})

if SHOW_MODE == "always" then
  vis.toggle_pinned()
end

--------------------------------------------------------------------------------
-- INPUT
--------------------------------------------------------------------------------

local function handle_click(px, py)
  for _, b in ipairs(hitboxes) do
    if point_in(px, py, b) then
      b.cb()
      render()
      return true
    end
  end
  return false
end

local pending_hitbox = nil
local click_in_progress = false
local pending_playlist_click = false

local function point_in_published_bounds(prefix, px, py)
  if not mp.get_property_native("user-data/" .. prefix .. "/visible", false) then
    return false
  end
  local x1 = mp.get_property_native("user-data/" .. prefix .. "/x1", -1)
  local y1 = mp.get_property_native("user-data/" .. prefix .. "/y1", -1)
  local x2 = mp.get_property_native("user-data/" .. prefix .. "/x2", -1)
  local y2 = mp.get_property_native("user-data/" .. prefix .. "/y2", -1)
  return px >= x1 and px <= x2 and py >= y1 and py <= y2
end

mp.register_script_message("titlebar-mbtn-left-down", function()
  if click_in_progress then return end
  click_in_progress = true
  pending_hitbox = nil
  pending_playlist_click = point_in_published_bounds("cadre_playlist", mouse_x, mouse_y)
  if pending_playlist_click then
    mp.commandv("script-message-to", "cadre_playlist", "playlist-mbtn-left-down")
    return
  end
  for _, b in ipairs(hitboxes) do
    if point_in(mouse_x, mouse_y, b) then
      pending_hitbox = b
      set_pressed_button(b.name)
      break
    end
  end
end)

mp.register_script_message("titlebar-mbtn-left-up", function()
  if pending_playlist_click then
    mp.commandv("script-message-to", "cadre_playlist", "playlist-mbtn-left-up")
  elseif pending_hitbox then
    pending_hitbox.cb()
    render()
  end
  pending_hitbox = nil
  pending_playlist_click = false
  clear_pressed_button()
  mp.add_timeout(0.25, function() click_in_progress = false end)
end)

mp.observe_property("mouse-pos", "native", function(_, pos)
  if pos then
    mouse_x = pos.x or -1
    mouse_y = pos.y or -1
  end
  vis.poll()
  update_window_dragging()
  if bar_visible then render() end
end)

mp.add_key_binding("t", "cadre_titlebar_toggle", vis.toggle_pinned)
mp.register_script_message("toggle-titlebar", vis.toggle_pinned)

mp.observe_property("fullscreen", "bool", function(_, v)
  if v then
    bar_visible = false
  elseif vis.is_pinned() then
    bar_visible = true
  else
    bar_visible = false
    vis.poll()
  end
  render()
end)

mp.observe_property("osd-dimensions", "native", function(name, val)
  if not val then return end
  screen_w = val.w
  screen_h = val.h
  render()
end)

mp.observe_property("media-title", "string", function() if bar_visible then render() end end)

local function on_mbtn_left(event)
  vis.poll()
  if event.event == "down" or event.event == "press" then
    if point_in_published_bounds("cadre_playlist", mouse_x, mouse_y) then
      pending_playlist_click = true
      mp.commandv("script-message-to", "cadre_playlist", "playlist-mbtn-left-down")
      return
    end
    if not bar_visible then return end
    for _, b in ipairs(hitboxes) do
      if point_in(mouse_x, mouse_y, b) then
        b.cb()
        render()
        return
      end
    end
  elseif event.event == "up" or event.event == "release" then
    if pending_playlist_click then
      mp.commandv("script-message-to", "cadre_playlist", "playlist-mbtn-left-up")
      pending_playlist_click = false
    end
  end
end

local function update_mbtn_binding()
  if common.is_script_loaded("cadre_osc") then
    mp.remove_key_binding("cadre_titlebar_mbtn_left")
  else
    mp.add_forced_key_binding("MBTN_LEFT", "cadre_titlebar_mbtn_left", on_mbtn_left, { complex = true })
  end
end
mp.observe_property("user-data/cadre_scripts/cadre_osc/loaded", "bool", update_mbtn_binding)

mp.register_event("shutdown", function()
  mp.set_property_native("user-data/cadre_titlebar/loaded", false)
end)

mp.observe_property("window-minimized", "bool", function(_, minimized)
  if minimized then
    bar_visible = false
    render()
  end
end)

render()
