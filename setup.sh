#!/bin/bash

# SPDX-FileCopyrightText: 2024 Dominik Wombacher
#
# SPDX-License-Identifier: MIT

declare -A DOTFILES
DOTFILES[".vimrc"]="vimrc"
DOTFILES[".tmux.conf"]="tmux.conf"

declare -A PACKAGES
PACKAGES["common"]="git tmux fzf"
PACKAGES["opensuse"]="${PACKAGES["common"]} vim"
PACKAGES["fedora"]="${PACKAGES["common"]} vim-enhanced-2"

##### Nothing to customize from here #####

RC=0

DOTFILESDIR=$(dirname "$0")
if [[ "$DOTFILESDIR" == "." ]]; then
    DOTFILESDIR=$PWD
fi


echoerr() {
    echo "[ERROR] $*" 1>&2;
    RC=1
}

echoinfo() {
    echo "[INFO] $*"
}

backup_files() {
    echoinfo "Backup files"
    for i in "${!DOTFILES[@]}"
    do
      if { [ -f "$HOME/$i" ] && [ ! -L "$HOME/$i" ] ;} || [ -d "$HOME/$i" ]; then
	     mv "$HOME/$i" "$HOME/$i.bak"
        fi
    done
}

create_symlinks() {
    echoinfo "Create symlinks"
    for i in "${!DOTFILES[@]}"
    do
        if [ ! -L "$HOME/$i" ]; then
             ln -s "$DOTFILESDIR/${DOTFILES[$i]}" "$HOME/$i"
        fi
    done
}

install_vim_plugins() {
    echoinfo "Install VIM plugins"
    mkdir -p "$HOME/.vim/pack/plugins/start/"
    if [ ! -d "$HOME/.vim/pack/plugins/start/vim-tmux-navigator" ]; then
        git clone git@github.com:christoomey/vim-tmux-navigator.git \
          ~/.vim/pack/plugins/start/vim-tmux-navigator
    fi
}

configure_bash() {
    echoinfo "Configure Bash"
    if ! grep -Fxq 'set -o vi' "$HOME/.bashrc"; then
        echo 'set -o vi' >> "$HOME/.bashrc"
    fi
}

if [[ "$OSTYPE" == "linux"* ]]; then
    # Linux
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "opensuse"* ]]; then
            echoinfo "openSUSE"
            # shellcheck disable=SC2086
            sudo zypper in -y ${PACKAGES["opensuse"]}
        elif [[ "$ID" == "fedora"* ]]; then
            echoinfo "Fedora"
            # shellcheck disable=SC2086
            sudo dnf in -y ${PACKAGES["fedora"]}
        else
            echoerr "Unknown Linux Distribution"
        fi
    else
        echoerr "/etc/os-release file not found"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS
    echoinfo "MacOS"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    # FreeBSD
    echoinfo "FreeBSD"
else
    echoerr "Unknown operating system"
fi

backup_files
create_symlinks
install_vim_plugins
configure_bash

exit $RC
