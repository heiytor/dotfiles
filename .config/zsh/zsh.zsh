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
    zsh-completions
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-autopair
    fzf-tab
    history-search-multi-word
)

source ~/.config/zsh/env.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/functions.zsh
source ~/.config/zsh/keybindings.zsh

source $ZSH/oh-my-zsh.sh

autoload -Uz compinit && compinit

eval "$(direnv hook zsh)"
if command -v zoxide &> /dev/null; then 
    eval "$(zoxide init --cmd cd zsh)"
fi
