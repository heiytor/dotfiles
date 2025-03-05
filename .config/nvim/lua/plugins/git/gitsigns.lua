return {
	"lewis6991/gitsigns.nvim",
	opts = {
		current_line_blame = true,
		current_line_blame_opts = { delay = 50 },
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local keys = require("utils.keys")
			vim.keymap.set("n", keys.toggle("g"), gitsigns.toggle_current_line_blame, { buffer = bufnr })
		end,
	},
}
