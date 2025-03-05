return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			providers = { "lsp", "treesitter", "regex" },
			delay = 100,
			filetype_overrides = {},
			filetypes_denylist = { "dirbuf", "dirvish", "fugitive" },
			under_cursor = true,
			large_file_cutoff = nil,
			large_file_overrides = nil,
			min_count_to_highlight = 1,
			should_enable = function(_)
				return true
			end,
		})
	end,
}
