hl.window_rule({
    name  = "floating-window",
    match = { tag = "floating-window" },

    float  = true,
    center = true,
    size   = { 800, 600 },
})

hl.window_rule({
    name  = "tag-floating-apps",
    match = { class = "blueberry.py|Impala|Wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Omarchy|About|TUI.float" },

    tag = "+floating-window",
})

hl.window_rule({
    name  = "tag-file-dialogs",
    match = {
        class = "xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus",
        title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)",
    },

    tag = "+floating-window",
})

hl.window_rule({
    name  = "calculator",
    match = { class = "org.gnome.Calculator" },

    float = true,
})

hl.window_rule({
    name  = "screensaver",
    match = { class = "Screensaver" },

    fullscreen = true,
})

hl.window_rule({
    name  = "media-full-opacity",
    match = { class = "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$" },

    opacity = "1 1",
})
