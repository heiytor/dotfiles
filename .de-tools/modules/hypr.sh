#!/usr/bin/env bash

HYPR_LUA_PACKAGES_DIR="$HOME/.local/share/hypr/lua"

# Prints the Hyprland "major.minor" version, e.g. 0.57
hypr_minor_version() {
    Hyprland --version-json 2>/dev/null | jq -r '.version // empty' | cut -d. -f1,2
}

# Lists the hyprpm plugins currently known to hyprpm
hyprpm_plugins() {
    hyprpm list 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | sed -n 's/.*Plugin \([^ ]*\).*/\1/p'
}

# Clone or update a Lua package, following the release branch of the running Hyprland
sync_hypr_lua_package() {
    local name="$1"
    local url="$2"
    local dir="$HYPR_LUA_PACKAGES_DIR/$name"
    local version branch

    mkdir -p "$HYPR_LUA_PACKAGES_DIR"

    if [[ ! -d "$dir/.git" ]]; then
        git clone --quiet "$url" "$dir" || return 1
    fi

    git -C "$dir" fetch --quiet --prune origin || return 1

    version=$(hypr_minor_version)
    branch=$(git -C "$dir" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
    branch="${branch#origin/}"

    if [[ -n "$version" ]] && git -C "$dir" show-ref --quiet "refs/remotes/origin/release/$version.x"; then
        branch="release/$version.x"
    fi

    git -C "$dir" checkout --quiet -B "$branch" "origin/$branch"
}

# Install, enable and update Hyprland plugins from .de-config/hypr-plugins
sync_hypr_plugins() {
    local plugins_file="${1:-$HOME/.de-config/hypr-plugins}"

    if [[ ! -f "$plugins_file" ]]; then
        return 1
    fi

    local failed=0
    local declared_hyprpm=()

    if ! hyprpm update <<< "Y"; then
        return 2
    fi

    while read -r plugin_kind plugin_name plugin_url <&3; do
        if [[ -z "$plugin_kind" || "$plugin_kind" == \#* ]]; then
            continue
        fi

        case "$plugin_kind" in
            hyprpm)
                declared_hyprpm+=("$plugin_name")

                if ! hyprpm_plugins | grep -qx "$plugin_name"; then
                    if ! hyprpm add "$plugin_url" <<< "Y"; then
                        failed=1
                        continue
                    fi
                fi

                if ! hyprpm enable "$plugin_name"; then
                    failed=1
                fi
                ;;
            lua)
                if ! sync_hypr_lua_package "$plugin_name" "$plugin_url"; then
                    failed=1
                fi
                ;;
            *)
                failed=1
                ;;
        esac
    done 3< "$plugins_file"

    # Disable hyprpm plugins that are no longer declared (e.g. replaced by a Lua package)
    local installed declared is_declared
    while read -r installed; do
        [[ -z "$installed" ]] && continue

        is_declared=0
        for declared in "${declared_hyprpm[@]}"; do
            [[ "$declared" == "$installed" ]] && is_declared=1
        done

        if (( ! is_declared )); then
            hyprpm disable "$installed" || failed=1
        fi
    done < <(hyprpm_plugins)

    if (( failed )); then
        return 2
    fi

    return 0
}
