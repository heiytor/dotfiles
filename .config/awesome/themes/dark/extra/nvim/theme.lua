local conf = {
    terminal_colors = true,
    styles = {
        comments    = { italic = true },
        keywords    = { },
        identifiers = { },
        functions   = { },
        variables   = { },
        booleans    = { },
    },
    integrations = {
        alpha              = true,
        cmp                = true,
        gitsigns           = true,
        lsp                = true,
        indent_blankline   = true,
        mason              = true,
        rainbow_delimiters = true,
        telescope          = true,
        treesitter         = true,
        hop                = true,
        flash              = false,
        lazy               = false,
        markdown           = false,
        navic              = false,
        neo_tree           = false,
        neorg              = false,
        noice              = false,
        notify             = false,
    },
    highlight_overrides = {}
}

require("oldworld").setup(conf)
vim.cmd.colorscheme("oldworld")
