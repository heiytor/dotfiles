local M = {}

local awful = require("awful")
local naughty = require("naughty")
local ruled = require("ruled")

M.init = function()
    ruled.client.connect_signal("request::rules", function()
        ruled.client.append_rule(require("rules/all").rule)
        ruled.client.append_rule(require("rules/floating").rule)
        ruled.client.append_rule(require("rules/discord").rule)
        ruled.notification.append_rule({
            rule       = { },
            properties = {
                screen           = awful.screen.preferred,
                implicit_timeout = 5,
            }
        })
    end)

    -- Fix notification size
    naughty.connect_signal("request::display", function(n)
        naughty.layout.box { notification = n }
    end)
end

return M
