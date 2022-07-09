pcall(require, "luarocks.loader")
local gears = require("gears") -- Standard awesome library
local awful = require("awful")

local wibox = require("wibox") -- Widget and layout library

local beautiful = require("beautiful") -- Theme handling library

local naughty = require("naughty") -- Notification library
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

dpi = beautiful.xresources.apply_dpi

--TODO: add all colors and move to theme
--tag_colors = {"#957CCB", "#B86597", "#BF5F5F", "#ff9678","#5398be", "#6CC6B4", "#68bd4c", "#d2d747", "#FFC464"}
tag_colors = {"#cc241d","#d79921","#98971a","#b16286","#458588","#a89984","#689d6a","#fabd2f","#d3869b"}
--tag_colors = {"#ebebeb","#e0e0e0","#d6d6d6","#d2d2d2","#c2c2c2","#b3b3b3","#a3a3a3","#949494","#848484"}

require("awful.hotkeys_popup.keys")

-- Handle startup errors
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

Screen_width = awful.screen.focused().geometry.width
Screen_height = awful.screen.focused().geometry.height


Apps = {
	launcher = "rofi -show drun",
	terminal = "st",
	editor = os.getenv("EDITOR") or "nvim",
	screenshot = "flameshot gui",
	lock = "blurlock"
}

local autostart = {
	"picom --experimental-backend -b",

	-- TODO: move these only on nixpc
	"ckb-next -b",
	--"xrandr --output DP-4 --mode \"1920x1080\" --rate 120",
	--

	"flameshot",
	"unclutter",
}

-- execute autorun apps
for _, app in ipairs(autostart) do
  local findme = app
  local firstspace = app:find(" ")
  if firstspace then
    findme = app:sub(0, firstspace - 1)
  end

  awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end

require("configuration")
require("ui")

-- Garbage collection
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
