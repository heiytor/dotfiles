local awful = require("awful")

local scheduler = require("lib/scheduler")

awful.spawn.with_shell("picom")
awful.spawn.with_shell("flameshot")
awful.spawn.with_shell("discord --start-minimized")
awful.spawn.with_shell("sleep 0.5 && copyq")  -- This sleep command is a workaround for a system tray bug. See https://github.com/hluk/CopyQ/discussions/1546#discussioncomment-312577 for more details.

scheduler.reset()
scheduler.notification("08:30", "Start Work Reminder", "Time to start work", true, 15000)
scheduler.notification("12:00", "Lunch Break Reminder", "Take a lunch break", true, 15000)
scheduler.notification("13:30", "Return to Work Reminder", "Time to return to work", true, 15000)
scheduler.notification("18:15", "End of Work Reminder", "Stop working for the day", true, 15000)
