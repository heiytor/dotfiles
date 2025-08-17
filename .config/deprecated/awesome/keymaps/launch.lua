local M = {}

local awful = require("awful")
local utils = require("utils")

---Keybindings that launch programs.
M.keys = {
    awful.key(
        { utils.modkey }, "Tab",
        function()
            awful.spawn(utils.scripts_dir .. "/rofi_drun") 
        end,
        {
            description="Run shell prompt",
            group="launch",
        }
    ),
    awful.key(
        { utils.modkey }, "a",
        function()
            awful.spawn("kitty")
        end,
        {
            description="Open a terminal",
            group="launch"
        }
    ),
    awful.key(
        { utils.modkey }, "s",
        function()
            awful.spawn("firefox -P") 
        end,
        {
            description="Open a browser",
            group="launch",
        }
    ),
}

return M
