return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		local keys = require("utils.keys")

		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				debounce = 25,
				keymap = {
					accept = false,
					accept_word = false,
					accept_line = keys.ctrl("<Tab>"),
					next = false,
					prev = false,
					dismiss = false,
				},
			},
			filetypes = {
				go = true,
				ruby = true,
				lua = true,
				["*"] = false,
			},
		})
	end,
}
