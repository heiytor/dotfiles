-- Primary monitor handling for the KVM switch (see monitors.lua)
--
-- When the Samsung connects (startup or KVM switch), workspaces are remapped so it
-- owns 1-9, then it takes focus and the cursor. When it disconnects, the laptop gets
-- 1-9 back. The delay lets Hyprland and split-monitor-workspaces finish their own
-- monitor handling first.

local monitors = require("monitors")
local smw = require("plugins.split-monitor-workspaces")

local function soon(fn)
    hl.timer(fn, { timeout = 300, type = "oneshot" })
end

local function settle_on_primary()
    smw.remap()
    monitors.focus_primary()
end

hl.on("hyprland.start", function()
    soon(settle_on_primary)
end)

hl.on("monitor.added", function(monitor)
    if monitors.is_primary(monitor) then
        soon(settle_on_primary)
    end
end)

hl.on("monitor.removed", function(monitor)
    if monitors.is_primary(monitor) then
        soon(smw.remap)
    end
end)
