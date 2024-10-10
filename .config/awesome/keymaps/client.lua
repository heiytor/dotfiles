local M = {}

local awful = require("awful")
local utils = require("utils")

---Client-related keybindings
M.keys = {
    awful.key(
        { utils.modkey }, "h",
        function()
            awful.client.focus.byidx(-1)
        end,
        {
            description = "Focus previous client",
            group = "client",
        }
    ),
    awful.key(
        { utils.modkey }, "l",
        function()
            awful.client.focus.byidx(1) 
        end,
        {
            description = "Focus next client",
            group = "client",
        }
    ),
    awful.key(
        { utils.modkey, "Shift" }, "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {
            description = "Decrease master client width factor",
            group = "client",
        }
    ),
    awful.key(
        { utils.modkey, "Shift" }, "l",
        function()
            awful.tag.incmwfact(0.05)
        end,
        {
            description = "Increase master client width factor",
            group = "client",
        }
    ),
}

---Signed client-related keybindings. It's similar to 'keys' but needs to be used in a 
-- client's 'request::default_keybindings' signal.
M.signed_keys = {
    awful.key(
        { utils.modkey }, "Delete",
        function(c)
            c:kill()
        end,
        {
            description = "Close client",
            group = "client"
        }
    ),
    awful.key(
        { utils.modkey }, "n",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {
            description = "Move client to master column",
            group = "client",
        }
    ),
    awful.key(
        { utils.modkey }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {
            description = "(Un)maximize focused client",
            group = "client"
        }
    ),
    awful.key(
        { utils.modkey, "Shift" }, "n",
        function ()
            local c = awful.client.restore()
            if c then
                c:activate { raise = true, context = "key.unminimize" }
            end
        end,
        {
            description = "restore minimized",
            group = "client"
        }
    ),
}

return M
