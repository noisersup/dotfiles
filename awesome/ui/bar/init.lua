local gears = require("gears") -- Standard awesome library
local awful = require("awful")
local beautiful = require("beautiful")

local wibox = require("wibox") -- Widget and layout library

mytextclock = wibox.widget.textclock()

local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ Mod }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ Mod }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )


local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

awful.screen.connect_for_each_screen(function(s)
	-- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
		widget_template = {
			{
				{
					{
						{
							id     = 'icon_role',
							widget = wibox.widget.imagebox,
						},
						margins = 3,
						widget  = wibox.container.margin,
					},
					{
						id     = 'text_role',
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				widget = wibox.container.margin
			},
			id     = 'background_role',
			widget = wibox.container.background,
		},
    }

    ---- Create a tasklist widget
    --s.mytasklist = awful.widget.tasklist {
    --    screen  = s,
    --    filter  = awful.widget.tasklist.filter.currenttags,
    --    buttons = tasklist_buttons
    --}

	-- TODO: switch between top and left
	-- TODO: hide wibar
    s.mywibox = awful.wibar({ position = "top", screen = s, bg = beautiful.bg_normal .. "00", height = dpi(15)})

	local systray = wibox.widget.systray()
	systray:set_base_size(15)

	-- Add widgets to the wibox
    s.mywibox:setup {
		expand="none",
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        --s.mytasklist, -- Middle widget
		require("widgets.calendar").create(s), --placeholder, I liked it!!
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            --mytextclock,
            s.mylayoutbox,
        },
	}
end)
