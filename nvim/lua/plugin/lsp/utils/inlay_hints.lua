local M = {}

-- Automatically enable inlay hints when entering Insert mode, and disable them upon leaving.
-- Can be disabled with "<leader>nn" at Normal mode.
M.on_insert_mode = function()
	local valid_filetypes = { "go", "rust", "lua" }
	local use_inlay_hints = true

	vim.api.nvim_create_autocmd({ "InsertEnter" }, {
		callback = function()
			if not use_inlay_hints then
				return
			end

			for _, ft in ipairs(valid_filetypes) do
				if vim.bo.filetype == ft then
					vim.lsp.inlay_hint.enable(0, true)
					return
				end
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		callback = function()
			if not use_inlay_hints then
				return
			end

			vim.lsp.inlay_hint.enable(0, false)
		end,
	})

	-- It can be disabled with the keymap below:
	vim.keymap.set("n", "<Leader>nn", function()
		use_inlay_hints = not use_inlay_hints
	end, { desc = "Toggle automatically inlay [h]ints" })
end

-- Toggle inlay hints in all modes.
M.on_keypress = function()
	vim.keymap.set("n", "<Leader>nn", function()
		vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
	end, { desc = "Toggle inlay [h]ints" })
end

return M
