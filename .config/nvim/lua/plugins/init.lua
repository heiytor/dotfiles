return {
    -- { import = "plugins.ai" },
    { import = "plugins.editor" },
    { import = "plugins.git" },
    { import = "plugins.lsp" },
    {
        "folke/snacks.nvim",
        opts = {
            scroll = {
                enabled = false
            },
        },
    },
}
