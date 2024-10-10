local keymap = require('utils/keymap')
local builtin = require("telescope.builtin")

keys = {
    {
        mode = "n",
        lhs = ";s",
        rhs = function()
            builtin.live_grep({
                respect_gitignore = false,
            })
        end,
        opts = {
            desc = "[Telescope] Live Grep.",
        },
    },
    {
        mode = "n",
        lhs = ";f",
        rhs = function()
            builtin.find_files({
                respect_gitignore = false,
                no_ignore = false,
                hidden = true,
            })
        end,
        opts = {
            desc = "[Telescope] Find files.",
        },
    },
    {
        mode = "n",
        lhs = ";r",
        rhs = function()
            builtin.treesitter()
        end,
        opts = {
            desc = "[Telescope] Find symbols.",
        },
    },
}

keymap.map_table(keys, {})
