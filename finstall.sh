#!/bin/bash

SUCCESS_CC=32
FAILURE_CC=31
SUCCESS_MSG="OK"
FAILURE_MSG="FAILED"

get_status() {
    if [[ $# -eq 1 ]]; then
        if [[ $1 -eq 0 ]]; then
            echo -e "\x1b[1;${SUCCESS_CC}m${SUCCESS_MSG}\x1b[m"
        else
            echo -e "\x1b[0;${FAILURE_CC}m${FAILURE_MSG}\x1b[m"
        fi
    fi
}

dnf install dnf-plugins-core tar unzip wget ripgrep fd-find \
    fzf xclip htop git neovim i3 i3status rofi tmux ImageMagick \
    ristretto light-locker

systemctl stop cups-browsed
systemctl disable cups-browsed

dnf remove azote cups-browsed i3-lock

push $HOME
if [[ ! -d personal ]]; then
    mkdir personal
    echo "Create personal dir...[$(get_status $?)]"
fi

cd personal

git clone https://github.com/riadhlaabidi/dotfiles.git --depth=1
echo "Clone dotfiles repo...[$(get_status $?)]"

if [[ -d dotfiles ]]; then
    sh dotfiles/env/.local/bin/renv
    echo "Update environment...[$(get_status $?)]"
    rsync dotfiles/misc/bg.jpg /usr/share/pixmaps/
    echo "Copying over bg image...[$(get_status $?)]"
    rsync dotfiles/misc/lightdm-gtk-greeter.conf /etc/lightdm/
    echo "Copying over lightdm gtk greeter conf...[$(get_status $?)]"
fi
popd
    
pushd /usr/local
if [[ -d st ]]; then
    rm -rf st/
fi

mkdir st

# install st build deps
dnf instal fontconfig-devel libXft-devel

git clone https://github.com/riadhlaabidi/st.git --depth=1
echo "Download st repo...[$(get_status $?)]"

if [[ -d st ]]; then
    cd st/
    make clean install
    echo "Build and install st...[$(get_status $?)]"
fi

# remove old golang installation
if [[ -d go ]]; then
    rm -rf go/
    echo "Remove old Go installation...[$(get_status $?)]"
fi
popd

pushd /usr/local/share/fonts
if [[ -d JetBrainsMono ]]; then
    rm -rf JetBrainsMono/
fi

mkdir JetBrainsMono
popd

pushd /tmp
wget https://go.dev/dl/go1.23.2.linux-amd64.tar.gz
echo "Download Go archive...[$(get_status $?)]"

if [[ -e "go1.23.2.linux-amd64.tar.gz" ]]; then
    echo "542d3c1705f1c6a1c5a80d5dc62e2e45171af291e755d591c5e6531ef63b454e go1.23.2.linux-amd64.tar.gz" > go_sha.txt

    sha256sum --check --status go_sha.txt
    sha_ec=$?
    echo "Verify checksum for Go archive...[$(get_status $sha_ec)]"

    if [[ sha_ec -eq 0 ]]; then
        tar -xf go1.23.2.linux-amd64.tar.gz -c /usr/local
        echo "Unarchive go...[$(get_status $?)]"
    fi
fi

wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
echo "Download JetbrainsMono archive...[$(get_status $?)]"

if [[ -e JetBrainsMono.zip ]]; then
    echo "6596922aabaf8876bb657c36a47009ac68c388662db45d4ac05c2536c2f07ade JetBrainsMono.zip" > jb_mono_sha.txt

    sha256sum --check --status jb_mono_sha.txt
    sha_ec=$?
    echo "Verify checksum for JetbrainsMono archive...[$(get_status $sha_ec)]"

    if [[ sha_ec -eq 0 ]]; then
        unzip JetBrainsMono.zip -d /usr/local/share/fonts/JetBrainsMono
        echo "Unarchive JetbrainsMono...[$(get_status $?)]"
    fi
fi
popd



