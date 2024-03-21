local M = {}

M.clangd = require("plugin.lsp.servers.clangd")
M.gopls = require("plugin.lsp.servers.gopls")
M.lua_ls = require("plugin.lsp.servers.lua_ls")
M.rust_analyzer = require("plugin.lsp.servers.rust_analyzer")

return M
