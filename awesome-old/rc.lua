-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")

-- ==== CONFIG

local theme = "pastel"
local theme_config_dir = gears.filesystem.get_configuration_dir() .. "/configuration/" .. theme .. "/"

apps = {
  launcher = "rofi -show drun",
  terminal = "st",
  editor = "nvim",--os.getenv("EDITOR") or "nano",
  --editor_cmd = terminal .. " -e " .. editor
}

network_interfaces = {
   wlan = 'wlp3s0',
   lan = 'enp0s25'
}

-- startup apps
local autorun = {
  "picom --experimental-backend -b",
  "unclutter",
  "flameshot",
  "birdtray",
}


-- ==== INITIALIZATION

-- execute autorun apps
for _, app in ipairs(autorun) do
  local findme = app
  local firstapce = app:find(" ")
  if firstspace then
    findme = app:sub(0, firstpace - 1)
  end

  awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. theme .. "-theme.lua")

-- Initialize theme
local selected_theme = require(theme)
selected_theme.initialize()

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Define layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
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

-- remove gaps if layout is set to max
tag.connect_signal('property::layout', function(t)
   local current_layout = awful.tag.getproperty(t, 'layout')
   if (current_layout == awful.layout.suit.max) then
      t.gap = 0
   else
      t.gap = beautiful.useless_gap
   end
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
   -- Set the window as a slave (put it at the end of others instead of setting it as master)
   if not awesome.startup then
      awful.client.setslave(c)
   end

   if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
   end
end)


-- ==== Client focusing
require("awful.autofocus")

-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c)
   c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- ==== multi monitor

-- Reload config when geometry changes
screen.connect_signal("property::geometry", awesome.restart)

-- Garbage collection
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
