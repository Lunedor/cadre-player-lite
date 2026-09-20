--[[
cadre_playlist.lua
]]

local mp = require 'mp'
local assdraw = require 'mp.assdraw'
local utils = require 'mp.utils'
local msg = require 'mp.msg'

local common_path = mp.find_config_file("scripts/cadre_common.lua")
local common = dofile(common_path)

--------------------------------------------------------------------------------
-- CONFIG
--------------------------------------------------------------------------------

local theme = dofile(mp.find_config_file("scripts/cadre_theme.lua"))

local ICON_FONT = "Material Icons Outlined"
local ICON_COLOR = common.bgr(theme.color_icon_pl or theme.color_icon or theme.color_icon_osc or "F2E8F0")
local TEXT = common.bgr(theme.color_text_pl or theme.color_text or "F1F5F9")
local DIM = common.bgr(theme.color_dim_pl or theme.color_dim or "64748B")
local BARBG = common.bgr(theme.color_bar_bg_pl or theme.color_bar_bg or "0F1115")
local ALPHA_BAR_BG = theme.alpha_bar_bg_pl or theme.alpha_bar_bg or "18"
local DANGER = common.bgr(theme.color_danger_pl or theme.color_danger or "BA110C")
local SCROLL_FG = common.bgr(theme.color_scroll_fg_pl or theme.color_scroll_fg or "CBD5E1")
local SCROLL_BG = common.bgr(theme.color_scroll_bg_pl or theme.color_scroll_bg or "1E222B")
local SELECTED_COLOR = common.bgr(theme.color_selected_pl or "5A7A9A")
local NOW_PLAYING_COLOR = common.bgr(theme.color_current_pl or "5A7A9A")
local ICON_DIM = theme.color_icon_dim or "60"
local ROW_HEIGHT = theme.row_height or 40
local RADIUS = theme.bar_radius or 20
local TOOLBAR_HEIGHT = theme.toolbar_height or 40
local HEADER_HEIGHT = theme.header_height or 40
local SEARCH_HEIGHT = theme.search_height or 40
local PANEL_WIDTH = theme.panel_width or 400
local SIDE_INSET = theme.side_inset or 14
local TOP_INSET = theme.top_inset or 54
local BOTTOM_INSET = theme.bottom_inset or 110
local SCROLLBAR_WIDTH = theme.scrollbar_width or 6
local HOVER_STRIP_WIDTH = theme.hover_strip_width or 18
local HIDE_DELAY_SEC = theme.hide_delay_sec or 0.4
local OSC_BOTTOM_EXCLUSION = theme.osc_bottom_exclusion or 130

math.randomseed(os.time())


