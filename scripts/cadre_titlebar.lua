--[[
cadre_titlebar.lua
]]

local mp = require 'mp'
local assdraw = require 'mp.assdraw'
local msg = require 'mp.msg'

local common_path = mp.find_config_file("scripts/cadre_common.lua")
local common = dofile(common_path)

--------------------------------------------------------------------------------
-- CONFIG
--------------------------------------------------------------------------------
local theme = dofile(mp.find_config_file("scripts/cadre_theme.lua"))

local ICON_FONT = "Segoe MDL2 Assets"
local TEXT = common.bgr(theme.color_text_tb or theme.color_text or "F1F5F9")
local BARBG = common.bgr(theme.color_bar_bg_tb or theme.color_bar_bg or "0F1115")
local DANGER = common.bgr(theme.color_danger or "BA110C")
local HOVERBG = common.bgr(theme.color_hover_bg_tb or theme.color_hover_bg or "181B22")
local ALPHA_BAR_BG = theme.alpha_bar_bg_tb or theme.alpha_bar_bg or "18"
local BAR_HEIGHT = theme.bar_height_tb or 34
local BUTTON_WIDTH = theme.button_width_tb or 40
local HOVER_STRIP_HEIGHT = theme.hover_strip_height_tb or 12
local HIDE_DELAY_SEC = theme.hide_delay_sec_tb or 0.4
local MAXIMIZE_COOLDOWN_SEC = theme.maximize_cooldown_sec_tb or 0.35
local TITLE_FONT_SIZE = theme.title_font_size_tb or 16

local ICON = {
  minimize = "\u{E921}",
  maximize = "\u{E922}",
  restore = "\u{E923}",
  close = "\u{E8BB}",
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

local function draw_icon(ass, glyph, cx, cy, size, color, alpha)
  common.draw_icon(ass, ICON_FONT, glyph, cx, cy, size, color, alpha)
end

local function get_layout()
  return {
    x1 = 0, y1 = 0, x2 = screen_w, y2 = BAR_HEIGHT,
    close_x1 = screen_w - BUTTON_WIDTH,
    maximize_x1 = screen_w - BUTTON_WIDTH * 2,
    minimize_x1 = screen_w - BUTTON_WIDTH * 3,
  }
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
  local L = get_layout()
  local over_button = (mouse_x >= L.minimize_x1 and mouse_x < L.close_x1 + BUTTON_WIDTH and mouse_y < BAR_HEIGHT)
  mp.set_property_bool("window-dragging", not over_button)
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
  common.draw_text(ass, title, 16, BAR_HEIGHT / 2, TITLE_FONT_SIZE, TEXT, "00", 4, false)

  local hover_min = mouse_x >= L.minimize_x1 and mouse_x < L.minimize_x1 + BUTTON_WIDTH and mouse_y < BAR_HEIGHT
  local hover_max = mouse_x >= L.maximize_x1 and mouse_x < L.maximize_x1 + BUTTON_WIDTH and mouse_y < BAR_HEIGHT
  local hover_close = mouse_x >= L.close_x1 and mouse_x < L.close_x1 + BUTTON_WIDTH and mouse_y < BAR_HEIGHT

  if hover_min then
    common.draw_rrect(ass, L.minimize_x1, 0, L.minimize_x1 + BUTTON_WIDTH, BAR_HEIGHT, 4, HOVERBG, "20")
  end
  draw_icon(ass, ICON.minimize, L.minimize_x1 + BUTTON_WIDTH / 2, BAR_HEIGHT / 2, 10, TEXT, "20")
  common.add_hitbox(hitboxes, "minimize", L.minimize_x1, 0, L.minimize_x1 + BUTTON_WIDTH, BAR_HEIGHT, function()
    mp.commandv("cycle", "window-minimized")
  end)

  if hover_max then
    common.draw_rrect(ass, L.maximize_x1, 0, L.maximize_x1 + BUTTON_WIDTH, BAR_HEIGHT, 0, HOVERBG, "20")
  end
  draw_icon(ass, is_maximized and ICON.restore or ICON.maximize, L.maximize_x1 + BUTTON_WIDTH / 2, BAR_HEIGHT / 2, 10, TEXT, "20")
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
    common.draw_rrect(ass, L.close_x1, 0, L.close_x1 + BUTTON_WIDTH, BAR_HEIGHT, 4, DANGER, "70")
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

mp.register_script_message("titlebar-mbtn-left-down", function()
    if click_in_progress then return end
    click_in_progress = true
    pending_hitbox = nil
    for _, b in ipairs(hitboxes) do
        if point_in(mouse_x, mouse_y, b) then
            pending_hitbox = b
            break
        end
    end
end)

mp.register_script_message("titlebar-mbtn-left-up", function()
    if pending_hitbox then
        pending_hitbox.cb()
        render()
    end
    pending_hitbox = nil
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
    render()
  end
end)

mp.observe_property("osd-dimensions", "native", function(name, val)
  if not val then return end
  screen_w = val.w
  screen_h = val.h
  -- Force your script to rebuild hitboxes and redraw now that true dimensions exist
  render() 
end)

mp.observe_property("media-title", "string", function() if bar_visible then render() end end)

local function on_mbtn_left(event)
  if not bar_visible then return end
  if event.event == "down" or event.event == "press" then
    for _, b in ipairs(hitboxes) do
      if point_in(mouse_x, mouse_y, b) then
        b.cb()
        render()
        return
      end
    end
  end
end

local osc_claimed = mp.get_property_native("user-data/cadre_osc/mbtn_bound", false)
if not osc_claimed then
    mp.add_forced_key_binding("MBTN_LEFT", "cadre_titlebar_mbtn_left", on_mbtn_left, { complex = true })
end

render()