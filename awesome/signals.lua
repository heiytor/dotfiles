local M = {}

local awful = require("awful")
local beautiful = require("beautiful")

M.clients = {
	{
		signal = "manage",
		cb = function(c)
			-- Set the windows at the slave,
			-- i.e. put it at the end of others instead of setting it master.
			-- if not awesome.startup then awful.client.setslave(c) end

			if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
				-- Prevent clients from being unreachable after screen count changes.
				awful.placement.no_offscreen(c)
			end
		end,
	},

	{
		signal = "focus",
		cb = function(c)
			c.border_color = beautiful.border_focus
		end,
	},

	{
		signal = "unfocus",
		cb = function(c)
			c.border_color = beautiful.border_normal
		end,
	},
}

return M
