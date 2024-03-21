local builtin = require("telescope.builtin")
local keymap = vim.keymap

-- Find files
keymap.set("n", ";f", function()
	builtin.find_files({
		respect_gitignore = false,
		no_ignore = false,
		hidden = true,
	})
end, {})
keymap.set("n", ";p", "<nop>", {}) -- Disable old `find_files` keybinding

-- Find files by word
keymap.set("n", ";r", function()
	builtin.live_grep({
		respect_gitignore = false,
	})
end, {})

-- List functions, variables, constants and related.
keymap.set("n", ";s", function()
	builtin.treesitter()
end, {})

-- Search git files
keymap.set("n", ";g", function()
	builtin.git_files({
		hidden = true,
	})
end, {})
