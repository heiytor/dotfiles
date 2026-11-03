-- Hyprland 0.57+ Lua config
-- See https://wiki.hypr.land/configuring/
-- Modules are resolved relative to this directory (require("bindings") -> bindings/init.lua).

require("monitors")
require("env")
require("layout")
require("looknfeel")
require("rules")
require("apps")
require("plugins")
require("bindings")
require("autostart")
-- require("permission") -- disabled, see permission.lua

-- Theme colors, switched by de-theme-set (symlink + hyprctl reload)
require("~/.de-config/themes/current/hypr")
