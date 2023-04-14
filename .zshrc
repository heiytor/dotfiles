export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="arrow"

# Sensitive
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Disable in WSL
DISABLE_AUTO_TITLE="false"

plugins=(
  git
  # dotenv
  zsh-syntax-highlighting
  zsh-autosuggestions
  asdf
)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

# Text files aliases
EDITOR="nvim"
alias v="nvim"
alias zshc="${EDITOR} ~/.zshrc"
alias zsho="${EDITOR} ~/.oh-my-zsh"

# System 
alias bat="bat --style=auto"
alias ls="exa -lh --icons"

# Shutdown WSL distro
alias exit="wsl.exe --shutdown"

# export PATH=$HOME/.asdf/installs/python/3.11.2/bin
export PATH=$HOME/.local/bin:$PATH

# Javascript || Typescript
export DENO_DIR=$HOME/.deno/cache

alias ts="npx tsnd --transpile-only"
alias prisma="npx prisma"

# Go
export GOPATH=$(go env GOPATH)
export PATH=$PATH:$(go env GOPATH)/bom
export PATH=$PATH:/usr/local/go/bin

# Rust
source "$HOME/.cargo/env"

