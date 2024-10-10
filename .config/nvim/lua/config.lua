vim.g.mapleader = " "

vim.opt.nu = false
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.colorcolumn = "0"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- Nix files only need 2 spaces
vim.cmd[[
  autocmd FileType nix setlocal tabstop=2 softtabstop=2 shiftwidth=2
]]

vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
