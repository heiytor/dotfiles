local M = {}

local utils = require("utils")

M.with_shell = {
	-- "setxkbmap -model abnt2 -layout br",
	"feh --bg-scale "
		.. utils.AWESOME_DIR
		.. "/wallpapers/samurai.png",
	"flameshot",
	"discord --start-minimized",
	"/home/heitor/.config/awesome/scripts/polybar",
	"picom",
}

return M
