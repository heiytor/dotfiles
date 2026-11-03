-- split-monitor-workspaces (Lua package, replaces the C++ plugin since Hyprland 0.57)
-- https://github.com/zjeffer/split-monitor-workspaces
--
-- The package is cloned by de-sync (see ~/.de-config/hypr-plugins) into
-- ~/.local/share/hypr/lua/split-monitor-workspaces. It uses dotted module names
-- internally, so it has to be found through package.path instead of a "~/" require.
--
-- Returns an object with workspace(n), move_to_workspace(n) and remap(). When the package
-- is missing it falls back to native per-index workspaces, so the binds keep working.

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
        remap = function() end,
    }
end

local monitors = require("monitors")

smw.setup({
    -- Samsung gets 1-9 when connected, the laptop the next range (1-9 when alone)
    monitor_priority             = { "desc:" .. monitors.primary, "desc:" .. monitors.laptop },
    workspace_count              = 9,
    keep_focused                 = true,
    enable_notifications         = false,
    enable_persistent_workspaces = true,
})

-- The package only maps the monitor that was just added, so a hot-plugged primary
-- would share 1-9 with the laptop. This repeats what the package does on config
-- reload: drop auto priorities, reload configured ones and remap every monitor.
local internals_ok, globals = pcall(require, "split-monitor-workspaces.lua.globals")
local _, helpers = pcall(require, "split-monitor-workspaces.lua.helpers")
local _, mapping = pcall(require, "split-monitor-workspaces.lua.monitors")

local api = {
    workspace         = smw.workspace,
    move_to_workspace = smw.move_to_workspace,
}

function api.remap()
    if not internals_ok or type(helpers) ~= "table" or type(mapping) ~= "table" then
        print("[config] split-monitor-workspaces internals changed, skipping remap")
        return
    end

    for name, priority in pairs(globals.monitor_priorities) do
        if not priority.from_config then
            globals.monitor_priorities[name] = nil
        end
    end

    helpers.load_config_for_all_monitors()
    mapping.remap_all_monitors()
end

return api
