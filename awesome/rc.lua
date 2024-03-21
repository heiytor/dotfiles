-- awesome standard imports
pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local naughty = require("naughty")
require("awful.hotkeys_popup.keys")

-- my imports
require("theme")
local rules = require("rules")
local bindings = require("bindings")
local signals = require("signals")
local startup = require("startup")

-- {{{ Error handling
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.max,
}

awful.screen.connect_for_each_screen(function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

root.keys(bindings.global_keys)

-- Rules are applied through "manage" signal.
awful.rules.rules = { rules.properties, rules.always_floating }
for _, rule in ipairs(rules.custom_rules) do
	table.insert(awful.rules.rules, rule)
end

for _, s in ipairs(signals.clients) do
	client.connect_signal(s.signal, s.cb)
end

for _, p in ipairs(startup.with_shell) do
	awful.spawn.with_shell(p)
end
