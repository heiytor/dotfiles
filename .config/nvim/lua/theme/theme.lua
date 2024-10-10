local M = {}

---Disable the background color
M.disable_background = function ()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

---Loads the current theme if defined.
M.load_current = function ()
    -- The current theme is expected to be a file called "current.lua". The file
    -- will be evaluated if exists.
    local current_theme = os.getenv("HOME") .. "/.config/nvim/lua/theme/current.lua"
    if vim.loop.fs_stat(current_theme) then
        dofile(current_theme)
    end
end

return M
