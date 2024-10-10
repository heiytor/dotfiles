local M = {}

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local utils = require("utils")

M.init = function()
    beautiful.init(utils.root_dir .. "/themes/dark/theme.lua")

    screen.connect_signal("request::wallpaper", function(s)
        awful.wallpaper({
            screen = s,
            widget = {
                image                 = beautiful.wallpaper,
                widget                = wibox.widget.imagebox,
                horizontal_fit_policy = "fit",
                vertical_fit_policy   = "fit",
                upscale               = true,
                downscale             = true,
                valign                = "center",
                halign                = "center",
                tiled                 = false,
            },
        })
    end)

    require("themes/dark/wibox")
    require("themes/dark/extra")
end

return M
