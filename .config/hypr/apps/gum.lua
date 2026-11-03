hl.window_rule({
    name  = "gum-notification-menu",
    match = { class = "^(gum-notification-menu)$" },

    float = true,
    size  = { 400, 300 },
    move  = "monitor_w-410 40",
})

hl.window_rule({
    name  = "gum-webapp-menu",
    match = { class = "^(gum-webapp-menu)$" },

    float  = true,
    size   = { 700, 500 },
    center = true,
})
