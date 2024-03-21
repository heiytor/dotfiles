local keymap = require("utils.keymap")

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local keys = {
			{
				mode = "n",
				lhs = keymap.toggle("g"),
				rhs = gs.toggle_current_line_blame,
				opts = {
					desc = "Toggle [git] line blame.",
				},
			},
		}

		keymap.setN(keys, { buffer = bufnr })
	end,

	current_line_blame_opts = { delay = 10 },
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})
