local awful = require("awful")
local wibox = require("wibox")

local notification_widget = require("lib.widgets.notification_status")
local volume_widget = require("awesome-wm-widgets/volume-widget/volume")

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({ awful.layout.suit.tile })
end)

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	s.tag_list = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
		},
	})

	s.task_list = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.focused,
		buttons = {},
	})

	s.mywibox = awful.wibar({
		position = "bottom",
		screen = s,
		widget = {
			layout = wibox.layout.align.horizontal,
			{
				layout = wibox.layout.fixed.horizontal,
				s.tag_list,
			},
			s.task_list,
			{
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.textclock(),
				volume_widget({ widget_type = "arc" }),
				notification_widget.build("🔔", "🔕", false),
				wibox.widget.systray(),
			},
		},
	})
end)
