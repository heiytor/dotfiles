export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="/home/heitor/.cache/.bun/bin:$PATH"

if [[ -z $SSH_CONNECTION && -z $SSH_AUTH_SOCK ]]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
fi
