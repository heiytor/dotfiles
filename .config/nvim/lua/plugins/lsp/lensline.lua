return {
    'oribarilan/lensline.nvim',
    tag = '1.0.0',
    event = 'LspAttach',
    config = function()
        -- require("lensline").setup({
        --     providers = {
        --         {
        --             name = "references",
        --             enabled = true,
        --             quiet_lsp = true,
        --         },
        --         {
        --             name = "last_author",
        --             enabled = true,
        --             cache_max_files = 50,
        --         },
        --         {
        --             name = "diagnostics",
        --             enabled = false,
        --             min_level = "WARN",
        --         },
        --         {
        --             name = "complexity",
        --             enabled = false,
        --             min_level = "L",
        --         },
        --     },
        -- })
    end,
}
