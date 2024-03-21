local M = {}

M.setup = function()
	local lsp = require("lsp-zero")
	local cmp = require("cmp")

	local cmp_select = { behavior = cmp.SelectBehavior.Select }
	local cmp_mappings = lsp.defaults.cmp_mappings({
		["<S-Tab>"] = nil,
		["<Tab>"] = nil,
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<Enter>"] = cmp.mapping.confirm({ select = true }),
	})

	lsp.setup_nvim_cmp({ mapping = cmp_mappings })
end

return M
