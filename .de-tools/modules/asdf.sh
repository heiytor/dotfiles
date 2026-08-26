#!/usr/bin/env bash

# Setup asdf plugins from .tool-versions
setup_asdf() {
    local tool_versions="${1:-$HOME/.tool-versions}"
    
    if [[ ! -f "$tool_versions" ]]; then
        return 1
    fi
    
    local failed=0

    while IFS= read -r line; do
        tool_name=$(echo "$line" | awk '{print $1}')
        
        if [[ -n "$tool_name" ]]; then
            if ! asdf plugin list | grep -q "^$tool_name$" 2>/dev/null; then
                if ! asdf plugin add "$tool_name"; then
                    failed=1
                fi
            fi
        fi
    done < "$tool_versions"
    
    if ! asdf install; then
        failed=1
    fi

    if (( failed )); then
        return 2
    fi

    return 0
}
