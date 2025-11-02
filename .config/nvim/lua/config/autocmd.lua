local transparent_groups = {
    "Normal",
    "NormalFloat",
    "FloatBorder",
    "Pmenu",
    "Terminal",
    "EndOfBuffer",
    "FoldColumn",
    "Folded",
    "SignColumn",
    "NormalNC",
    "WhichKeyFloat",
    "TelescopeBorder",
    "TelescopeNormal",
    "TelescopePromptBorder",
    "TelescopePromptTitle",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeVertSplit",
    "NeoTreeWinSeparator",
    "NeoTreeEndOfBuffer",
    "NvimTreeNormal",
    "NvimTreeVertSplit",
    "NvimTreeEndOfBuffer",
    "NotifyINFOBody",
    "NotifyERRORBody",
    "NotifyWARNBody",
    "NotifyTRACEBody",
    "NotifyDEBUGBody",
    "NotifyINFOTitle",
    "NotifyERRORTitle",
    "NotifyWARNTitle",
    "NotifyTRACETitle",
    "NotifyDEBUGTitle",
    "NotifyINFOBorder",
    "NotifyERRORBorder",
    "NotifyWARNBorder",
    "NotifyTRACEBorder",
    "NotifyDEBUGBorder",
}

local function apply_theme_from_file()
    local theme = dofile(vim.fn.expand("~/themes/current/nvim.lua"))
    if type(theme) ~= "string" or theme == "" then
        return false
    end

    vim.cmd.colorscheme(vim.trim(theme))
    for _, group in ipairs(transparent_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
    end

    return true
end

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    pattern = "*",
    callback = function(_)
        if not Inlay_hints_status then
            return
        end

        for _, ft in ipairs(Inlay_hints_filetypes) do
            if vim.bo.filetype == ft then
                vim.lsp.inlay_hint.enable(true)
                return
            end
        end
    end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = vim.api.nvim_create_augroup("HighlightYank", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 95 })
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("lazyvim_autoupdate", { clear = true }),
    callback = function()
        require("lazy").update({ show = false })
        apply_theme_from_file()
    end,
})

vim.api.nvim_create_autocmd("Signal", {
    pattern = "SIGUSR1",
    callback = function()
        applied = apply_theme_from_file()
        if applied then
            vim.notify("Theme reloaded", vim.log.levels.INFO)
        else
            vim.notify("Failed to read theme file", vim.log.levels.ERROR)
        end
    end,
})
