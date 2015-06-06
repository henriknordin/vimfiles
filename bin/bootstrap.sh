#!/usr/bin/bash

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

variable_set() {
    if [ -z "${!1}" ]; then
        msg "\33[31mFAIL\33[0m Value of [${1}] is: [${!1}]"
        error "You must have your [${!1}] environmental variable set to continue."
    else 
        echo "value of [${1}] is: [${!1}]"
    fi
}

program_exists() {
    local ret='0'
    type $1 >/dev/null 2>&1 || { local ret='1'; }

    # throw error on non-zero return value
    if [ ! "$ret" -eq '0' ]; then
        error "You must have '$1' installed to continue."
    fi
}

# Main...

variable_set        "HOME"

program_exists      "git"
program_exists      "vim"

#do_backup

#create_symlinks     "$APP_PATH" \
#                    "$HOME"
#
#sync_repo           "$HOME/.vim/bundle/vundle" \
#                    "$VUNDLE_URI" \
#                    "master" \
#                    "vundle"

#setup_vundle        "$APP_PATH/.vimrc.bundles.default"

ret="$?"

success "Installed the vim configuration"
