return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		default_format_opts = { lsp_format = "fallback" },
		format_on_save = { timeout_ms = 50000 },
		formatters_by_ft = {
			go = { "goimports", "gofumpt" },
			lua = { "stylua" },
			-- yaml = { "yamlfmt" },
			ruby = { "rubocop" },
			elixir = { "mix" },

			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		},
		formatters = {
			rubocop = {
				command = "bundle exec rubocop",
			},
		},
	},
}
