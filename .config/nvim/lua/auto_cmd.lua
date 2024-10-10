-- For Git commits, the 73rd column is marked as the colorcolumn,
-- representing the maximum limit for writing.
vim.cmd[[
  autocmd FileType gitcommit setlocal colorcolumn=73
]]
