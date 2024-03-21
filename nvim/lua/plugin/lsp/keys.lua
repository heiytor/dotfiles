---Defines key mappings for LSP and diagnostic actions.
---Each entry in the table represents a key mapping with the associated mode, key sequence (lhs),
---corresponding callback (rhs), and any additional options (opts).
---
---The format of each entry is as follows:
---```
---{
---  mode = "n",                -- Mode in which the key mapping is active (e.g., "n" for normal mode).
---  lhs = "<F2>",              -- Key sequence triggering the action.
---  rhs = vim.lsp.buf.rename,  -- LSP function associated with the key mapping.
---  opts = {},                 -- Additional options for the key mapping.
---}
---```
return {
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
		lhs = "<leader>ref",
		rhs = vim.lsp.buf.references,
		opts = {},
	},
	{
		mode = "n",
		lhs = "<leader>ws",
		rhs = vim.lsp.buf.workspace_symbol,
		opts = {},
	},
	{
		mode = "n",
		lhs = "[d",
		rhs = vim.diagnostic.goto_next,
		opts = {},
	},
	{
		mode = "n",
		lhs = "]d",
		rhs = vim.diagnostic.goto_prev,
		opts = {},
	},
}
