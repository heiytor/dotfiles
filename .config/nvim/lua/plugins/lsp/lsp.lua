local function default_capabilities()
	return vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities()
	)
end

return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "j-hui/fidget.nvim" },
		},
		lazy = false,
		event = "BufReadPre",
		opts = {
			automatic_installation = true,
			ensure_installed = {
				"lua_ls",
				"stylua",
				"gopls",
				"gofumpt",
				"goimports",
				"jsonls",
				"bashls",
				"dockerls",
				"docker_compose_language_service",
				"prettier",
				"prettierd",
				-- "yamlls",
				-- "yamlfmt",
				-- "ruby_lsp",
				-- "rubocop",
			},
			handlers = {
				function(server_name) -- default handler
					require("lspconfig")[server_name].setup({ capabilities = default_capabilities() })
				end,
				["elixir-ls"] = function()
					require("lspconfig").elixirls.setup({
						capabilities = default_capabilities(),
						cmd = { vim.fn.stdpath("data") .. "/mason/bin/elixir-ls" },
					})
				end,
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						capabilities = default_capabilities(),
						settings = {
							Lua = {
								hint = {
									enable = true,
								},
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
				["gopls"] = function()
					require("lspconfig").gopls.setup({
						cmd = { "gopls", "--remote=auto" },
						capabilities = default_capabilities(),
						settings = {
							gopls = {
								gofumpt = true,
								hints = {
									assignVariableTypes = true,
									ignoredError = true,
									compositeLiteralFields = true,
									compositeLiteralTypes = true,
									constantValues = true,
									parameterNames = true,
									functionTypeParameters = true,
									rangeVariableTypes = true,
								},
							},
						},
					})
				end,
				["rubocop"] = function()
					require("lspconfig").rubocop.setup({
						capabilities = default_capabilities(),
						cmd = { "bundle", "exec", "rubocop", "--lsp" },
					})
				end,
				["ruby_lsp"] = function()
					require("lspconfig").ruby_lsp.setup({
						capabilities = default_capabilities(),
						mason = false,
						cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
						init_options = {
							inlayHint = {
								featuresConfiguration = {
									enableAll = true,
								},
							},
						},
					})
				end,
				["jsonls"] = function()
					require("lspconfig").jsonls.setup({
						capabilities = default_capabilities(),
						filetypes = { "json", "jsonc" },
					})
				end,
				["bashls"] = function()
					require("lspconfig").bashls.setup({
						capabilities = default_capabilities(),
						filetypes = { "sh", "aliasrc" },
					})
				end,
				["dockerls"] = function()
					require("lspconfig").dockerls.setup({
						capabilities = default_capabilities(),
					})
				end,
				["docker_compose_language_service"] = function()
					require("lspconfig").docker_compose_language_service.setup({
						capabilities = default_capabilities(),
					})
				end,
				["yamlls"] = function()
					require("lspconfig").yamlls.setup({
						capabilities = default_capabilities(),
					})
				end,
			},
		},
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			capabilities = default_capabilities(),
			-- Remove TypeScript-tools formatting capabilities to avoid conflicts with Conform
			on_attach = function(client, _)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		},
	},
}
