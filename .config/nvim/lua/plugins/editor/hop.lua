return {
	"smoka7/hop.nvim",
	version = "*",
	config = function()
		local hop = require("hop")
		local directions = require("hop.hint").HintDirection
		local opts = { remap = true }

		hop.setup({ keys = "etovxqpdygfblzhckisuran" })

		vim.keymap.set("", "f", function()
			hop.hint_char1({
				direction = directions.AFTER_CURSOR,
				current_line_only = false,
			})
		end, opts)

		vim.keymap.set("", "F", function()
			hop.hint_char1({
				direction = directions.BEFORE_CURSOR,
				current_line_only = false,
			})
		end, opts)

		vim.keymap.set("", "t", function()
			hop.hint_char1({
				direction = directions.AFTER_CURSOR,
				current_line_only = false,
				hint_offset = -1,
			})
		end, opts)

		vim.keymap.set("", "T", function()
			hop.hint_char1({
				direction = directions.BEFORE_CURSOR,
				current_line_only = false,
				hint_offset = -1,
			})
		end, opts)
	end,
}
