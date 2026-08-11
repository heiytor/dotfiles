local servers = {
	dockerls = {},
	docker_compose_language_service = {},

	lua_ls = {
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
	},

	gopls = {
		cmd = { "gopls", "--remote=auto" },
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
	},

	jsonls = {
		filetypes = { "json", "jsonc" },
	},

	bashls = {
		filetypes = { "sh", "aliasrc" },
	},

	basedpyright = {
		settings = {
			basedpyright = {
				disableOrganizeImports = true,
				analysis = {
					inlayHints = {
						variableTypes = true,
						callArgumentNames = true,
						functionReturnTypes = true,
						genericTypes = true,
					},
				},
			},
		},
	},

	ruff = {
		on_attach = function(client, _)
			client.server_capabilities.hoverProvider = false
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
	},
}

return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim" },
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "j-hui/fidget.nvim" },
		},
		lazy = false,
		opts = {
			ensure_installed = vim.tbl_keys(servers),
			automatic_enable = { exclude = { "stylua" } },
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			for server, config in pairs(servers) do
				vim.lsp.config(server, config)
			end
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = function()
			return {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
			}
		end,
	},
}
