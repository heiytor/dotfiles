return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
		},
	},

	-- diagflow will show only the diagnostics for the current line
	{
		"dgagn/diagflow.nvim",
		event = "LspAttach",
		opts = {},
	},

	-- lsp_lines will show all diagnostics below the current line
	-- {
	-- 	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	-- 	config = function()
	-- 		vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false } })
	-- 		require("lsp_lines").setup()
	-- 	end,
	-- },
}
