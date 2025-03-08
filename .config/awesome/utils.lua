local M = {}

local naughty = require("naughty")

---Awesome's root directory.
M.root_dir = os.getenv("HOME") .. "/.config/awesome"

---Script's directory.
M.scripts_dir = M.root_dir .. "/scripts"

---Theme's directory.
M.themes_dir = M.root_dir .. "/themes"

---View's directory.
M.views_dir = M.root_dir .. "/views"

---Awesome's leader key.
M.modkey = "Mod4"

---Send a debug notification.
M.debug = function(title)
	naughty.notification({ title = title })
end

return M
