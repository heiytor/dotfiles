local keymap = require("utils.keymap")
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local keys = {
	{
		mode = "n",
		lhs = keymap.leader("a"),
		rhs = mark.add_file,
		opts = {},
	},
	{
		mode = "n",
		lhs = keymap.leader("h"),
		rhs = ui.toggle_quick_menu,
		opts = {},
	},
	-- TODO: keymap to close a buffer
	{
		mode = "n",
		lhs = keymap.ctrl("h"),
		rhs = function()
			ui.nav_file(1)
		end,
		opts = {},
	},
	{
		mode = "n",
		lhs = keymap.ctrl("j"),
		rhs = function()
			ui.nav_file(2)
		end,
		opts = {},
	},
	{
		mode = "n",
		lhs = keymap.ctrl("k"),
		rhs = function()
			ui.nav_file(3)
		end,
		opts = {},
	},
	{
		mode = "n",
		lhs = keymap.ctrl("l"),
		rhs = function()
			ui.nav_file(4)
		end,
		opts = {},
	},
}

keymap.setN(keys, {})
