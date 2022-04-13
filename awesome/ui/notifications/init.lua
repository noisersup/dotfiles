local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

naughty.config.defaults.ontop = true
naughty.config.defaults.position = "top_right"
naughty.config.defaults.icon_size = dpi(32)

naughty.config.defaults.shape = function(cr, w, h)
   gears.shape.rounded_rect(cr, w, h, dpi(6))
end

naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3

naughty.config.padding = dpi(7)
naughty.config.spacing = dpi(7)
naughty.config.icon_dirs = {
   "/usr/share/icons/Tela-dark",
   "/usr/share/pixmaps/"
}

naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.low = {
   font = beautiful.title_font,
   fg = beautiful.fg_normal,
   bg = beautiful.bg_normal,
   position = "top_right"
}
