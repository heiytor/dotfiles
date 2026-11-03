-- Global window and workspace rules
-- See https://wiki.hypr.land/configuring/core/rules/

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Ignore borders and gaps when a window is maximized
hl.workspace_rule({ workspace = "f[0]s[false]", no_rounding = true, border_size = 0, gaps_out = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", no_rounding = true, border_size = 0, gaps_out = 0 })
