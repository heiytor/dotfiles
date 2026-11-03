-- Autostart
-- See https://wiki.hypr.land/configuring/core/autostart/
-- The keyboard layout is restored by env.lua, so it no longer needs a startup command.

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user enable --now hyprpolkitagent.service")
    hl.exec_cmd("uwsm app -- wl-paste --watch cliphist store")
    hl.exec_cmd("uwsm app -- waybar")
    hl.exec_cmd("uwsm app -- mako")
    hl.exec_cmd("uwsm app -- swayosd-server")
    hl.exec_cmd("uwsm app -- hypridle")
    hl.exec_cmd("uwsm app -- swaybg -i ~/.de-config/themes/current/wallpaper -m fill")
    hl.exec_cmd("uwsm app -- vesktop")
    hl.exec_cmd("~/.config/hypr/scripts/start-walker")
end)
