#!/usr/bin/bash

#######################################
# Script variables
#######################################

VIMDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )
[ -z "$VUNDLE_URI" ] && VUNDLE_URI="https://github.com/gmarik/vundle.git"

#######################################
# Utility functions
#######################################

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

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
    #debug
}


#######################################
# Setup functions
#######################################

create_symlinks() {
    local source_path="$1"
    local target_path="$2"

    lnif "$source_path/vimrc"           "$target_path/.vimrc"
    lnif "$source_path/vimrc.bundles"   "$target_path/.vimrc.bundles"
    lnif "$source_path"                 "$target_path/.vim"

    ret="$?"
    success "Setting up vim symlinks."
    #debug
}

sync_repo() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    msg "Trying to update $repo_name"

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone -b "$repo_branch" "$repo_uri" "$repo_path"
        ret="$?"
        success "Successfully cloned $repo_name."
    else
        cd "$repo_path" && git pull origin "$repo_branch"
        ret="$?"
        success "Successfully updated $repo_name"
    fi

    #debug
}

setup_vundle() {
    local system_shell="$SHELL"
    export SHELL='/bin/sh'

    vim \
        -u "$1" \
        "+set nomore" \
        "+BundleInstall!" \
        "+BundleClean" \
        "+qall"

    export SHELL="$system_shell"

    success "Now updating/installing plugins using Vundle"
    #debug
}

#######################################
# Main
#######################################

variable_set        "HOME"

program_exists      "git"
program_exists      "vim"

#do_backup
#echo "BASH_SOURCE: ${BASH_SOURCE[0]}"
#echo "DIR: $( dirname "${BASH_SOURCE[0]}" )"$("/../")
#echo $DIR
echo "VIMDIR: $VIMDIR"

create_symlinks     "$VIMDIR" \
                    "$HOME"

#sync_repo           "$VIMDIR" \
#                    "$REPO_URI" \
#                    "$REPO_BRANCH" \
#                    "$REPO_NAME"

#setup_vundle        "$APP_PATH/.vimrc.bundles.default"
sync_repo           "$HOME/.vim/bundle/vundle" \
                    "$VUNDLE_URI" \
                    "master" \
                    "vundle"

setup_vundle        "$VIMDIR/.vimrc.bundles"

ret="$?"

success "Installed the vim configuration"
