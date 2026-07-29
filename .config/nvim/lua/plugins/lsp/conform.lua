local args_cache = {}

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

			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },

			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		},
		formatters = {
			rubocop = {
				command = function(_, ctx)
					local root = vim.fs.root(ctx.dirname, "Gemfile")
					local cmd, args

					if not root then
						cmd, args = "rubocop", {}
					elseif vim.fn.executable(root .. "/bin/rubocop") == 1 then
						cmd, args = root .. "/bin/rubocop", {}
					elseif vim.fn.executable(root .. "/bin/bundle") == 1 then
						cmd, args = root .. "/bin/bundle", { "exec", "rubocop" }
					else
						cmd, args = "bundle", { "exec", "rubocop" }
					end

					args_cache[ctx.buf] = args

					return cmd
				end,
				prepend_args = function(_, ctx)
					local args = args_cache[ctx.buf] or {}
					args_cache[ctx.buf] = nil

					return args
				end,
			},
		},
	},
}
