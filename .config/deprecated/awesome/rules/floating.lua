---Client that must start in floating mode
local M = {}

M.rule = {
    id       = "floating",
    rule_any = {
        instance = { "copyq", "pinentry" },
        class    = {
            "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
            "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
        },
        name    = {
            "Event Tester",  -- xev.
        },
        role    = {
            "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
    properties = { floating = true }
}

return M
