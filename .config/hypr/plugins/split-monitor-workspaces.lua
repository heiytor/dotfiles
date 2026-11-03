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
    workspace_count              = 9,
    keep_focused                 = true,
    enable_notifications         = false,
    enable_persistent_workspaces = true,
})

return smw
