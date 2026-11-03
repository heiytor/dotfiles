-- Environment, input and ecosystem
-- See https://wiki.hypr.land/configuring/core/environment-variables/

-- Force apps to use Wayland
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("HYPRCURSOR_SIZE", "24")

-- Keyboard layout saved by de-keyboard-layout-set, so it survives config reloads
local function saved_keyboard_layout()
    local file = io.open(os.getenv("HOME") .. "/.de-config/session/keyboard_layout", "r")
    if not file then
        return nil
    end

    local layout = file:read("l")
    file:close()

    if layout == "us" or layout == "br" then
        return layout
    end

    return nil
end

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },

    ecosystem = {
        no_update_news = true,
    },

    input = {
        kb_layout = saved_keyboard_layout() or "us,br",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },

    cursor = {
        enable_hyprcursor = true,
    },
})
