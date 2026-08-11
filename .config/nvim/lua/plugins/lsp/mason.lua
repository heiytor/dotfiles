local tools = { "stylua" }

return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		cmd = "Mason",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)

			local registry = require("mason-registry")

			for _, name in ipairs(tools) do
				local ok, pkg = pcall(registry.get_package, name)
				if ok and not pkg:is_installed() then
					pkg:install()
				end
			end
		end,
	},
}
