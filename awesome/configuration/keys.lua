local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local keys = {}


Mod = "Mod4"
Ctrl = "Control"
Alt = "Mod1"
Shift = "Shift"


-- Movement Functions (Called by some keybinds)
--
-- Move given client to given direction
local function move_client(c, direction)
   -- If client is floating, move to edge
   if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
      local workarea = awful.screen.focused().workarea
      if direction == "up" then
         c:geometry({nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil})
      elseif direction == "down" then
         c:geometry({nil, y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil})
      elseif direction == "left" then
         c:geometry({x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil})
      elseif direction == "right" then
         c:geometry({x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil, nil})
      end
   -- Otherwise swap the client in the tiled layout
   elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
      if direction == "up" or direction == "left" then
         awful.client.swap.byidx(-1, c)
      elseif direction == "down" or direction == "right" then
         awful.client.swap.byidx(1, c)
      end
   else
      awful.client.swap.bydirection(direction, c, nil)
   end
end

-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
   if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
      if direction == "up" then
         c:relative_move(0, 0, 0, -floating_resize_amount)
      elseif direction == "down" then
         c:relative_move(0, 0, 0, floating_resize_amount)
      elseif direction == "left" then
         c:relative_move(0, 0, -floating_resize_amount, 0)
      elseif direction == "right" then
         c:relative_move(0, 0, floating_resize_amount, 0)
      end
   else
      if direction == "up" then
         awful.client.incwfact(-tiling_resize_factor)
      elseif direction == "down" then
         awful.client.incwfact(tiling_resize_factor)
      elseif direction == "left" then
         awful.tag.incmwfact(-tiling_resize_factor)
      elseif direction == "right" then
         awful.tag.incmwfact(tiling_resize_factor)
      end
   end
end


-- raise focused client
local function raise_client()
   if client.focus then
      client.focus:raise()
   end
end



-- Mouse bindings
--
-- Mouse buttons on the desktop
keys.desktopbuttons = gears.table.join(
   -- left click on desktop to hide notification
   awful.button({}, 1, function ()
       naughty.destroy_all_notifications()
    end)
)

-- Mouse buttons on the client
keys.clientbuttons = gears.table.join(
   -- Raise client
    awful.button({}, 1, function(c)
         client.focus = c
         c:raise()
    end),

   -- Move and Resize Client
   awful.button({Mod}, 1, awful.mouse.client.move),
   awful.button({Mod}, 3, awful.mouse.client.resize)
)



keys.globalkeys = gears.table.join(
-- Application bindings
	awful.key({Mod}, "Return", function()
		awful.spawn(Apps.terminal)
	end, {description = "open terminal", group="launcher"}),

	awful.key({Mod}, "d", function()
		awful.spawn(Apps.launcher)
	end, {description = "open launcher", group="launcher"}),


-- Function keys
	awful.key({}, "Print", function()
		awful.spawn(Apps.screenshot)
	end, {description = "Take screenshot", group="launcher"}),

	-- Media keys

	awful.key({}, "XF86AudioPlay", function()
		awful.spawn("playerctl play-pause")
	end, {description = "Play/Pause", group="launcher"}),

	awful.key({}, "XF86AudioStop", function()
		awful.spawn("playerctl stop")
	end, {description = "Play/Pause", group="launcher"}),

	awful.key({}, "XF86AudioNext", function()
        awful.spawn("playerctl next", false)
	end, {description = "Next song", group="launcher"}),

	awful.key({}, "XF86AudioPrev", function()
        awful.spawn("playerctl previous", false)
	end, {description = "Prev song", group="launcher"}),

	-- Volume

	awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn("amixer sset Master 5%+", false)
	end, {description = "volume up", group="launcher"}),

	awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn("amixer sset Master 5%-", false)
	end, {description = "volume down", group="launcher"}),

	awful.key({}, "XF86AudioMute", function()
        awful.spawn("amixer sset Master 1+ toggle", false)
	end, {description = "volume mute", group="launcher"}),

	-- TODO: backlight

-- Quit signals
	awful.key({Mod,Shift}, "r", function()
		awesome.restart()
	end, {description = "Reload awesome", group="awesome"}),
	-- TODO: Mod + esc / XF86PowerOff - exit screen

-- Client focusing
    awful.key({Mod}, "h", function()
          awful.client.focus.bydirection("left")
          raise_client()
       end, {description = "focus left", group = "client"}),

    awful.key({Mod}, "j", function()
          awful.client.focus.bydirection("down")
          raise_client()
       end, {description = "focus down", group = "client"}),

    awful.key({Mod}, "k", function()
          awful.client.focus.bydirection("up")
          raise_client()
       end, {description = "focus up", group = "client"}),

    awful.key({Mod}, "l", function()
          awful.client.focus.bydirection("right")
          raise_client()
       end, {description = "focus right", group = "client"}),


    awful.key({Mod}, "Left", function()
          awful.client.focus.bydirection("left")
          raise_client()
       end, {description = "focus left", group = "client"}),

    awful.key({Mod}, "Down", function()
          awful.client.focus.bydirection("down")
          raise_client()
       end, {description = "focus down", group = "client"}),

    awful.key({Mod}, "Up", function()
          awful.client.focus.bydirection("up")
          raise_client()
       end, {description = "focus up", group = "client"}),

    awful.key({Mod}, "Right", function()
          awful.client.focus.bydirection("right")
          raise_client()
       end, {description = "focus right", group = "client"}),



