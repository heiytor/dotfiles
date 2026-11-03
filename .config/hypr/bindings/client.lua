local layout = hl.dsp.layout
local smw = require("plugins.split-monitor-workspaces")

hl.bind("SUPER + C",         hl.dsp.window.close(),                            { description = "Kill active client" })
hl.bind("SUPER + H",         layout("cycleprev"),                              { description = "Focus previous client" })
hl.bind("SUPER + SHIFT + H", layout("mfact -0.05"),                            { description = "Decrease master size" })
hl.bind("SUPER + L",         layout("cyclenext"),                              { description = "Focus next client" })
hl.bind("SUPER + SHIFT + L", layout("mfact +0.05"),                            { description = "Increase master size" })
hl.bind("SUPER + V",         hl.dsp.exec_cmd("de-layout-orientation-cycle"),   { description = "Cycle orientation" })
hl.bind("SUPER + N",         layout("swapwithmaster"),                         { description = "Swap with master" })
hl.bind("SUPER + J",         layout("addmaster"),                              { description = "Add master" })
hl.bind("SUPER + K",         layout("removemaster"),                           { description = "Remove master" })
hl.bind("SUPER + M",         hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Toggle maximize" })
hl.bind("SUPER + F",         hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Toggle fullscreen" })

-- Moves the window to the active workspace of the next monitor, like split-changemonitor did
hl.bind("SUPER + ALT + X", hl.dsp.window.move({ monitor = "+1" }), { description = "Move active client to next monitor" })

for i = 1, 9 do
    local n = tostring(i)
    hl.bind("SUPER + SHIFT + " .. n, smw.move_to_workspace(n), { description = "Move active client to workspace " .. n })
end

hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "special:special" }), { description = "Move active client to scratchpad" })

hl.bind("SHIFT + mouse:276", hl.dsp.window.drag(),   { mouse = true, description = "Move window" })
hl.bind("SHIFT + mouse:275", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })
