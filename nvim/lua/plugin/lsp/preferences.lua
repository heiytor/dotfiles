local lsp = require("lsp-zero")

local config = require("config")

lsp.ensure_installed(config.lsp_servers)
lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = config.ui.signs.error,
		warn = config.ui.signs.warn,
		hint = config.ui.signs.hint,
		info = config.ui.signs.info,
	},
})
