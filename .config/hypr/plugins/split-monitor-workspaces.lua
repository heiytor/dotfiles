-- split-monitor-workspaces (Lua package, replaces the C++ plugin since Hyprland 0.57)
-- https://github.com/zjeffer/split-monitor-workspaces
--
-- The package is cloned by de-sync (see ~/.de-config/hypr-plugins) into
-- ~/.local/share/hypr/lua/split-monitor-workspaces. It uses dotted module names
-- internally, so it has to be found through package.path instead of a "~/" require.
--
-- Returns an object with workspace(n) and move_to_workspace(n). When the package is
-- missing it falls back to native per-index workspaces, so the binds keep working.

local root = os.getenv("HOME") .. "/.local/share/hypr/lua"
local search = root .. "/?.lua;" .. root .. "/?/init.lua;"

if not package.path:find(search, 1, true) then
    package.path = search .. package.path
end

local ok, smw = pcall(require, "split-monitor-workspaces")

if not ok or type(smw) ~= "table" then
    print("[config] split-monitor-workspaces not available, using native workspaces: " .. tostring(smw))

    return {
        workspace = function(n)
            return hl.dsp.focus({ workspace = n })
        end,
        move_to_workspace = function(n)
            return hl.dsp.window.move({ workspace = n })
        end,
    }
end

smw.setup({
    -- The laptop panel is always there, so it keeps 1-9 and every other monitor is
    -- appended after it (the Samsung gets 10-18). Ranges never change on hotplug, so
    -- workspaces and their windows stay on their monitor across KVM switches.
    -- Changing priorities at runtime would move workspaces, windows included.
    monitor_priority             = { "eDP-1" },
    workspace_count              = 9,
    keep_focused                 = true,
    enable_notifications         = false,
    enable_persistent_workspaces = true,
})

return smw
