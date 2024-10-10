local awful = require("awful")
local utils = require("utils")

return {
    link = function ()
        -- links ./theme.conf to ${kitty_dir}/theme.conf
        awful.spawn.with_shell("ln -sf " .. utils.themes_dir .. "/dark/extra/kitty/theme.conf " .. os.getenv("HOME") .. "/.config/kitty/theme.conf")
    end
}
