return {
	"laytan/cloak.nvim",
	config = function()
		require("cloak").setup({
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			patterns = {
				{
					cloak_pattern = "=.+",
					file_pattern = { ".env*", "*.env" },
				},
			},
		})
	end,
}
