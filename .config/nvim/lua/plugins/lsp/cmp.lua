local M = {}

local cmp = require("cmp")

M.setup = function()
    cmp.setup({
        sources = {
            { name = "nvim_lsp" },
        },
        mapping = {
            ["<S-Tab>"] = nil,
            ["<Tab>"] = nil,
            ["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
            ["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
            ["<Enter>"] = cmp.mapping.confirm({ select = true }),
            ["<Esc>"] = cmp.mapping.abort(),
        },
    })
end

return M
