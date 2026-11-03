local exec = hl.dsp.exec_cmd

-- de-launch --focus <class> raises an open window instead of starting another one
hl.bind("SUPER + A",           exec("uwsm app -- kitty --directory $(de-cwd)"),                                                             { description = "Terminal" })
hl.bind("SUPER + S",           exec("de-launch --focus brave-browser -- brave --new-window --restore-last-session --ozone-platform=wayland"), { description = "Browser" })
hl.bind("SUPER + D",           exec("de-launch --focus Bitwarden -- $PASSWORD_MANAGER"),                                                     { description = "Password manager" })
hl.bind("SUPER + G",           exec("uwsm app -- typora --enable-wayland-ime"),                                                             { description = "Markdown editor" })
hl.bind("SUPER + Tab",         exec('de-bin-walker -p "Start…"'),                                                                           { description = "App launcher" })
hl.bind("SUPER + SHIFT + Tab", exec("de-bin-walker -m clipboard"),                                                                          { description = "Clipboard manager" })
hl.bind("Print",               exec("de-printscr area --save --clipboard"),                                                                 { description = "Screenshot" })
