local awful = require("awful")
local wallpaper = "/home/user/.config/awesome/ui/wallpaper/gruvbox.png"
awful.spawn.with_shell("feh --bg-fill " .. wallpaper)
--TODO: maybe animated?
