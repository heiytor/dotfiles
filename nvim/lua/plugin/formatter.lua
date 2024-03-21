local default = require("formatter.filetypes")

require("formatter").setup({
	filetype = {
		-- c = default.c.clangformat,
		-- cpp = default.cpp.clangformat,
		lua = default.lua.stylua,
		go = default.go.gofumpt,
	},
})

-- Format on save
vim.api.nvim_exec(
	[[
      augroup FormatAutogroup
        autocmd!
        autocmd BufWritePost * FormatWriteLock
      augroup END
    ]],
	false
)
