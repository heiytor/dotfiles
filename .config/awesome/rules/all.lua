---All clients will match these rules
local M = {}

local awful = require("awful")

M.rule = {
    id         = "global",
    rule       = { },
    properties = {
        focus     = awful.client.focus.filter,
        raise     = true,
        screen    = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
}

return M
