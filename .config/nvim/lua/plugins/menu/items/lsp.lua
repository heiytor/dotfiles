local M = {}

M.menu = {
    {
        name = "Goto Definition",
        cmd = vim.lsp.buf.definition,
        rtxt = "gd",
    },
    {
        name = "Goto Declaration",
        cmd = vim.lsp.buf.declaration,
        rtxt = "gD",
    },
    {
        name = "Goto Implementation",
        cmd = vim.lsp.buf.implementation,
        rtxt = "gi",
    },
    { name = "separator" },
    {
        name = "Show signature help",
        cmd = vim.lsp.buf.signature_help,
        rtxt = "<leader>sh",
    },
    {
        name = "Add workspace folder",
        cmd = vim.lsp.buf.add_workspace_folder,
        rtxt = "<leader>wa",
    },
    {
        name = "Remove workspace folder",
        cmd = vim.lsp.buf.remove_workspace_folder,
        rtxt = "<leader>wr",
    },
    {
        name = "Show References",
        cmd = vim.lsp.buf.references,
        rtxt = "gr",
    },
    { name = "separator" },
    {
        name = "Code Actions",
        cmd = vim.lsp.buf.code_action,
        rtxt = "<leader>ca",
    },
}

return M
