local M = {}

local awful = require("awful")
local utils = require("utils")

local std_keys = {
    awful.key(
        { utils.modkey }, "r",
        awesome.restart,
        {
            description = "reload awesome",
            group = "awesome",
        }
    ),
}

M.init = function()
    awful.keyboard.append_global_keybindings(std_keys)
    awful.keyboard.append_global_keybindings(require("keymaps/client").keys)
    awful.keyboard.append_global_keybindings(require("keymaps/command").keys)
    awful.keyboard.append_global_keybindings(require("keymaps/launch").keys)
    awful.keyboard.append_global_keybindings(require("keymaps/tag").keys)

    client.connect_signal("request::default_keybindings", function()
        awful.keyboard.append_client_keybindings(require("keymaps/client").signed_keys)
    end)
end

return M
