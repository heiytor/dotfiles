return {
	"nvim-telescope/telescope.nvim",
	config = function()
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", ";s", function()
			builtin.live_grep({
				respect_gitignore = false,
			})
		end)

		vim.keymap.set("n", ";f", function()
			builtin.find_files({
				respect_gitignore = false,
				no_ignore = false,
				hidden = true,
			})
		end)

		vim.keymap.set("n", ";r", function()
			builtin.treesitter()
		end)
	end,
}
