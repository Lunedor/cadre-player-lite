--[[
cadre_common.lua
]]

local mp = require 'mp'
local utils = require 'mp.utils'
local msg = require 'mp.msg'
local theme = dofile(mp.find_config_file("scripts/cadre_theme.lua"))
local UI_FONT = theme.font_ui or theme.font_text or "Inter"

local M = {}

local property_cache = {}

function M.set_property_cached(name, value)
  if property_cache[name] == value then return end
  
  property_cache[name] = value
  
  if type(value) == "boolean" then
    mp.set_property_bool(name, value)
  elseif type(value) == "number" then
    mp.set_property_number(name, value)
  else
    mp.set_property(name, value)
  end
end

--------------------------------------------------------------------------------
-- COLOR
--------------------------------------------------------------------------------

function M.bgr(hex)
  if type(hex) ~= "string" or #hex < 6 then
    mp.msg.warn("cadre_common: invalid color value '" .. tostring(hex) .. "', using fallback gray")
    hex = "808080"
  end
  return hex:sub(5, 6) .. hex:sub(3, 4) .. hex:sub(1, 2)
end

--------------------------------------------------------------------------------
-- HIT TESTING
--------------------------------------------------------------------------------

function M.new_hitboxes()
  return {}
end

function M.add_hitbox(hitboxes, name, x1, y1, x2, y2, cb)
  hitboxes[#hitboxes + 1] = { name = name, x1 = x1, y1 = y1, x2 = x2, y2 = y2, cb = cb }
end

function M.point_in(px, py, b)
  return px >= b.x1 and px <= b.x2 and py >= b.y1 and py <= b.y2
end

function M.dispatch_click(hitboxes, px, py, ...)
  for _, b in ipairs(hitboxes) do
    if M.point_in(px, py, b) then
      b.cb(...)
      return true, b.name
    end
  end
  return false, nil
end

--------------------------------------------------------------------------------
-- ASS DRAWING
--------------------------------------------------------------------------------

function M.draw_icon(ass, icon_font, glyph, cx, cy, size, color, alpha)
  ass:new_event()
  ass:append(string.format(
    "{\\pos(%d,%d)\\an5\\fn%s\\fs%d\\1c&H%s&\\1a&H%s&\\bord0\\shad0}%s",
    cx, cy, icon_font, size, color, alpha or "00", glyph
  ))
end

function M.draw_text(ass, str, x, y, size, color, alpha, align, bold, font)
    ass:new_event()
    local b = bold and "\\b1" or "\\b0"
    local f = font or UI_FONT
    ass:append(string.format(
        "{\\pos(%d,%d)\\an%d\\fn%s\\fs%d\\1c&H%s&\\1a&H%s&\\bord0\\shad0%s}%s",
        x, y, align or 4, f, size, color, alpha or "00", b, str
    ))
end

function M.draw_rrect(ass, x1, y1, x2, y2, r, color, alpha)
  ass:new_event()
  ass:append(string.format("{\\pos(0,0)\\an7\\1c&H%s&\\1a&H%s&\\bord0\\shad0}", color, alpha or "00"))
  ass:draw_start()
  ass:round_rect_cw(x1, y1, x2, y2, r)
  ass:draw_stop()
end

--------------------------------------------------------------------------------
-- AUTO-HIDE / HOVER-REVEAL STATE MACHINE
--------------------------------------------------------------------------------

function M.new_visibility(opts)
  opts = opts or {}
  local hide_delay = opts.hide_delay or 0.4
  local in_zone = opts.in_zone or function() return false end
  local on_show = opts.on_show or function() end
  local on_hide = opts.on_hide or function() end

  local state = {
    pinned = false,
    hover_open = false,
    hide_timer = nil,
  }

  local function is_visible()
    return state.pinned or state.hover_open
  end

  local function apply(prev_visible)
    local now_visible = is_visible()
    if now_visible and not prev_visible then on_show() end
    if not now_visible and prev_visible then on_hide() end
    return now_visible
  end

  local function set_pinned(v)
    local prev = is_visible()
    state.pinned = v
    state.hover_open = false
    if state.hide_timer then state.hide_timer:kill() state.hide_timer = nil end
    apply(prev)
  end

  local function poll()
    if state.pinned then return end
    local prev = is_visible()
    if in_zone() then
      if state.hide_timer then state.hide_timer:kill() state.hide_timer = nil end
      if not state.hover_open then
        state.hover_open = true
        apply(prev)
      end
    else
      if state.hover_open and not state.hide_timer then
        state.hide_timer = mp.add_timeout(hide_delay, function()
          local prev2 = is_visible()
          state.hover_open = false
          state.hide_timer = nil
          apply(prev2)
        end)
      end
    end
  end

  return {
    set_pinned = set_pinned,
    toggle_pinned = function() set_pinned(not state.pinned) end,
    poll = poll,
    is_visible = is_visible,
    is_pinned = function() return state.pinned end,
  }
end

--------------------------------------------------------------------------------
-- NATIVE FILE DIALOGS & WINDOWS API CALLS (PowerShell)
--------------------------------------------------------------------------------

local UTF8_PREAMBLE = "[Console]::OutputEncoding = [Text.Encoding]::UTF8; "

local function run_ps(script)
  local res = utils.subprocess({
    args = { "powershell", "-NoProfile", "-NonInteractive", "-Command", UTF8_PREAMBLE .. script },
    cancellable = false,
  })
  if res.status ~= 0 then
    msg.error("powershell failed: " .. (res.error or res.stderr or "unknown error"))
    return nil
  end
  return res.stdout
end

function M.pick_files_dialog(opts)
  opts = opts or {}
  local title = opts.title or "Open File"
  local filter = opts.filter or "All files|*.*"
  local multi = opts.multiselect ~= false
  local script = string.format([[
Add-Type -AssemblyName System.Windows.Forms
$f = New-Object System.Windows.Forms.OpenFileDialog
$f.Title = '%s'
$f.Filter = '%s'
$f.Multiselect = $%s
if ($f.ShowDialog() -eq 'OK') { $f.FileNames -join "`n" }
]], title:gsub("'", "''"), filter:gsub("'", "''"), multi and "true" or "false")

  local out = run_ps(script)
  local paths = {}
  if out then
    for line in out:gmatch("[^\r\n]+") do
      paths[#paths + 1] = line
    end
  end
  return paths
end

function M.pick_folder_dialog(opts)
  opts = opts or {}
  local desc = opts.description or "Select Folder"
  local script = string.format([[
Add-Type -AssemblyName System.Windows.Forms
$f = New-Object System.Windows.Forms.FolderBrowserDialog
$f.Description = '%s'
if ($f.ShowDialog() -eq 'OK') { $f.SelectedPath }
]], desc:gsub("'", "''"))

  local out = run_ps(script)
  if out then
    out = out:gsub("[\r\n]+$", "")
    if out ~= "" then return out end
  end
  return nil
end

function M.prompt_text_dialog(opts)
  opts = opts or {}
  local title = opts.title or "Enter URL"
  local label = opts.label or "URL:"
  local script = string.format([[
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$form = New-Object System.Windows.Forms.Form
$form.Text = '%s'
$form.Width = 480
$form.Height = 150
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true
$lbl = New-Object System.Windows.Forms.Label
$lbl.Text = '%s'
$lbl.Left = 10
$lbl.Top = 15
$lbl.Width = 440
$form.Controls.Add($lbl)
$box = New-Object System.Windows.Forms.TextBox
$box.Left = 10
$box.Top = 40
$box.Width = 440
$form.Controls.Add($box)
$ok = New-Object System.Windows.Forms.Button
$ok.Text = 'OK'
$ok.Left = 290
$ok.Top = 70
$ok.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.Controls.Add($ok)
$cancel = New-Object System.Windows.Forms.Button
$cancel.Text = 'Cancel'
$cancel.Left = 375
$cancel.Top = 70
$cancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.Controls.Add($cancel)
$form.AcceptButton = $ok
$form.CancelButton = $cancel
if ($form.ShowDialog() -eq 'OK') { $box.Text }
]], title:gsub("'", "''"), label:gsub("'", "''"))

  local out = run_ps(script)
  if out then
    out = out:gsub("[\r\n]+$", "")
    if out ~= "" then return out end
  end
  return nil
end

function M.save_file_dialog(opts)
  opts = opts or {}
  local title = opts.title or "Save File"
  local filter = opts.filter or "Playlist files (*.m3u8)|*.m3u8|All files|*.*"
  local default_name = opts.default_name or ""
  local script = string.format([[
Add-Type -AssemblyName System.Windows.Forms
$f = New-Object System.Windows.Forms.SaveFileDialog
$f.Title = '%s'
$f.Filter = '%s'
$f.FileName = '%s'
if ($f.ShowDialog() -eq 'OK') { $f.FileName }
]], title:gsub("'", "''"), filter:gsub("'", "''"), default_name:gsub("'", "''"))

  local out = run_ps(script)
  if out then
    out = out:gsub("[\r\n]+$", "")
    if out ~= "" then return out end
  end
  return nil
end

function M.get_workarea()
  local script = [[
Add-Type -AssemblyName System.Windows.Forms
$wa = [System.Windows.Forms.Screen]::FromPoint([System.Windows.Forms.Cursor]::Position).WorkingArea
"$($wa.Width)x$($wa.Height)+$($wa.Left)+$($wa.Top)"
]]
  local out = run_ps(script)
  if out then
    out = out:gsub("[\r\n]+$", "")
    if out ~= "" then return out end
  end
  return nil
end

--------------------------------------------------------------------------------
-- PLAYLIST / QUEUE COMMON ACTIONS
--------------------------------------------------------------------------------

function M.playlist_is_empty()
  local pl = mp.get_property_native("playlist", {})
  return #pl == 0
end

function M.add_files_to_playlist(paths)
  local was_empty = M.playlist_is_empty()
  for i, p in ipairs(paths) do
    if i == 1 and was_empty then
      mp.commandv("loadfile", p, "replace")
    else
      mp.commandv("loadfile", p, "append-play")
    end
  end
  if not was_empty and #paths > 0 then
    local pl = mp.get_property_native("playlist", {})
    mp.commandv("playlist-play-index", #pl - #paths)
  end
end

function M.do_add_file()
  local paths = M.pick_files_dialog({
    title = "Add File(s) to Playlist",
    filter = "Media files|*.mp4;*.mkv;*.avi;*.mov;*.webm;*.mp3;*.flac;*.wav;*.m4a;*.ogg|All files|*.*",
    multiselect = true,
  })
  if #paths > 0 then
    M.add_files_to_playlist(paths)
    mp.osd_message(#paths == 1 and "Added 1 file" or ("Added " .. #paths .. " files"), 1.5)
  end
end

function M.do_add_folder()
  local folder = M.pick_folder_dialog({ description = "Add Folder to Playlist" })
  if folder then
    local was_empty = M.playlist_is_empty()
    mp.commandv("loadfile", folder, was_empty and "replace" or "append-play")
    if not was_empty then
      local pl = mp.get_property_native("playlist", {})
      mp.commandv("playlist-play-index", #pl - 1)
    end
    mp.osd_message("Added folder: " .. folder, 1.5)
  end
end

function M.do_add_url()
  local url = M.prompt_text_dialog({ title = "Add URL to Playlist", label = "Enter a media URL:" })
  if url and url ~= "" then
    local was_empty = M.playlist_is_empty()
    mp.commandv("loadfile", url, was_empty and "replace" or "append-play")
    mp.osd_message("Added URL", 1.5)
  end
end

--------------------------------------------------------------------------------
-- SHARED MOUSE DISPATCH (single owner of MBTN_LEFT / MBTN_LEFT_DBL)
--------------------------------------------------------------------------------

local mbtn_left_listeners = {}
local mbtn_left_dbl_listeners = {}
local mbtn_bound = false

function M.on_mbtn_left(name, handler)
  mbtn_left_listeners[name] = handler
end

function M.on_mbtn_left_dbl(name, handler)
  mbtn_left_dbl_listeners[name] = handler
end

local function dispatch_mbtn_left(event)
  for _, handler in pairs(mbtn_left_listeners) do
    handler(event)
  end
end

local function dispatch_mbtn_left_dbl()
  for _, handler in pairs(mbtn_left_dbl_listeners) do
    handler()
  end
end

function M.ensure_mbtn_bound()
  local already = mp.get_property_native("user-data/cadre_common/mbtn_bound", false)
  if already then return end
  mp.set_property_native("user-data/cadre_common/mbtn_bound", true)
  mp.add_forced_key_binding("MBTN_LEFT", "cadre_shared_mbtn_left_" .. mp.get_script_name(),
    dispatch_mbtn_left, { complex = true })
  mp.add_key_binding("MBTN_LEFT_DBL", "cadre_shared_mbtn_left_dbl_" .. mp.get_script_name(),
    dispatch_mbtn_left_dbl)
end

function M.setup_shared_mbtn_left(name, handler)
  mp.register_script_message("cadre_mbtn_left_down", function() handler({ event = "down" }) end)
  mp.register_script_message("cadre_mbtn_left_up", function() handler({ event = "up" }) end)

  local claimed = mp.get_property_native("user-data/cadre_common/mbtn_owner", "")
  if claimed == "" then
    mp.set_property_native("user-data/cadre_common/mbtn_owner", name)
    mp.add_forced_key_binding("MBTN_LEFT", "cadre_mbtn_left_owner", function(event)
      mp.commandv("script-message", "cadre_mbtn_left_" ..
        ((event.event == "up" or event.event == "release") and "up" or "down"))
    end, { complex = true })
  end
end

return M