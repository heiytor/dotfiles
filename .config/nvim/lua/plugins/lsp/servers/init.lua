local M = {}

local lspconfig = require("lspconfig")

M.setup = function()
    lspconfig.gopls.setup(require("plugins.lsp.servers.gopls").settings)
    lspconfig.lua_ls.setup(require("plugins.lsp.servers.luals").settings)
    lspconfig.rust_analyzer.setup(require("plugins.lsp.servers.rust_analyzer").settings)
    lspconfig.ts_ls.setup(require("plugins.lsp.servers.tsls").settings)
end

return M
