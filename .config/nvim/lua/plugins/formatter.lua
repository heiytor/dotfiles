local filetype = require("formatter.filetypes")

require("formatter").setup({
	filetype = {
		go = filetype.go.gofmt,
		-- lua = filetype.lua.stylua,
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
