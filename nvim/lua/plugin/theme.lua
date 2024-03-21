vim.cmd("colorscheme photon")

-- Disable the background color when theme do not feature this.
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
