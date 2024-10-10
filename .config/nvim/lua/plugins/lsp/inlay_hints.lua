local M = {}

local keymap = require("utils/keymap")

local valid_filetypes = { "go", "rust", "typescript", "typescriptreact" }
local use_inlay_hints = true

M.setup = function()
    vim.api.nvim_create_autocmd({ "InsertEnter" }, {
        callback = function()
            if not use_inlay_hints then
                return
            end

            for _, ft in ipairs(valid_filetypes) do
                if vim.bo.filetype == ft then
                    vim.lsp.inlay_hint.enable(true)
                    return
                end
            end
        end,
    })

    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        callback = function()
            if not use_inlay_hints then
                return
            end

            vim.lsp.inlay_hint.enable(false)
        end,
    })

    keymap.map({
        mode = "n",
        lhs = keymap.leader("nn"),
        rhs = function()
            use_inlay_hints = not use_inlay_hints
        end,
        opts = {
            desc = "Toggle inlay hints",
        },
    })
end

return M
