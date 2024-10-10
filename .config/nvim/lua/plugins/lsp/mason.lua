local M = {}

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

M.setup = function()
    mason.setup()
    mason_lspconfig.setup({
        automatic_installation = true,
        ensure_installed = { "lua_ls", "gopls", "rust_analyzer" },
    })
end

return M