local ICON = {
  search = "\u{E8B6}",
  shuffle = "\u{E043}",
  save = "\u{E161}",
  load = "\u{E166}",
  remove = "\u{E15B}",
  delete = "\u{E872}",
  repeat_all = "\u{E040}",
  repeat_one = "\u{E041}",
  play = "\u{E037}",
  pause = "\u{E034}",
  add = "\u{E145}",
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

local pinned = false
local hover_open = false
local panel_visible = false
local hide_timer = nil

local items = {}
local filtered_items = {}
local current_index = -1
local selected_index = -1
local scroll_offset = 0

local search_active = false
local search_query = ""

local shuffle_on = false
local shuffle_order = {}
local repeat_mode = "off"

local drag = { active = false, from_index = -1, current_target = -1 }
local scrollbar_drag = false

local hitboxes = {}
local last_click_time = 0
local last_click_index = -1
local DOUBLE_CLICK_SEC = 0.35

local load_append_mode = false
local duration_cache = {}
local add_menu_open = false
local add_menu_geo = nil

--------------------------------------------------------------------------------
-- LAYOUT
--------------------------------------------------------------------------------

local function get_layout()
  local x2 = screen_w - SIDE_INSET
  local x1 = x2 - PANEL_WIDTH
  local y1 = TOP_INSET
  local y2 = screen_h - BOTTOM_INSET

  local header_y2 = y1 + HEADER_HEIGHT
  local search_y2 = header_y2 + (search_active and SEARCH_HEIGHT or 0)
  local toolbar_y1 = y2 - TOOLBAR_HEIGHT
  local list_y1 = search_y2 + 4
  local list_y2 = toolbar_y1 - 4

  return {
    x1 = x1, x2 = x2, y1 = y1, y2 = y2,
    header_y2 = header_y2,
    search_y1 = header_y2, search_y2 = search_y2,
    list_y1 = list_y1, list_y2 = list_y2,
    toolbar_y1 = toolbar_y1,
    list_h = list_y2 - list_y1,
    visible_rows = math.floor((list_y2 - list_y1) / ROW_HEIGHT),
  }
end

local function scroll_to_current()
  if current_index < 0 then return end
  local L = get_layout()
  local filtered_pos = nil
  for i, entry_wrap in ipairs(filtered_items) do
    if entry_wrap.real_index == current_index then
      filtered_pos = i
      break
    end
  end
  if not filtered_pos then return end

  local max_scroll = math.max(0, #filtered_items - L.visible_rows)
  if filtered_pos - 1 < scroll_offset then
    scroll_offset = filtered_pos - 1
  elseif filtered_pos > scroll_offset + L.visible_rows then
    scroll_offset = filtered_pos - L.visible_rows
  end
  scroll_offset = math.max(0, math.min(scroll_offset, max_scroll))
end

local function compute_add_menu_geo(L)
  local card_w, card_h = 190, 3 * 36 + 12
  local card_x2 = L.x2 - 10
  local card_x1 = card_x2 - card_w
  local card_y2 = L.toolbar_y1 - 8
  local card_y1 = card_y2 - card_h
  return { cx = card_x1 + card_w/2, card_x1 = card_x1, card_x2 = card_x2, card_y1 = card_y1, card_y2 = card_y2, row_h = 36 }
end

--------------------------------------------------------------------------------
-- HELPERS
--------------------------------------------------------------------------------

local function is_open()
  return pinned or hover_open
end

local function basename(path)
  if not path then return "" end
  local name = path:match("([^/\\]+)$") or path
  return name
end

-- Safely truncates strings containing multibyte UTF-8 characters
local function truncate_utf8(str, max_chars)
  if not str then return "" end
  local count = 0
  local res = {}
  for c in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
    count = count + 1
    if count > max_chars then
      table.insert(res, "...")
      break
    end
    table.insert(res, c)
  end
  return table.concat(res)
end

local function fmt_time(t)
  if not t or t ~= t or t < 0 then return "" end
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
local function draw_text(ass, str, x, y, size, color, alpha, align, bold) common.draw_text(ass, str, x, y, size, color, alpha, align, bold) end
local function draw_rrect(ass, x1, y1, x2, y2, r, color, alpha) common.draw_rrect(ass, x1, y1, x2, y2, r, color, alpha) end

local function render_add_menu(ass, geo)
  draw_rrect(ass, geo.card_x1, geo.card_y1, geo.card_x2, geo.card_y2, 10, BARBG, ALPHA_BAR_BG)
  local entries = {
    { label = "Add file",   icon = ICON.add_file,   cb = common.do_add_file },
    { label = "Add folder", icon = ICON.add_folder, cb = common.do_add_folder },
    { label = "Add URL",    icon = ICON.add_url,    cb = common.do_add_url },
  }
  for i, e in ipairs(entries) do
    local row_y1 = geo.card_y1 + 6 + (i - 1) * geo.row_h
    local row_y2 = row_y1 + geo.row_h
    local mid_y = (row_y1 + row_y2) / 2
    draw_icon(ass, e.icon, geo.card_x1 + 24, mid_y, 16, ICON_COLOR, ICON_DIM)
    draw_text(ass, e.label, geo.card_x1 + 42, mid_y, 16, TEXT, "00", 4, false)
    add_hitbox("pl_add_menu_" .. i, geo.card_x1, row_y1, geo.card_x2, row_y2, function()
      add_menu_open = false
      e.cb()
    end)
  end
end
--------------------------------------------------------------------------------
-- PLAYLIST DATA
--------------------------------------------------------------------------------

local function rebuild_filtered()
  filtered_items = {}
  local q = search_query:lower()
  for i, it in ipairs(items) do
    local title = (it.title or basename(it.filename or "")):lower()
    if q == "" or title:find(q, 1, true) then
      filtered_items[#filtered_items + 1] = { real_index = i - 1, item = it }
    end
  end
end

local function reconcile_shuffle_order()
  if not shuffle_on then
    shuffle_order = {}
    return
  end
  local n = #items
  local valid = {}
  local seen = {}
  for _, idx in ipairs(shuffle_order) do
    if idx < n then
      valid[#valid + 1] = idx
      seen[idx] = true
    end
  end
  local missing = {}
  for i = 0, n - 1 do
    if not seen[i] then missing[#missing + 1] = i end
  end
  for i = #missing, 2, -1 do
    local j = math.random(i)
    missing[i], missing[j] = missing[j], missing[i]
  end
  for _, idx in ipairs(missing) do
    valid[#valid + 1] = idx
  end
  shuffle_order = valid
end

local function refresh_playlist()
  items = mp.get_property_native("playlist") or {}
  current_index = mp.get_property_number("playlist-pos", -1)
  rebuild_filtered()
  reconcile_shuffle_order()
end

--------------------------------------------------------------------------------
-- SHUFFLE (PLAY ORDER, not list order)
--------------------------------------------------------------------------------

local function rebuild_shuffle_order()
  local n = #items
  local order = {}
  for i = 0, n - 1 do order[#order + 1] = i end
  for i = #order, 2, -1 do
    local j = math.random(i)
    order[i], order[j] = order[j], order[i]
  end
  if current_index >= 0 then
    for i, v in ipairs(order) do
      if v == current_index then
        table.remove(order, i)
        table.insert(order, 1, current_index)
        break
      end
    end
  end
  shuffle_order = order
end

local function toggle_shuffle()
  shuffle_on = not shuffle_on
  mp.set_property_bool("shuffle", false)
  if shuffle_on then
    rebuild_shuffle_order()
  else
    shuffle_order = {}
  end
  render()
end

local function advance_shuffled(direction)
  if #shuffle_order == 0 then rebuild_shuffle_order() end
  if #shuffle_order == 0 then return end

  local pos = nil
  for i, v in ipairs(shuffle_order) do
    if v == current_index then pos = i break end
  end
  if not pos then
    rebuild_shuffle_order()
    pos = 1
  end

  local next_pos = pos + direction
  if next_pos > #shuffle_order then
    if repeat_mode == "all" then
      rebuild_shuffle_order()
      next_pos = 1
    else
      return
    end
  elseif next_pos < 1 then
    if repeat_mode == "all" then
      next_pos = #shuffle_order
    else
      return
    end
  end
  mp.commandv("playlist-play-index", shuffle_order[next_pos])
end

local function cycle_repeat()
  if repeat_mode == "off" then
    repeat_mode = "all"
    common.set_property_cached("loop-playlist", "inf")
    common.set_property_cached("loop-file", "no")
  elseif repeat_mode == "all" then
    repeat_mode = "one"
    common.set_property_cached("loop-playlist", "no")
    common.set_property_cached("loop-file", "inf")
  else
    repeat_mode = "off"
    common.set_property_cached("loop-playlist", "no")
    common.set_property_cached("loop-file", "no")
  end
  render()
end

mp.register_event("end-file", function(event)
  if event.reason == "eof" and shuffle_on then
    if repeat_mode == "one" then
      mp.commandv("playlist-play-index", current_index)
    else
      advance_shuffled(1)
    end
  end
end)

--------------------------------------------------------------------------------
-- REMOVE / DELETE
--------------------------------------------------------------------------------

local function remove_selected()
  if selected_index >= 0 and selected_index < #items then
    mp.commandv("playlist-remove", selected_index)
    selected_index = -1
  end
end

local function send_to_recycle_bin(path)
  local res = utils.subprocess({ args = { "powershell", "-NoProfile", "-Command",
    string.format("Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile('%s', 'OnlyErrorDialogs', 'SendToRecycleBin')", path:gsub("'", "''"))
  }, cancellable = false })
  if res.status ~= 0 then
    mp.osd_message("Failed to move file to Recycle Bin", 3)
    msg.error("recycle bin move failed: " .. (res.error or "unknown error"))
    return false
  end
  return true
end

local function delete_selected_to_recycle_bin()
  if selected_index < 0 or selected_index >= #items then return end
  local entry = items[selected_index + 1]
  local path = entry.filename
  if not path or path:match("^https?://") then
    mp.osd_message("Cannot delete a URL/stream entry", 2)
    return
  end
  mp.commandv("playlist-remove", selected_index)
  local ok = send_to_recycle_bin(path)
  if ok then
    mp.osd_message("Moved to Recycle Bin: " .. basename(path), 2)
  end
  selected_index = -1
end

--------------------------------------------------------------------------------
-- SAVE / LOAD PLAYLIST
--------------------------------------------------------------------------------

local function write_m3u8(path, entries)
  local f = io.open(path, "w")
  if not f then
    mp.osd_message("Could not open file for writing: " .. path, 3)
    return false
  end
  f:write("#EXTM3U\n")
  for _, it in ipairs(entries) do
    local title = it.title or basename(it.filename or "")
    f:write("#EXTINF:-1," .. title .. "\n")
    f:write((it.filename or "") .. "\n")
  end
  f:close()
  return true
end

local function do_save_playlist()
  local path = common.save_file_dialog({
    title = "Save Playlist",
    filter = "M3U8 playlist|*.m3u8|M3U playlist|*.m3u|All files|*.*",
    default_name = "playlist.m3u8",
  })
  if not path then return end
  if write_m3u8(path, items) then
    mp.osd_message("Playlist saved: " .. basename(path), 2)
  end
end

local function do_load_playlist()
  local paths = common.pick_files_dialog({
    title = "Load Playlist",
    filter = "Playlist files|*.m3u8;*.m3u;*.pls|All files|*.*",
    multiselect = false,
  })

  if not paths or type(paths) ~= "table" or #paths == 0 then return end

  local path = paths[1]
  if type(path) ~= "string" or path == "" then
      mp.msg.error("cadre_playlist: invalid path value: " .. tostring(path))
      return
  end

  mp.commandv("loadlist", path, load_append_mode and "append" or "replace")
  mp.osd_message("Playlist loaded: " .. basename(path), 2)
end


--------------------------------------------------------------------------------
-- SHARED STATE PUBLISHING
--------------------------------------------------------------------------------

local function publish_bounds(L)
  mp.set_property_native("user-data/cadre_playlist/visible", panel_visible)
  if panel_visible and L then
    mp.set_property_native("user-data/cadre_playlist/x1", L.x1)
    mp.set_property_native("user-data/cadre_playlist/y1", L.y1)
    mp.set_property_native("user-data/cadre_playlist/x2", L.x2)
    mp.set_property_native("user-data/cadre_playlist/y2", L.y2)
  end
end

local function enable_search_bindings()
  local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -_."
  for i = 1, #chars do
    local c = chars:sub(i, i)
    mp.add_forced_key_binding(c, "cadre_search_char_" .. c, function()
      search_query = search_query .. c
      rebuild_filtered()
      render()
    end, { repeatable = true })
  end
  mp.add_forced_key_binding("BS", "cadre_search_backspace", function()
    if #search_query > 0 then
      search_query = search_query:sub(1, -2)
      rebuild_filtered()
      render()
    end
  end, { repeatable = true })
end

local function disable_search_bindings()
  local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -_."
  for i = 1, #chars do
    mp.remove_key_binding("cadre_search_char_" .. chars:sub(i, i))
  end
  mp.remove_key_binding("cadre_search_backspace")
end

--------------------------------------------------------------------------------
-- RENDER
--------------------------------------------------------------------------------

function render()
  hitboxes = common.new_hitboxes()
  local ass = assdraw.ass_new()

  if not panel_visible then
    osd.data = ""
    osd:update()
    publish_bounds(nil)
    add_menu_geo = nil
    return
  end

  local L = get_layout()
  publish_bounds(L)

  draw_rrect(ass, L.x1, L.y1, L.x2, L.y2, RADIUS, BARBG, ALPHA_BAR_BG)

  local count_str = #items == 1 and "1 item" or (#items .. " items")
  draw_text(ass, "Playlist", L.x1 + 16, L.y1 + 14, 16, TEXT, "00", 4, true)
  draw_text(ass, count_str, L.x1 + 16, L.y1 + 30, 14, TEXT, "20", 4, false)

  local search_icon_x = L.x2 - 24
  draw_icon(ass, ICON.search, search_icon_x, L.y1 + 20, 18, ICON_COLOR, search_active and "30" or "60")
  add_hitbox("toggle_search", search_icon_x - 14, L.y1 + 4, search_icon_x + 14, L.y1 + 34, function()
    search_active = not search_active
    if search_active then
      enable_search_bindings()
    else
      disable_search_bindings()
      search_query = ""
      rebuild_filtered()
    end
  end)

  if search_active then
    draw_rrect(ass, L.x1 + 12, L.search_y1 + 2, L.x2 - 12, L.search_y2 - 4, 12, BARBG, ALPHA_BAR_BG)
    local display_q = search_query == "" and "Search playlist..." or search_query
    draw_text(ass, display_q, L.x1 + 22, (L.search_y1 + L.search_y2) / 2, 14,
      search_query == "" and DIM or TEXT, "10", 4, false)
  end

  local max_scroll = math.max(0, #filtered_items - L.visible_rows)
  scroll_offset = math.max(0, math.min(scroll_offset, max_scroll))

  if #filtered_items == 0 then
    draw_text(ass, "Playlist is empty", (L.x1 + L.x2) / 2, (L.list_y1 + L.list_y2) / 2 - 8, 16, TEXT, "30", 5, false)
    draw_text(ass, "Use + below to add files", (L.x1 + L.x2) / 2, (L.list_y1 + L.list_y2) / 2 + 12, 14, TEXT, "50", 5, false)
  end

  for row = 0, L.visible_rows - 1 do
    local data_i = row + scroll_offset + 1
    local entry_wrap = filtered_items[data_i]
    if not entry_wrap then break end

    local real_idx = entry_wrap.real_index
    local entry = entry_wrap.item
    local row_y1 = L.list_y1 + row * ROW_HEIGHT
    local row_y2 = row_y1 + ROW_HEIGHT - 2

    local is_current = (real_idx == current_index)
    local is_selected = (real_idx == selected_index)
    local is_drop_target = drag.active and drag.current_target == real_idx

    if is_selected then
      draw_rrect(ass, L.x1 + 6, row_y1, L.x2 - 6 - SCROLLBAR_WIDTH, row_y2, 6, SELECTED_COLOR, "60")
      draw_rrect(ass, L.x1 + 6, row_y1, L.x1 + 9, row_y2, 1, SELECTED_COLOR, "20")
    end

    if is_current then
      draw_rrect(ass, L.x1 + 6, row_y1, L.x2 - 6 - SCROLLBAR_WIDTH, row_y2, 6, NOW_PLAYING_COLOR, "88")
    end

    if is_drop_target then
      ass:new_event()
      ass:append(string.format("{\\pos(0,0)\\an7\\1c&H%s&\\1a&H00&\\bord0\\shad0}", TEXT))
      ass:draw_start()
      ass:round_rect_cw(L.x1 + 6, row_y1 - 2, L.x2 - 6 - SCROLLBAR_WIDTH, row_y1, 1)
      ass:draw_stop()
    end

    local idx_str = string.format("%02d", real_idx + 1)
    draw_text(ass, idx_str, L.x1 + 16, (row_y1 + row_y2) / 2, 10,
      TEXT, "30", 4, is_current)

    local cached_duration = duration_cache[entry.filename]
    local dur_str = cached_duration and fmt_time(cached_duration) or ""

    -- Calculate how many characters we can fit before truncation
    local max_chars = 48
    if is_current then max_chars = max_chars - 3 end
    if dur_str ~= "" then max_chars = max_chars - 6 end

    local title = entry.title or basename(entry.filename or "")
    title = truncate_utf8(title, max_chars)

    local title_color = TEXT
    draw_text(ass, title, L.x1 + 42, (row_y1 + row_y2) / 2, 14, title_color, "00", 4, is_current)

    local rx_right = L.x2 - 16 - SCROLLBAR_WIDTH
    if is_current then
      local paused = mp.get_property_bool("pause", false)
      draw_icon(ass, paused and ICON.pause or ICON.play, rx_right, (row_y1 + row_y2) / 2, 14, TEXT, ICON_DIM)
      rx_right = rx_right - 24
    end

    if dur_str ~= "" then
      draw_text(ass, dur_str, rx_right, (row_y1 + row_y2) / 2, 11,
        TEXT, "00", 6, false)
    end

    add_hitbox("row_" .. real_idx, L.x1 + 6, row_y1, L.x2 - 6, row_y2, function()
      selected_index = real_idx
    end)
  end

  if #filtered_items > L.visible_rows then
    local track_x1 = L.x2 - SCROLLBAR_WIDTH - 4
    local track_x2 = L.x2 - 4
    draw_rrect(ass, track_x1, L.list_y1, track_x2, L.list_y2, SCROLLBAR_WIDTH / 2, TEXT, "F0")

    local ratio = L.visible_rows / #filtered_items
    local thumb_h = math.max(20, L.list_h * ratio)
    local thumb_y1 = L.list_y1 + (L.list_h - thumb_h) * (scroll_offset / max_scroll)
    draw_rrect(ass, track_x1, thumb_y1, track_x2, thumb_y1 + thumb_h, SCROLLBAR_WIDTH / 2, TEXT, "A0")

    add_hitbox("scrollbar", track_x1 - 4, L.list_y1, track_x2 + 4, L.list_y2, function() end)
  end

  local tx = L.x1 + 20
  local ty = L.toolbar_y1 + TOOLBAR_HEIGHT / 2
  local spacing = 34

  draw_icon(ass, ICON.shuffle, tx, ty, 20, ICON_COLOR, shuffle_on and "00" or "60")
  add_hitbox("shuffle", tx - 14, ty - 14, tx + 14, ty + 14, toggle_shuffle)
  tx = tx + spacing

  local rep_icon = repeat_mode == "one" and ICON.repeat_one or ICON.repeat_all
  local rep_color = ICON_COLOR
  draw_icon(ass, rep_icon, tx, ty, 20, rep_color, repeat_mode ~= "off" and "00" or "60")
  add_hitbox("repeat", tx - 14, ty - 14, tx + 14, ty + 14, cycle_repeat)

  local rx = L.x2 - 20 - SCROLLBAR_WIDTH
  draw_icon(ass, ICON.delete, rx, ty, 20, DANGER, "30")
  add_hitbox("delete", rx - 14, ty - 14, rx + 14, ty + 14, delete_selected_to_recycle_bin)
  rx = rx - spacing

  draw_icon(ass, ICON.remove, rx, ty, 20, ICON_COLOR, ICON_DIM)
  add_hitbox("remove", rx - 14, ty - 14, rx + 14, ty + 14, remove_selected)
  rx = rx - spacing

  draw_icon(ass, ICON.save, rx, ty, 20, ICON_COLOR, ICON_DIM)
  add_hitbox("save", rx - 14, ty - 14, rx + 14, ty + 14, do_save_playlist)
  rx = rx - spacing

  draw_icon(ass, ICON.load, rx, ty, 20, ICON_COLOR, ICON_DIM)
  add_hitbox("load", rx - 14, ty - 14, rx + 14, ty + 14, function()
    load_append_mode = false
    do_load_playlist()
  end)
  rx = rx - spacing

  draw_icon(ass, ICON.add, rx, ty, 20, ICON_COLOR, ICON_DIM)
  add_hitbox("pl_add", rx - 14, ty - 14, rx + 14, ty + 14, function()
    add_menu_open = not add_menu_open
  end)

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
-- INPUT
--------------------------------------------------------------------------------

local mouse_over_playlist = false

local function update_wheel_bindings(over)
  if over == mouse_over_playlist then return end
  mouse_over_playlist = over
  if over then
    mp.add_forced_key_binding("WHEEL_UP", "cadre_playlist_wheel_up", function()
      scroll_offset = math.max(0, scroll_offset - 3)
      render()
    end)
    mp.add_forced_key_binding("WHEEL_DOWN", "cadre_playlist_wheel_down", function()
      local L = get_layout()
      local max_scroll = math.max(0, #filtered_items - L.visible_rows)
      scroll_offset = math.min(max_scroll, scroll_offset + 3)
      render()
    end)
  else
    mp.remove_key_binding("cadre_playlist_wheel_up")
    mp.remove_key_binding("cadre_playlist_wheel_down")
  end
end

local function row_at_xy(L, px, py)
    if px < L.x1 or px > L.x2 then
        return nil
    end
    if py < L.list_y1 or py > L.list_y2 then
        return nil
    end
    local row = math.floor((py - L.list_y1) / ROW_HEIGHT)
    local data_i = row + scroll_offset + 1
    local entry_wrap = filtered_items[data_i]

    return entry_wrap and entry_wrap.real_index or nil
end

local function on_mouse_move_internal()
  local is_over = false
  local L = nil
  
  if panel_visible then
    L = get_layout()
    is_over = (mouse_x >= L.x1 and mouse_x <= L.x2 and mouse_y >= L.y1 and mouse_y <= L.y2)
  end
  
  update_wheel_bindings(is_over)

  if not panel_visible then return end

  if add_menu_geo and mouse_x >= add_menu_geo.card_x1 - 10 and mouse_x <= add_menu_geo.card_x2 + 10
    and mouse_y >= add_menu_geo.card_y1 - 10 and mouse_y <= add_menu_geo.card_y2 + 10 then
    return
  end

  if scrollbar_drag then
    local max_scroll = math.max(0, #filtered_items - L.visible_rows)
    local ratio = (mouse_y - L.list_y1) / L.list_h
    scroll_offset = math.floor(ratio * (#filtered_items))
    scroll_offset = math.max(0, math.min(scroll_offset, max_scroll))
    render()
    return
  end

  if drag.active then
    drag.current_target = row_at_xy(L, mouse_x, mouse_y) or drag.current_target
    render()
    return
  end

  render()
end

local function update_window_dragging()
    local osc_present = mp.get_property_native("user-data/cadre_osc/mbtn_bound", false)
    if osc_present then return end

    local should_drag = true
    if panel_visible then
        local L = get_layout()
        local over_panel = mouse_x >= L.x1 and mouse_x <= L.x2 and mouse_y >= L.y1 and mouse_y <= L.y2
        if over_panel then should_drag = false end
    end
    mp.set_property_bool("window-dragging", should_drag)
end

mp.observe_property("mouse-pos", "native", function(_, pos)
  if pos then
    mouse_x = pos.x or -1
    mouse_y = pos.y or -1
  end

  if not pinned then
    local osd_dims = mp.get_property_native("osd-dimensions")
    local sw = (osd_dims and osd_dims.w) or screen_w
    local sh = (osd_dims and osd_dims.h) or screen_h
    local in_osc_band = mouse_y >= (sh - OSC_BOTTOM_EXCLUSION)
    local near_right_edge = (not in_osc_band) and (mouse_x >= sw - HOVER_STRIP_WIDTH)

    local over_panel = false
    
    if panel_visible then
      local L = get_layout()
      over_panel = mouse_x >= L.x1 and mouse_x <= L.x2 and mouse_y >= L.y1 and mouse_y <= L.y2
    end

    if near_right_edge or over_panel then
      if hide_timer then hide_timer:kill() hide_timer = nil end
      if not hover_open then
        hover_open = true
        panel_visible = true
        refresh_playlist()
        scroll_to_current()
        render()
      end
    else
      if hover_open then
        if not hide_timer then
          hide_timer = mp.add_timeout(HIDE_DELAY_SEC, function()
            hover_open = false
            panel_visible = is_open()
            if not panel_visible then update_wheel_bindings(false) end
            render()
            hide_timer = nil
          end)
        end
      end
    end
  end

  on_mouse_move_internal()
  update_window_dragging()
end)

local function on_mbtn_left(event)
  if not panel_visible then return end
  local L = get_layout()
  
  if event.event == "down" or event.event == "press" then
    if add_menu_open and add_menu_geo then
      local in_menu = mouse_x >= add_menu_geo.card_x1 and mouse_x <= add_menu_geo.card_x2
          and mouse_y >= add_menu_geo.card_y1 and mouse_y <= add_menu_geo.card_y2

      if in_menu then
        for _, b in ipairs(hitboxes) do
          if b.name:match("^pl_add_menu_") and point_in(mouse_x, mouse_y, b) then
            b.cb()
            render()
            return
          end
        end
        return
      end
    end

    local track_x1 = L.x2 - SCROLLBAR_WIDTH - 8
    if mouse_x >= track_x1 and mouse_x <= L.x2 and mouse_y >= L.list_y1 and mouse_y <= L.list_y2 then
      scrollbar_drag = true
      return
    end

    local row_idx = row_at_xy(L, mouse_x, mouse_y)
    if row_idx ~= nil then
      local now = mp.get_time()
      if last_click_index == row_idx and (now - last_click_time) < DOUBLE_CLICK_SEC then
        mp.commandv("playlist-play-index", row_idx)
        last_click_index = -1
      else
        selected_index = row_idx
        drag.active = true
        drag.from_index = row_idx
        drag.current_target = row_idx
        last_click_index = row_idx
        last_click_time = now
      end
      render()
      return
    end

    for _, b in ipairs(hitboxes) do
      if point_in(mouse_x, mouse_y, b) then
        b.cb()
        render()
        return
      end
    end

    for _, b in ipairs(hitboxes) do
      if point_in(mouse_x, mouse_y, b) then
        b.cb()
        render()
        return
      end
    end

  elseif event.event == "up" or event.event == "release" then
    scrollbar_drag = false
    if drag.active then
      if drag.current_target ~= drag.from_index and drag.current_target >= 0 then
        mp.commandv("playlist-move", drag.from_index, drag.current_target)
        selected_index = drag.current_target
      end
      drag.active = false
      drag.from_index = -1
      drag.current_target = -1
      render()
    end
  end
end

local function relay_down() on_mbtn_left({ event = "down" }) end
local function relay_up() on_mbtn_left({ event = "up" }) end

mp.register_script_message("playlist-mbtn-left-down", relay_down)
mp.register_script_message("playlist-mbtn-left-up", relay_up)

local function update_mbtn_binding(name, osc_claimed)
    if osc_claimed then
        -- OSC is active, release the bindings so the OSD/Titlebar can be clicked
        mp.remove_key_binding("cadre_playlist_mbtn_left")
        mp.remove_key_binding("cadre_playlist_mbtn_left_dbl")
    else
        -- OSC is inactive, playlist takes control of the clicks
        mp.add_forced_key_binding("MBTN_LEFT", "cadre_playlist_mbtn_left", on_mbtn_left, { complex = true })
        
        mp.add_key_binding("MBTN_LEFT_DBL", "cadre_playlist_mbtn_left_dbl", function()
            local L = get_layout()
            local in_panel = panel_visible and mouse_x >= L.x1 and mouse_x <= L.x2
                and mouse_y >= L.y1 and mouse_y <= L.y2
            if in_panel then return end
            mp.commandv("cycle", "fullscreen")
        end)
    end
end

-- Dynamically watch the property. This runs immediately on load, and every time the value changes.
mp.observe_property("user-data/cadre_osc/mbtn_bound", "bool", update_mbtn_binding)

-- Leave your DEL bindings exactly as they are
mp.add_key_binding("DEL", "cadre_playlist_delete", remove_selected)
mp.add_key_binding("Shift+DEL", "cadre_playlist_shift_delete", delete_selected_to_recycle_bin)
mp.add_key_binding("DEL", "cadre_playlist_delete", remove_selected)
mp.add_key_binding("Shift+DEL", "cadre_playlist_shift_delete", delete_selected_to_recycle_bin)

--------------------------------------------------------------------------------
-- VISIBILITY / BRIDGE
--------------------------------------------------------------------------------

local function set_pinned(v)
  pinned = v
  hover_open = false
  panel_visible = is_open()
  if not panel_visible then update_wheel_bindings(false) end
  if panel_visible then
    refresh_playlist()
    scroll_to_current()
  end
  render()
end

local function toggle_visible()
  set_pinned(not pinned)
end

mp.register_script_message("toggle-playlist", toggle_visible)
mp.register_script_message("playlist-prev", function()
  if shuffle_on then advance_shuffled(-1) else mp.commandv("playlist-prev", "weak") end
end)
mp.register_script_message("playlist-next", function()
  if shuffle_on then advance_shuffled(1) else mp.commandv("playlist-next", "weak") end
end)

mp.observe_property("playlist", "native", function() refresh_playlist() scroll_to_current() render() end)
mp.observe_property("playlist-pos", "number", function(_, v)
  current_index = v or -1
  if panel_visible then render() end
end)
mp.observe_property("pause", "bool", function() if panel_visible then render() end end)

mp.observe_property("duration", "number", function(_, v)
  if v and v > 0 then
    local path = mp.get_property("path")
    if path then
      duration_cache[path] = v
      if panel_visible then render() end
    end
  end
end)

mp.observe_property("osd-dimensions", "native", function(name, val)
  if not val then return end
  screen_w = val.w
  screen_h = val.h
  -- Force your script to rebuild hitboxes and redraw now that true dimensions exist
  render() 
end)

render()