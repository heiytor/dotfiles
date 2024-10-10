local M = {}

local awful = require("awful")
local utils = require("utils")

---Tag-related keybindings
M.keys = {
    awful.key({
        modifiers   = { utils.modkey },
        keygroup    = "numrow",
        description = "View tag[n]",
        group       = "tag",
        on_press    = function(i)
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end,
    }),
    awful.key({
        modifiers   = { utils.modkey, "Shift" },
        keygroup    = "numrow",
        description = "Move focused client to tag[n]",
        group       = "tag",
        on_press    = function(i)
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    }),
}

return M
