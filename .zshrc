export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="sorin"
ENABLE_CORRECTION="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"

zstyle ':omz:update' mode auto

plugins=(
    command-not-found
    copyfile
    docker
    docker-compose
    sudo
    zoxide
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

export SUDO_EDITOR="$EDITOR"

# export PATH="$HOME/bin:$PATH"

# ASDF setup
if [ -f "$HOME/bin/asdf" ]; then
    if [ ! -d "${ASDF_DATA_DIR:-$HOME/.asdf}/completions" ]; then
        mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
        asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
    fi

    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

    fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
    autoload -Uz compinit && compinit
fi

v() {
    if [ "$#" -eq 0 ]; then
        "$EDITOR" .
    else
        "$EDITOR" "$@"
    fi
}

if command -v zoxide &> /dev/null; then
    alias cd="z"
fi

alias clear="printf '\033[2J\033[3J\033[H'" # Make clear also clear the scrollback buffer
alias c="clear"
alias reload="omz reload"
alias g="git"
alias tb="nc termbin.com 9999"
alias ls="exa --icons=always --git"
alias ll="exa --icons=always --git -l"
alias cat="bat"
alias ssh="TERM=xterm ssh"
