hl.window_rule({
    name  = "bitwarden",
    match = { class = "^(Bitwarden)$" },

    float           = true,
    center          = true,
    size            = "monitor_w*0.6 monitor_h*0.7",
    no_screen_share = true,
})
