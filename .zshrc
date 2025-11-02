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

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'

    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" > /dev/null 2>&1
    fi
fi

export SUDO_EDITOR="$EDITOR"

if command -v asdf > /dev/null 2>&1; then
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

eval "$(direnv hook zsh)"

export PATH="/home/heitor/.cache/.bun/bin:$PATH"

autoload -Uz compinit && compinit

untar() {
   if [[ -f "$1" ]]; then
       local dir_name="${1%.tar.gz}"
       mkdir -p "$dir_name"
       tar -xzf "$1" -C "$dir_name"
   else
       echo "File not found: $1"
   fi
}

alias clear="printf '\033[2J\033[3J\033[H'" # Make clear also clear the scrollback buffer
alias c="clear"
alias reload="omz reload"
alias g="git"
alias tb="nc termbin.com 9999"
alias ls="exa --icons=always --git"
alias ll="exa --icons=always --git -l"
alias cat="bat --style=plain --paging=never --color auto"
alias ssh="TERM=xterm ssh" # Force xterm compatibility for better SSH sessions

if command -v zoxide &> /dev/null; then eval "$(zoxide init --cmd cd zsh)"; fi # Initialize zoxide for smart directory jumping
v() { [ "$#" -eq 0 ] && "$EDITOR" . || "$EDITOR" "$@"; } # Open editor in current dir or with specified files

# Thanks to HyDE
# https://github.com/HyDE-Project/HyDE/blob/master/Configs/.config/zsh/functions/kb_help.zsh
function append_help_and_run() {
    if [[ -n $BUFFER ]]; then
        if [[ -z "${BUFFER// }" ]]; then
            zle self-insert
            return
        fi

        local before_cursor="${BUFFER:0:$CURSOR}"
        local after_cursor="${BUFFER:$CURSOR}"
        local single_quotes="${BUFFER//[^']}"
        local double_quotes="${BUFFER//[^\"]}"

        if [[ $before_cursor == *\"* && $after_cursor == *\"* ]] || [[ $before_cursor == *\'* && $after_cursor == *\'* ]]; then
            zle self-insert
            return
        fi

        if (( ${#single_quotes} % 2 != 0 || ${#double_quotes} % 2 != 0 )); then
            zle self-insert
            return
        fi

        local char_before="${BUFFER:$CURSOR-1:1}"
        local char_after="${BUFFER:$CURSOR:1}"
        if [[ $char_before != " " && -n $char_before ]] || [[ $char_after != " " && -n $char_after ]]; then
            zle self-insert
            return
        fi

        if [[ $BUFFER != *"--help"* ]]; then
            BUFFER="$BUFFER --help"
        fi
        zle end-of-line
        zle accept-line
    else
        zle self-insert
    fi
}

zle -N append_help_and_run
bindkey '?' append_help_and_run

# Thanks to hightemp
# https://gist.githubusercontent.com/hightemp/5071909/raw/
function extract {
  if [ -z "$1" ]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
  else
    if [ -f $1 ]; then
      case $1 in
        *.tar.bz2)   tar xvjf $1    ;;
        *.tar.gz)    tar xvzf $1    ;;
        *.tar.xz)    tar xvJf $1    ;;
        *.lzma)      unlzma $1      ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar x -ad $1 ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xvf $1     ;;
        *.tbz2)      tar xvjf $1    ;;
        *.tgz)       tar xvzf $1    ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *.xz)        unxz $1        ;;
        *.exe)       cabextract $1  ;;
        *)           echo "extract: '$1' - unknown archive method" ;;
      esac
    else
      echo "$1 - file does not exist"
    fi
  fi
}

