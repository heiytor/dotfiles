require("plugin.lsp.preferences")

local lsp = require("lsp-zero").preset({})
local lspconfig = require("lspconfig")

local config = require("config")
local keymap = require("utils.keymap")
local keys = require("plugin.lsp.keys")
local utils = require("plugin.lsp.utils")

lsp.on_attach(function(_, bufnr)
	keymap.setN(keys, { buffer = bufnr, remap = false })
end)

-- Configure lsp servers
local servers = require("plugin.lsp.servers")
for _, srv in ipairs(config.lsp_servers) do
	lspconfig[srv].setup({
		settings = servers[srv].settings,
	})
end

-- Enable utils
utils.cmp.setup()
utils.inlay_hints.on_insert_mode()

lsp.setup()
lsp.nvim_workspace() -- fix Undefined global 'vim'
