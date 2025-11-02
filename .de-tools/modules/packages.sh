#!/usr/bin/env bash

# Install ans sync packages from .de-config/ensure-installed file
sync_system_pkgs() {
    local ensure_file="${1:-$HOME/.de-config/ensure-installed}"
    
    if [[ -f "$ensure_file" ]]; then
        grep -v '^#\|^$' "$ensure_file" | yay -S --needed --noconfirm -
        return $?
    else
        return 1
    fi
}

# Install and sync Neovim packages
sync_nvim_pkgs() {
    if command -v nvim &> /dev/null; then
        nvim --headless +"lua require('lazy').sync({wait=true})" +qa 2>/dev/null || true
        nvim --headless +TSUpdate +qa 2>/dev/null || true
        nvim --headless +MasonUpdate +qa 2>/dev/null || true
        return 0
    fi

    return 1
}

sync_zsh_pkgs() {
    local omz_custom="$HOME/.oh-my-zsh/custom"
    local plugins_installed=0
    
    # More completions
    if [[ ! -d "$omz_custom/plugins/zsh-completions" ]]; then
        git clone https://github.com/zsh-users/zsh-completions.git \
            "$omz_custom/plugins/zsh-completions"
        ((plugins_installed++))
    fi

    # Syntax highlighting
    if [[ ! -d "$omz_custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$omz_custom/plugins/zsh-syntax-highlighting"
        ((plugins_installed++))
    fi
    
    # Autosuggestions
    if [[ ! -d "$omz_custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "$omz_custom/plugins/zsh-autosuggestions"
        ((plugins_installed++))
    fi
    
    # Auto pairs
    if [[ ! -d "$omz_custom/plugins/zsh-autopair" ]]; then
        git clone https://github.com/hlissner/zsh-autopair.git \
            "$omz_custom/plugins/zsh-autopair"
        ((plugins_installed++))
    fi
    
    # FZF tab
    if [[ ! -d "$omz_custom/plugins/fzf-tab" ]]; then
        git clone https://github.com/Aloxaf/fzf-tab.git \
            "$omz_custom/plugins/fzf-tab"
        ((plugins_installed++))
    fi
    
    # History Search
    if [[ ! -d "$omz_custom/plugins/history-search-multi-word" ]]; then
        git clone https://github.com/zdharma-continuum/history-search-multi-word.git \
            "$omz_custom/plugins/history-search-multi-word"
        ((plugins_installed++))
    fi
    
    return $(( plugins_installed > 0 ? 0 : 1 ))
}
