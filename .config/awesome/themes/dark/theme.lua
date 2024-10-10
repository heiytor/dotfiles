local M = {}

local xresources = require("beautiful.xresources")
local notification_rule = require("ruled.notification")
local assets = require("beautiful.theme_assets")

local utils = require("utils")
local theme_dir = utils.themes_dir .. "/dark"

M.font = "Font Awesome 9"

-- Background
M.bg_normal   = "#1a1b26"
M.bg_focus    = M.bg_normal
M.bg_minimize = M.bg_normal
M.bg_systray  = M.bg_normal
M.bg_urgent   = "#ff0000"

-- Foreground
M.fg_normal   = "#c0caf5"
M.fg_focus    = M.fg_normal
M.fg_urgent   = M.fg_normal
M.fg_minimize = M.fg_normal

-- Gap and borders
M.useless_gap         = xresources.apply_dpi(3)
M.border_width        = xresources.apply_dpi(1)
M.border_color_normal = "#000000"
M.border_color_active = "#c0caf5"

-- Notitications
M.notification_bg = M.bg_normal
M.notification_fg = M.fg_normal

-- Set critical bg to urgency notifications
notification_rule.connect_signal('request::rules', function()
    notification_rule.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

-- Selected and Unselected tag squares
M.taglist_squares_sel = assets.taglist_squares_sel(xresources.apply_dpi(4), M.fg_normal)
M.taglist_squares_unsel = assets.taglist_squares_unsel(xresources.apply_dpi(4), M.fg_normal)

M.tasklist_disable_icon = true

M.wallpaper = theme_dir .. "/background.jpg"

return M
