-- Sends the OSD command to the focused monitor
local function osd(args)
    return function()
        local monitor = hl.get_active_monitor()
        local target = monitor and (' --monitor "' .. monitor.name .. '"') or ""

        hl.exec_cmd("swayosd-client" .. target .. " " .. args)
    end
end

local media = { locked = true, repeating = true }

local function with_description(description)
    return { locked = media.locked, repeating = media.repeating, description = description }
end

hl.bind("XF86AudioRaiseVolume",  osd("--output-volume raise"),       with_description("Volume up"))
hl.bind("XF86AudioLowerVolume",  osd("--output-volume lower"),       with_description("Volume down"))
hl.bind("XF86AudioMute",         osd("--output-volume mute-toggle"), with_description("Mute"))
hl.bind("XF86AudioMicMute",      osd("--input-volume mute-toggle"),  with_description("Mute microphone"))
hl.bind("XF86MonBrightnessUp",   osd("--brightness raise"),          with_description("Brightness up"))
hl.bind("XF86MonBrightnessDown", osd("--brightness lower"),          with_description("Brightness down"))
