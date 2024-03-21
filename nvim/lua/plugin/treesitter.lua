require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"cpp",
		"go",
		"lua",
		"rust",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		disable = {},
		additional_vim_regex_highlighting = false,
	},
})

require("treesitter-context").setup({
	enable = true,
	max_lines = 0,
	min_window_height = 0,
	line_numbers = true,
	multiline_threshold = 20,
	trim_scope = "outer",
	mode = "cursor",
	separator = nil,
	zindex = 20,
	on_attach = nil,
})
