local awful = require("awful")
local utils = require("utils")

return {
    link = function ()
        -- links ./theme.lua to ${nvim_dir}/lua/theme/current.lua
        awful.spawn.with_shell("ln -sf " .. utils.themes_dir .. "/dark/extra/nvim/theme.lua " .. os.getenv("HOME") .. "/.config/nvim/lua/theme/current.lua")
    end
}
