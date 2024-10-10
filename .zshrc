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
	zsh-interactive-cd
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

source "$HOME/.asdf/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

EDITOR="nvim"

alias reload="omz reload"
alias v="$EDITOR"
alias c="clear"
alias g="git"
alias tb="nc termbin.com 9999"
alias ls="exa --icons=always --git"
alias ll="exa --icons=always --git -l"
alias cat="bat"