-- Screen focusing
    awful.key({Mod}, "s", function()
          awful.screen.focus_relative(1)
	  end),

    awful.key({ Mod, Shift}, "s", function ()
         client.focus:move_to_screen()
       end, {description = "move to screen", group = "client"}),


-- Client resizing
    awful.key({Mod, Ctrl}, "h", function()
          resize_client(client.focus, "left")
       end),

    awful.key({Mod, Ctrl}, "j", function()
          resize_client(client.focus, "down")
       end),

    awful.key({ Mod, Ctrl }, "k", function()
          resize_client(client.focus, "up")
       end),

    awful.key({Mod, Ctrl}, "l", function()
          resize_client(client.focus, "right")
       end),


    awful.key({Mod, Ctrl}, "Left", function()
          resize_client(client.focus, "left")
       end),

    awful.key({Mod, Ctrl}, "Down", function()
          resize_client(client.focus, "down")
       end),

    awful.key({Mod, Ctrl}, "Up", function()
          resize_client(client.focus, "up")
       end),

    awful.key({Mod, Ctrl}, "Right", function()
          resize_client(client.focus, "right")
       end),


-- Number of master / column clients
    awful.key({Mod, Alt}, "h", function()
        awful.tag.incnmaster( 1, nil, true)
       end, {description = "increase the number of master clients", group = "layout"}),

    awful.key({ Mod, Alt }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
       end, {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ Mod, Alt }, "Left", function()
        awful.tag.incnmaster( 1, nil, true)
       end, {description = "increase the number of master clients", group = "layout"}),

    awful.key({ Mod, Alt }, "Right", function()
        awful.tag.incnmaster(-1, nil, true)
       end, {description = "decrease the number of master clients", group = "layout"}),

    awful.key({Mod, Alt}, "k", function()
        awful.tag.incncol(1, nil, true)
       end, {description = "increase the number of columns", group = "layout"}),

    awful.key({Mod, Alt}, "j", function()
        awful.tag.incncol(-1, nil, true)
       end, {description = "decrease the number of columns", group = "layout"}),

    awful.key({Mod, Alt}, "Up", function()
        awful.tag.incncol(1, nil, true)
       end, {description = "increase the number of columns", group = "layout"}),

    awful.key({Mod, Alt}, "Down", function()
        awful.tag.incncol(-1, nil, true)
       end, {description = "decrease the number of columns", group = "layout"}),

-- Gap control
    awful.key({Mod, "Shift"}, "minus", function()
        awful.tag.incgap(5, nil)
       end, {description = "increment gaps size for the current tag", group = "gaps"}),

    awful.key({Mod}, "minus", function()
        awful.tag.incgap(-5, nil)
       end, {description = "decrement gap size for the current tag", group = "gaps"}),

-- Layout selection
    awful.key({Mod}, "space", function()
        awful.layout.inc(1)
       end, {description = "select next", group = "layout"}),

    awful.key({Mod, "Shift"}, "space", function()
        awful.layout.inc(-1)
       end, {description = "select previous", group = "layout"})
)

keys.clientkeys = gears.table.join(
-- Client moving
    awful.key({Mod, "Shift"}, "Down", function(c)
          move_client(c, "down")
       end),

    awful.key({Mod, "Shift"}, "Up", function(c)
          move_client(c, "up")
       end),

    awful.key({Mod, "Shift"}, "Left", function(c)
          move_client(c, "left")
       end),

    awful.key({Mod, "Shift"}, "Right", function(c)
          move_client(c, "right")
       end),

    awful.key({Mod, "Shift"}, "j", function(c)
          move_client(c, "down")
       end),

    awful.key({Mod, "Shift"}, "k", function(c)
          move_client(c, "up")
       end),

    awful.key({Mod, "Shift"}, "h", function(c)
          move_client(c, "left")
       end),

    awful.key({Mod, "Shift"}, "l", function(c)
          move_client(c, "right")
       end),


-- Other awesome control
	-- fullscreen
    awful.key({Mod}, "f", function(c)
        c.fullscreen = not c.fullscreen
       end, {description = "toggle fullscreen", group = "client"}),

    -- close client
    awful.key({Mod}, "q", function(c)
        c:kill()
       end, {description = "close", group = "client"}),

    -- maximize
    awful.key({Mod}, "m", function(c)
          c.maximized = not c.maximized
          c:raise()
       end, {description = "(un)maximize", group = "client"})


-- TODO: mod+tab = last tags
-- TODO: (?) minimization
-- TODO: bind key numbers to tags
-- TODO: sticky window
-- TODO: float single window
)


for i = 1, 9 do
   keys.globalkeys = gears.table.join(keys.globalkeys,
      -- Switch to tag
      awful.key({Mod}, "#" .. i + 9,
         function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               tag:view_only()
            end
         end,
         {description = "view tag #"..i, group = "tag"}
      ),
        -- Toggle tag display.
        awful.key({ Mod, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ Mod, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ Mod, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
   )
end
return keys
