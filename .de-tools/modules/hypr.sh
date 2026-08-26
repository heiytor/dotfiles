#!/usr/bin/env bash

# Install, enable and rebuild Hyprland plugins from .de-config/hypr-plugins
sync_hypr_plugins() {
    local plugins_file="${1:-$HOME/.de-config/hypr-plugins}"

    if [[ ! -f "$plugins_file" ]]; then
        return 1
    fi

    local failed=0

    if ! hyprpm update; then
        return 2
    fi

    while read -r plugin_name plugin_url; do
        if [[ -z "$plugin_name" || "$plugin_name" == \#* ]]; then
            continue
        fi

        if ! hyprpm list 2>/dev/null | grep -q "Plugin $plugin_name"; then
            if ! hyprpm add "$plugin_url"; then
                failed=1
                continue
            fi
        fi

        if ! hyprpm enable "$plugin_name"; then
            failed=1
        fi
    done < "$plugins_file"

    if (( failed )); then
        return 2
    fi

    return 0
}
