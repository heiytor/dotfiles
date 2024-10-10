require("gitsigns").setup({
    on_attach = function(bufnr)
        local keymap = require('utils/keymap')
        local gs = require('gitsigns')

        local keys = {
            {
                mode = "n",
                lhs = keymap.toggle("g"),
                rhs = gs.toggle_current_line_blame,
                opts = {
                    desc = "[Gitsign] Toggle line blame.",
                },
            },
        }

        keymap.map_table(keys, { buffer = bufnr })
    end,
    current_line_blame           = true,
    current_line_blame_opts      = { delay = 50 },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})
