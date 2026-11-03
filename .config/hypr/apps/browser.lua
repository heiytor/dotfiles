hl.window_rule({
    name  = "tag-chromium-based-browser",
    match = { class = "(google-)?[cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable|helium" },

    tag = "+chromium-based-browser",
})

hl.window_rule({
    name  = "tile-chromium-based-browser",
    match = { tag = "chromium-based-browser" },

    tile = true,
})
