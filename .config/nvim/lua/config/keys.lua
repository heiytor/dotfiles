local keys = require("utils.keys")

vim.keymap.set("n", keys.leader("e"), vim.cmd.Ex)

vim.cmd([[command W write]])

-- vim.keymap.set("n", "J", "<nop>")
vim.keymap.set("n", "K", "<nop>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", ";p", "<nop>")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set(
    "n",
    keys.leader("s"),
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Rename all [current word] occurrences in the current buffer" }
)
vim.keymap.set(
    "n",
    keys.leader("d"),
    [[:%s///gI<Left><Left><Left><Left>]],
    { desc = "Rename all occurrences in the current buffer" }
)

vim.keymap.set("n", keys.toggle("c"), function()
    vim.o.colorcolumn = (vim.o.colorcolumn ~= "0") and "0" or "80"
end, { desc = "Toggle color column [80] view." })

vim.keymap.set("n", keys.toggle("l"), function()
    vim.o.number = not vim.o.number
end, { desc = "Toggle line number view." })

vim.keymap.set("v", "K", ":m '>-2<cr>gv=gv", { desc = "Move selected lines to top" })
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selected lines to bottom" })
vim.keymap.set("v", keys.leader("y"), [["+y]], { desc = "Copy to clipboard." })

vim.keymap.set("x", "p", [["_dP]], { desc = "As theprimeagen said, greatest remap ever" })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("CustomLsp", {}),
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "R", vim.lsp.buf.references, opts)

        vim.keymap.set("n", keys.toggle("i"), function()
            Inlay_hints_status = not Inlay_hints_status
            vim.lsp.inlay_hint.enable(Inlay_hints_status)
        end, opts)
    end,
})
