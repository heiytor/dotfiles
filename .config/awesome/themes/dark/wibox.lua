local awful = require("awful")
local wibox = require("wibox")

local notification_widget = require("lib.widgets.notification_status")
local volume_widget = require("awesome-wm-widgets/volume-widget/volume")

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({ awful.layout.suit.tile })
end)

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "" }, s, awful.layout.layouts[1])
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		height = 25,
		widget = {
			layout = wibox.layout.align.horizontal,
			{
				layout = wibox.layout.fixed.horizontal,
				awful.widget.taglist({ -- Taglist
					screen = s,
					filter = awful.widget.taglist.filter.all,
					buttons = {
						awful.button({}, 1, function(t)
							t:view_only()
						end),
					},
				}),
			},
			awful.widget.tasklist({ -- Tasklist
				screen = s,
				filter = awful.widget.tasklist.filter.currenttags,
				buttons = {
					awful.button({}, 1, function(c)
						c:activate({ context = "tasklist", action = "toggle_minimization" })
					end),
				},
			}),
			{
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.textclock(),
				volume_widget({ widget_type = "arc" }),
				notification_widget.build("🔔", "🔕", false),
				wibox.widget.systray(),
				awful.widget.layoutbox({ -- Layoutbox
					screen = s,
					buttons = {
						awful.button({}, 1, function()
							awful.layout.inc(1)
						end),
						awful.button({}, 3, function()
							awful.layout.inc(-1)
						end),
						awful.button({}, 4, function()
							awful.layout.inc(-1)
						end),
						awful.button({}, 5, function()
							awful.layout.inc(1)
						end),
					},
				}),
			},
		},
	})
end)
