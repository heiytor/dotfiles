local function default_capabilities()
	return vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities()
	)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "ruby",
	callback = function(ctx)
		local root = vim.fs.root(ctx.buf, { "Gemfile", ".git" })
		local cmd, args

		if not root then
			cmd, args = "ruby-lsp", {}
		elseif vim.fn.executable(root .. "/bin/ruby-lsp") == 1 then
			cmd, args = root .. "/bin/ruby-lsp", {}
		elseif vim.fn.executable(root .. "/bin/bundle") == 1 then
			cmd, args = root .. "/bin/bundle", { "exec", "ruby-lsp" }
		else
			cmd, args = "bundle", { "exec", "ruby-lsp" }
		end

		vim.lsp.start({
			name = "ruby_lsp",
			root_dir = root,
			cmd = { cmd, unpack(args) },
			capabilities = default_capabilities(),
			init_options = {
				formatter = "none",
				linters = { "rubocop" },
				addonSettings = {
					["Ruby LSP Rails"] = {
						enablePendingMigrationsPrompt = false,
					},
				},
			},
		})
	end,
})

return {}
