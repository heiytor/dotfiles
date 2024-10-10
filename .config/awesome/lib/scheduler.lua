local M = {}

local awful = require("awful")

local utils = require("utils")

M.reset = function()
    awful.spawn.with_shell("atrm $(atq | awk '{print $1}')")
end

---Schedules a notification to be triggered at a specified time.
-- @param time string The time when the notification should be triggered in a format that 'at' recognizes. (e.g 8:30)
-- @param title string The title of the notification.
-- @param description string [optional] The content or message of the notification. Defaults to blank string.
-- @param sound boolean [optional] If true, plays a notification sound. Defaults to false.
-- @param timeout number [optional] The time in milliseconds the notification should be displayed. Defaults to 5000.
M.notification = function(time, title, description, sound, timeout)
    description = description or ""
    sound = sound or false
    timeout = timeout or 5000

    -- "payplay ${root_dir}/sounds/notification.mp3" || ""
    local sound_cmd = sound and ("paplay " .. utils.themes_dir .. "/dark/notification.mp3") or ""
    -- "notify-send -t ${timeout} '${title}' '${description}'"
    local notify_cmd = "notify-send -t " .. timeout .. " '" .. title .. "' '" .. description .. "'"
    -- ("payplay ${root_dir}/sounds/notification.mp3" || "")  "& notify-send -t ${timeout} '${title}' '${description}'"
    local cmd = sound_cmd ~= "" and (sound_cmd .. " & " .. notify_cmd) or notify_cmd

    awful.spawn.with_shell("echo \"" .. cmd .. "\" | at " .. time)
end

return M
