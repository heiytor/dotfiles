local M = {}

local keymap = require("utils/keymap")
local lsp = require("lsp-zero")

M.setup = function()
    lsp.on_attach(function(_, bufnr)
        local keys = {
            {
                mode = "n",
                lhs = "<F2>",
                rhs = vim.lsp.buf.rename,
                opts = {},
            },
            {
                mode = "n",
                lhs = "gd",
                rhs = vim.lsp.buf.definition,
                opts = {},
            },
            {
                mode = "n",
                lhs = "K",
                rhs = vim.lsp.buf.hover,
                opts = {},
            },
            {
                mode = "n",
                lhs = keymap.leader("r"),
                rhs = vim.lsp.buf.references,
                opts = {},
            },
        }

        keymap.map_table(keys, { buffer = bufnr, remap = false })
    end)
end

return M
