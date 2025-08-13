return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		default_format_opts = { lsp_format = "fallback" },
		format_on_save = { timeout_ms = 500 },
		formatters_by_ft = {
			go = { "goimports", "gofumpt" },
			lua = { "stylua" },
			-- yaml = { "yamlfmt" },
			ruby = { "rubocop" },
		},
		formatters = {
			rubocop = {
				command = "bundle exec rubocop",
			},
		},
	},
}
