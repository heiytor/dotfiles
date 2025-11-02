# Append --help with '?' key
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
