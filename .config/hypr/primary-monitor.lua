-- Primary monitor handling for the KVM switch (see monitors.lua)
--
-- When the Samsung connects (startup or KVM switch) it takes focus and the cursor.
-- The delay lets Hyprland and split-monitor-workspaces map its workspaces first.

local monitors = require("monitors")

local function focus_primary_soon()
    hl.timer(monitors.focus_primary, { timeout = 300, type = "oneshot" })
end

hl.on("hyprland.start", focus_primary_soon)

hl.on("monitor.added", function(monitor)
    if monitors.is_primary(monitor) then
        focus_primary_soon()
    end
end)
