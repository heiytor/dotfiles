-- Monitors
-- See https://wiki.hypr.land/configuring/core/monitors/
--
-- The Samsung is the primary monitor whenever it is connected (it comes and goes
-- with the KVM switch): it gets workspaces 1-9, is "monitor 1" for SUPER + ALT + 1,
-- and takes focus and the cursor when it shows up.

local M = {}

M.primary = "Samsung Electric Company Odyssey G30B HX5X501356"
M.laptop  = "AU Optronics B153UAN03.0"

hl.monitor({
    output   = "desc:" .. M.primary,
    mode     = "1920x1080@144",
    position = "0x1080",
    scale    = 1,
})

hl.monitor({
    output   = "desc:" .. M.laptop,
    mode     = "preferred",
    position = "0x0",
    scale    = 1.5,
})

-- Fallback for any other monitor
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

function M.is_primary(monitor)
    return monitor ~= nil and monitor.description ~= nil and monitor.description:find(M.primary, 1, true) == 1
end

-- Connected monitors, primary first, then the rest in Hyprland's order
function M.ordered()
    local ordered = {}

    for _, monitor in ipairs(hl.get_monitors()) do
        if M.is_primary(monitor) then
            table.insert(ordered, 1, monitor)
        else
            table.insert(ordered, monitor)
        end
    end

    return ordered
end

-- Dispatcher-like function that focuses the nth monitor of M.ordered()
function M.focus_nth(n)
    return function()
        local monitor = M.ordered()[n]

        if monitor then
            hl.dispatch(hl.dsp.focus({ monitor = monitor.name }))
        end
    end
end

function M.focus_primary()
    for _, monitor in ipairs(hl.get_monitors()) do
        if M.is_primary(monitor) then
            hl.dispatch(hl.dsp.focus({ monitor = monitor.name }))
            return
        end
    end
end

hl.config({
    cursor = {
        -- Move the cursor to the monitor of the workspace being switched to
        warp_on_change_workspace = 1,
    },
})

return M
