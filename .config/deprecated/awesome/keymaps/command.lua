local M = {}

local awful = require("awful")
local utils = require("utils")

---Keybindings that executes a custom command.
M.keys = {
    awful.key(
        { }, "Print",
        function()
            awful.spawn("flameshot gui")
        end,
        {
            description="Print the screen",
            group="command"
        }
    ),
    awful.key(
        { utils.modkey }, "f",
        function()
            awful.spawn("/home/heitor/.config/awesome/scripts/toggle-microphone")
        end,
        {
            description="Toggle microphone",
            group="command"
        }
    ),
}

return M
