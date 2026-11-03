-- Monitors
-- See https://wiki.hypr.land/configuring/core/monitors/

hl.monitor({
    output   = "desc:Samsung Electric Company Odyssey G30B HX5X501356",
    mode     = "1920x1080@144",
    position = "0x1080",
    scale    = 1,
})

hl.monitor({
    output   = "desc:AU Optronics B153UAN03.0",
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
