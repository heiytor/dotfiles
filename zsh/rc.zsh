export ZSH="$HOME/.oh-my-zsh"

# [peepcode, simple, sorin]
ZSH_THEME="sorin"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo
)

source $ZSH/oh-my-zsh.sh

alias g="git"
alias c="clear"
alias v="nvim"

# ASDF
. "$HOME/.asdf/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

source "$HOME/.asdf/installs/rust/1.76.0/env" # RUST
export PATH="$HOME/.asdf/installs/golang/1.22.1/packages/bin:$PATH" # GO

alias ls="exa -l --icons --git"

typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'

ZSH_HIGHLIGHT_STYLES[path]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[path_separator]='fg=green,bold'

ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=black,bold'

