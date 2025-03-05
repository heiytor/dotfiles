vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	pattern = { "*:*" },
	callback = function()
		if not Inlay_hints_status then
			return
		end

		for _, ft in ipairs(Inlay_hints_filetypes) do
			if vim.bo.filetype == ft then
				vim.lsp.inlay_hint.enable(vim.fn.mode() == Inlay_hints_mode)
				return
			end
		end
	end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = vim.api.nvim_create_augroup("HighlightYank", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 95 })
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("lazyvim_autoupdate", { clear = true }),
	callback = function()
		require("lazy").update({
			show = false,
		})
	end,
})
