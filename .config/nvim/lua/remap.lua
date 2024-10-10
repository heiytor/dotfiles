local keymap = require('utils/keymap')
local keys = {}

keys.nop = {
    { mode = "n", lhs = "J",  rhs = "<nop>", opts = {} },
    { mode = "n", lhs = "K",  rhs = "<nop>", opts = {} },
    { mode = "n", lhs = "Q",  rhs = "<nop>", opts = {} },
    { mode = "n", lhs = ";p", rhs = "<nop>", opts = {} },
}

keys.std = {
    {
        mode = "n",
        lhs = keymap.leader("e"),
        rhs = vim.cmd.Ex,
        opts = {
            desc = "Enter file explorer.",
        },
    },
    {
        mode = "n",
        lhs = "n",
        rhs = "nzzzv",
        opts = {
            desc = "Keep cursor in the middle when searching",
        },
    },
    {
        mode = "n",
        lhs = "N",
        rhs = "Nzzzv",
        opts = {
            desc = "Keep cursor in the middle when searching",
        },
    },
    {
        mode = "n",
        lhs = keymap.leader("s"),
        rhs = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        opts = {
            desc = "Rename all [current word] occurrences in the current buffer",
        },
    },
    {
        mode = "n",
        lhs = keymap.leader("d"),
        rhs = [[:%s///gI<Left><Left><Left><Left>]],
        opts = {
            desc = "Rename all occurrences in the current buffer",
        },
    },
    {
        mode = "n",
        lhs = keymap.toggle("l"),
        rhs = function()
            vim.o.number = not vim.o.number
        end,
        opts = {
            desc = "Toggle line number view.",
        },
    },
    {
        mode = "n",
        lhs = keymap.toggle("c"),
        rhs = function()
            vim.o.colorcolumn = (vim.o.colorcolumn ~= "0") and "0" or "80"
        end,
        opts = {
            desc = "Toggle color column [80] view.",
        },
    },
    {
        mode = "v",
        lhs = "K",
        rhs = ":m '>-2<cr>gv=gv",
        opts = {
            desc = "Move selected lines to top",
        },
    },
    {
        mode = "v",
        lhs = "J",
        rhs = ":m '>+1<cr>gv=gv",
        opts = {
            desc = "Move selected lines to bottom",
        },
    },
    {
        mode = "v",
        lhs = keymap.leader("y"),
        rhs = [["+y]],
        opts = {
            desc = "Copy to clipboard.",
        },
    },
    {
        mode = "x",
        lhs = "p",
        rhs = [["_dP]],
        opts = {
            desc = "As theprimeagen said, greatest remap ever",
        },
    },
}

keymap.map_table(keys.nop, {})
keymap.map_table(keys.std, {})
