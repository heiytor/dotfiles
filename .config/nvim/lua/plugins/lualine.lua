require("lualine").setup({
    options = {
        theme = "auto",
        ignore_focus = {
            "mason",
            "TelescopePrompt",
            "packer",
            "dashboard",
        },
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = {
            {
                "mode",
                fmt = function(mode)
                    return mode:sub(1, 3) -- show only three chars
                end,
            },
        },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
            {
                "filename",
                path = 1, -- relative path
            },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
