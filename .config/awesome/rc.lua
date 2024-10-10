pcall(require, "luarocks.loader")
require("awful.autofocus")
local awful = require("awful")
local naughty = require("naughty")

-- Check if awesome encountered an error during startup and fell back to default config.
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)

-- Focus on click
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button(
            {}, 1,
            function(c)
                c:activate { context = "mouse_click" }
            end
        ),
    })
end)

require("rules").init()
require("themes").init()
require("keymaps").init()
require("startup")
