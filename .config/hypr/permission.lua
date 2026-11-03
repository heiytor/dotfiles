-- Permissions
-- See https://wiki.hypr.land/configuring/core/advanced-configuration/permissions/
--
-- Anything not listed falls back to Hyprland's defaults: screencopy, plugin, cursorpos
-- and input-capture ask through a popup (needs hyprland-guiutils), keyboards are allowed.
-- Changes here are NOT applied on reload: they need a Hyprland restart.

hl.config({
    ecosystem = {
        enforce_permissions = true,
    },
})

-- Screen sharing (browser, Discord) goes through the portal
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })

-- Screenshots (de-printscr): grim captures, wayfreeze freezes the screen during area selection
hl.permission({ binary = "/usr/bin/grim",      type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/wayfreeze", type = "screencopy", mode = "allow" })

-- Lock screen uses a screenshot as its background (hyprlock.conf: path = screenshot)
hl.permission({ binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" })

-- Plugins loaded at startup by hyprpm reload (autostart.lua)
hl.permission({ binary = "/usr/bin/hyprpm", type = "plugin", mode = "allow" })
