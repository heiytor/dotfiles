local M = {}

local gears = require("gears")
local awful = require("awful")

local utils = require("utils")

M.global_keys = gears.table.join(
	-- {{{
	-- Launcher
	awful.key({ utils.MODKEY }, "Tab", function()
		awful.spawn(utils.AWESOME_DIR .. "/scripts/rofi_drun")
	end, { description = "Show 'run' script", group = "launcher" }),

	awful.key({ utils.MODKEY }, "a", function()
		awful.spawn("alacritty")
	end, { description = "open a terminal", group = "launcher" }),

	awful.key({ utils.MODKEY }, "s", function()
		awful.spawn("firefox")
	end, { description = "Open a browser", group = "launcher" }),

	awful.key({}, "Print", function()
		awful.spawn("flameshot gui")
	end, { description = "Printscreen", group = "Commands" }),

	awful.key({ utils.MODKEY }, "r", awesome.restart, { description = "Reload", group = "awesome" }),
	-- }}}

	-- {{{
	-- Client manipulation
	awful.key({ utils.MODKEY }, "l", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next client", group = "client" }),

	awful.key({ utils.MODKEY }, "h", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous client", group = "client" }),
	-- }}}

	-- {{{
	-- Layout manipulation
	awful.key({ utils.MODKEY, "Shift" }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "Decrease master width factor", group = "window" }),

	awful.key({ utils.MODKEY, "Shift" }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "Increase master width factor", group = "window" })
	-- }}}
)

-- Bind all key numbers to tags.
for i = 1, 9 do
	M.global_keys = gears.table.join(
		M.global_keys,
		awful.key({ utils.MODKEY }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		awful.key({ utils.MODKEY, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" })
	)
end

M.client_keys = gears.table.join(
	awful.key({ utils.MODKEY }, "Delete", function(c)
		c:kill()
	end, { description = "close", group = "client" }),

	awful.key({ utils.MODKEY }, "n", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),

	awful.key({ utils.MODKEY }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" })
)

M.client_buttons = gears.table.join(
	-- focus on click
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end)
)

return M
