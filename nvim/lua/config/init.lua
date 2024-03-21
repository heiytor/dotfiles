require("config.on_start")

local keybindings = require("config.keybindings")
local keymap = require("utils.keymap")

keymap.set_leader(" ")

keymap.setN(keybindings.nop, {})
keymap.setN(keybindings.normal_mode, {})
keymap.setN(keybindings.visual_mode, {})

return require("config.config")
