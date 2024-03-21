local M = {}

local awful = require("awful")
local beautiful = require("beautiful")
local bindings = require("bindings")

-- All clients must have these rules
M.properties = {
	rule = {},
	properties = {
		border_width = beautiful.border_width,
		border_color = beautiful.border_normal,
		focus = awful.client.focus.filter,
		raise = true,
		keys = bindings.client_keys,
		buttons = bindings.client_buttons,
		screen = awful.screen.preferred,
		placement = awful.placement.no_overlap + awful.placement.no_offscreen,
	},
}

-- Clients that must start in floating mode.
M.always_floating = {
	rule_any = {
		instance = {
			"DTA", -- Firefox addon DownThemAll.
			"copyq", -- Includes session name in class.
			"pinentry",
		},
		class = {
			"Arandr",
			"Blueman-manager",
			"Gpick",
			"Kruler",
			"MessageWin", -- kalarm.
			"Sxiv",
			"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			"Wpa_gui",
			"veromix",
			"xtightvncviewer",
		},
		-- Note that the name property shown in xprop might be set slightly after creation of the client
		-- and the name shown there might not match defined rules here.
		name = {
			"Event Tester", -- xev.
		},
		role = {
			"AlarmWindow", -- Thunderbird's calendar.
			"ConfigManager", -- Thunderbird's about:config.
			"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
		},
	},
	properties = { floating = true },
}

-- Add titlebars to normal clients and dialogs
M.titlebar = {
	rule_any = {
		type = { "normal", "dialog" },
	},
	properties = { titlebars_enabled = true },
}

-- Custom clients rules
M.custom_rules = {
	{
		rule = { class = "discord" },
		properties = { screen = 1, tag = "9" },
	},
}

return M
