-- See:
-- > https://github.com/golang/tools/tree/master/gopls/doc
local opts = {
	settings = {
		gopls = {
			gofumpt = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = false,
				constantValues = true,
				parameterNames = true,
				functionTypeParameters = false,
				rangeVariableTypes = false,
			},
		},
	},
}

return opts
