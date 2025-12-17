return {
	"oribarilan/lensline.nvim",
	tag = "2.0.0",
	event = "LspAttach",
	config = function()
		require("lensline").setup({
			profiles = {
				{
					name = "default",
					style = { placement = "above" },
					providers = {
						{
							name = "last_author",
							enabled = true,
						},
						{
							name = "usages",
							enabled = false,
							include = { "refs", "deps", "impls" },
							breakdown = true,
							show_zero = true,
						},
						{
							name = "diagnostics",
							enabled = true,
							min_level = "INFO",
						},
					},
				},
			},
		})
	end,
}
