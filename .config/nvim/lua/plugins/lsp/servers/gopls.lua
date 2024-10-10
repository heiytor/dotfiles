local M = {}

M.settings = {
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

return M
