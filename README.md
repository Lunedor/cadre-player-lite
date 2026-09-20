# Cadre UI for mpv

A modular, custom graphical interface suite for the mpv media player. Cadre replaces the default UI with a desktop-first, neumorphic design featuring an advanced playlist manager, an interactive on-screen controller (OSC), and a custom titlebar.

## Features

* **Cadre OSC:** A floating control bar with a dynamic seekbar, volume flyout slider, and integrated menus for adding media.
* **Cadre Playlist:** A searchable, scrollable playlist overlay. Supports drag-and-drop reordering, dynamic text filtering, shuffle/repeat toggling, and native deletion to the Windows Recycle Bin.
* **Cadre Titlebar:** A frameless window titlebar replacement with custom minimize, maximize, and close controls.
* **Native Dialogs:** Utilizes PowerShell integration to open native Windows file pickers, folder selectors, and text prompts directly within mpv.
* **Centralized Theming:** Colors, transparencies, dimensions, and typography are globally managed through a single configuration file.

## Requirements

* **mpv** (latest release recommended).
* **Windows OS:** The scripts rely on `powershell` subprocesses to render native file dialogs and handle file deletion to the Recycle Bin.
* **Fonts:** The UI relies on `Material Icons Outlined` (OSC/Playlist) and `Segoe MDL2 Assets` (Titlebar). Ensure these are installed on your system.

## Installation

1. Open your mpv configuration directory (usually `%APPDATA%\mpv\` on Windows).
2. Copy the following files into your `scripts` folder:
* `cadre_common.lua`
* `cadre_osc.lua`
* `cadre_playlist.lua`
* `cadre_titlebar.lua`
* `cadre_theme.lua`


3. Open your `mpv.conf` file and add the following lines to disable the default UI and window borders:
```ini

osc=no
osd-bar=no
border=no
autofit-smaller=800x450


```



## Optional: Thumbnail Previews (Thumbfast)

Cadre OSC includes built-in support for seekbar thumbnail previews using [thumbfast](https://github.com/po5/thumbfast?utm_source=gemini).

To enable this feature:

1. Download `thumbfast.lua` from its repository.
2. Place `thumbfast.lua` into your mpv `scripts` directory alongside the Cadre files.
3. Cadre will automatically detect thumbfast and display thumbnails when hovering over the seekbar. No additional configuration is required.

## Configuration & Theming

All visual settings are controlled via `cadre_theme.lua`. You can modify this file to adjust hex color codes, alpha transparency levels, widget dimensions, and fonts.

Overrides are available for specific components. For example, setting `color_bar_bg_pl` allows the playlist to use a different background color than the global `color_bar_bg`.

## Default Keybindings

Cadre utilizes standard mouse interactions (click, drag, scroll) for its UI components. Specialized bindings include:


* **`DEL`** : Remove selected item from the playlist.
* **`Shift+DEL`** : Move the selected file directly to the Windows Recycle Bin.
