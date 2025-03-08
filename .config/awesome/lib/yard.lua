local awful = require("awful")
local utils = require("utils")

local M = {}

M._views = {
	["critical"] = "style.critical.css",
	["normal"] = "style.normal.css",
}

M.show = function(text, level)
	local command = string.format(
		"yad --text \"<span size='128pt'>%s</span>\" --center --fixed --no-buttons --timeout 1 --css %s --borders 50 --splash --no-focus",
		text,
		utils.views_dir .. "/views/style." .. M._views[level] .. ".css"
	)

	awful.spawn(command)
end

return M
