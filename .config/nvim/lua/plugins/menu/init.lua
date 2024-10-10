local keymap = require("utils/keymap")

local menu = {
    {
        name = "Format Buffer",
        cmd = function()
            require("conform").format({ lsp_fallback = true })
        end,
        rtxt = keymap.leader("fm"),
    },
    { name = "separator" },
    {
        name = " Lsp",
        hl = "Exblue",
        items = require("plugins.menu.items.lsp").menu,
    },
    {
        name = " Git",
        hl = "Exblue",
        items = require("plugins.menu.items.git").menu,
    },
    { name = "separator" },
    {
        name = "Edit Config",
        hl = "ExRed",
        cmd = function()
            vim.cmd("tcd " .. vim.fn.stdpath("config") .. " | e init.lua")
        end,
        rtxt = "ed",
    },
}

keymap.map_table({
    {
        mode = "n",
        lhs = keymap.ctrl("t"),
        rhs = function()
            require("menu").open(menu, { mouse = false, border = true })
        end,
        opts = {
            desc = "Open menu",
        },
    },
    {
        mode = "n",
        lhs = "<RightMouse>",
        rhs = function()
            vim.cmd.exec '"normal! \\<RightMouse>"'
            require("menu").open(menu, { mouse = true, border = true })
        end,
        opts = {
            desc = "Open menu",
        },
    }
})
