local gears = require("gears")
local beautiful = require("beautiful")

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

beautiful.useless_gap = 4
beautiful.gap_single_client = true

-- No borders when rearrangting or maximized client
-- screen.connect_signal("arrange", function (s)
--   local only_one = #s.tiled_clients == 1
--     for _, c in pairs(s.clients) do
--       if only_one and not c.floating or c.maximized then
--         c.border_width = 0
--       else
--         c.border_width = 1
--       end
--     end
-- end)
