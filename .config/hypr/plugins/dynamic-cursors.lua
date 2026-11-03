-- hypr-dynamic-cursors (hyprpm plugin)
-- https://github.com/VirtCode/hypr-dynamic-cursors
--
-- Only applied once the plugin is loaded: hyprpm reload triggers a config reload,
-- and this guard skips the block on the first pass.

if not hl.plugin.dynamic_cursors then
    return
end

hl.config({
    plugin = {
        dynamic_cursors = {
            enabled = true,
            mode    = "stretch",

            stretch = {
                limit      = 3000,
                activation = "quadratic",
                window     = 100,
            },

            shake = {
                enabled   = true,
                threshold = 4.0,
            },

            hyprcursor = {
                enabled    = true,
                nearest    = 1, -- pixelated only when there is no high-res image
                resolution = -1,
                fallback   = "clientside",
            },
        },
    },
})
