local smw = require("plugins.split-monitor-workspaces")

for i = 1, 9 do
    local n = tostring(i)
    hl.bind("SUPER + " .. n, smw.workspace(n), { description = "Switch to workspace " .. n })
end

hl.bind("SUPER + 0", hl.dsp.workspace.toggle_special("special"), { description = "Toggle scratchpad" })

hl.bind("SUPER + ALT + 1", hl.dsp.focus({ monitor = 0 }), { description = "Switch to monitor 1" })
hl.bind("SUPER + ALT + 2", hl.dsp.focus({ monitor = 1 }), { description = "Switch to monitor 2" })

-- hl.bind("SUPER + mouse_down", smw.cycle_workspaces("next"), { description = "Scroll to the next workspace" })
-- hl.bind("SUPER + mouse_up",   smw.cycle_workspaces("prev"), { description = "Scroll to the previous workspace" })
