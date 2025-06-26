#!/bin/bash

. util.sh

pushd $HOME &>/dev/null
if [[ ! -d personal ]]; then
    mkdir personal &>/dev/null
    echo "Create personal dir...[$(get_status $?)]"
fi

cd personal

if [[ -d dotfiles ]]; then
    rm -rf dotfiles &>/dev/null
    echo "Remove old dotfiles repo...[$(get_status $?)]"
fi

git clone "$GIT_SSH/dotfiles.git" --depth=1 &>/dev/null
echo "Clone dotfiles repo...[$(get_status $?)]"

if [[ -d dotfiles ]]; then
    cd dotfiles
    pushd env/.config/nvim &>/dev/null
    git submodule init && git submodule update 
    echo "Update nvim submodule...[$(get_status $?)]"
    popd &>/dev/null
    sh env/.local/bin/renv
    echo "Update environment...[$(get_status $?)]"
    sudo rsync misc/bg.jpg /usr/share/backgrounds/
    echo "Copying over bg image...[$(get_status $?)]"
fi
popd &>/dev/null
