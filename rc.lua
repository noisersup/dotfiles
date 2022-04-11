pcall(require, "luarocks.loader")
local gears = require("gears") -- Standard awesome library
local awful = require("awful")

local wibox = require("wibox") -- Widget and layout library

local beautiful = require("beautiful") -- Theme handling library

local naughty = require("naughty") -- Notification library
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

dpi = beautiful.xresources.apply_dpi


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

Apps = {
	launcher = "rofi -show drun",
	terminal = "st",
	editor = os.getenv("EDITOR") or "nvim"
}

Screen_width = awful.screen.focused().geometry.width
Screen_height = awful.screen.focused().geometry.height

require("configuration")
require("ui")

-- Garbage collection
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
