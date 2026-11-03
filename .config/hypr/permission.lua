-- Permissions
-- See https://wiki.hypr.land/configuring/core/advanced-configuration/permissions/
--
-- NOT LOADED: hyprland.lua does not require this file, matching the old setup
-- where permission.conf was never sourced. Enabling it makes Hyprland prompt
-- for screen capture (grim) and plugin loading (hyprpm), so allow them first.
-- Changes here need a Hyprland restart.

hl.config({
    ecosystem = {
        enforce_permissions = true,
    },
})

hl.permission({
    binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland",
    type   = "screencopy",
    mode   = "allow",
})
