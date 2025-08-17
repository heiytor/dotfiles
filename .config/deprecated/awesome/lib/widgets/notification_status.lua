local naughty = require("naughty")
local wibox = require("wibox")
local gears = require("gears")
local yard = require("lib.yard")

local M = {}

M.build = function(active_icon, inactive_icon, destroy_all_after_changes)
	destroy_all_after_changes = destroy_all_after_changes or false

	local widget = wibox.widget({
		{
			{
				id = "icon",
				text = active_icon,
				widget = wibox.widget.textbox,
			},
			id = "margin",
			top = 4,
			bottom = 4,
			left = 8,
			right = 8,
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		shape = function(cr, _, _)
			gears.shape.transform(gears.shape.rounded_rect):translate(0, 5)(cr, 32, 21, 5)
		end,
		toggle_notifications = function(self)
			self.margin.icon.text = naughty.suspended and active_icon or inactive_icon
			yard.show(self.margin.icon.text, naughty.suspended and "normal" or "critical")

			naughty.suspended = not naughty.suspended

			if destroy_all_after_changes then
				naughty.destroy_all_notifications()
			end
		end,
	})

	widget:connect_signal("button::press", function(c, _, _, button)
		if button ~= 1 then
			return
		end

		c:toggle_notifications()
	end)

	return widget
end

return M
