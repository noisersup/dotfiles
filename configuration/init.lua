local gears = require("gears") -- Standard awesome library
local awful = require("awful")

local wibox = require("wibox") -- Widget and layout library

local beautiful = require("beautiful") -- Theme handling library

local naughty = require("naughty") -- Notification library
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

require("awful.hotkeys_popup.keys")

-- Client focusing
require("awful.autofocus")

-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c)
   c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- ==== multi monitor

-- Reload config when geometry changes
screen.connect_signal("property::geometry", awesome.restart)

-- setup theme
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

awful.screen.connect_for_each_screen(function(s)
	--TODO: wallpaper
	for i = 1, 9, 1
	do
	  awful.tag.add(i, {
	     icon = gears.surface.load_from_shape(20,20,gears.shape.circle,"pink"),
	     icon_only = true,
	     layout = awful.layout.suit.tile,
	     screen = s,
	     selected = i == 1
	  })
	end
end)

-- Import Keybinds
local keys = require("configuration.keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

local create_rules = require("configuration.rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)
