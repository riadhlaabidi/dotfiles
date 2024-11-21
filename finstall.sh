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

sudo dnf install -y dnf-plugins-core tar unzip wget ripgrep fd-find \
	fzf xclip htop git neovim i3 i3status rofi tmux ImageMagick \
	ristretto light-locker evince
echo "Install all packages...[$(get_status $?)]"

sudo dnf remove -y azote cups-browsed i3-lock mousepad volumeicon \
    pavucontrol system-config-language system-config-printer feh \
    gnome-abrt tecla
echo "Remove unused packages...[$(get_status $?)]"

pushd $HOME &>/dev/null
if [[ ! -d personal ]]; then
    mkdir personal &>/dev/null
    echo "Create personal dir...[$(get_status $?)]"
fi

cd personal

git clone https://github.com/riadhlaabidi/dotfiles.git --depth=1 &>/dev/null
echo "Clone dotfiles repo...[$(get_status $?)]"

if [[ -d dotfiles ]]; then
    cd dotfiles/env/.config/nvim
    git submodule init && git submodule update &>/dev/null
    echo "Update nvim submodule...[$(get_status $?)]"
    cd $HOME/personal
    sh dotfiles/env/.local/bin/renv
    echo "Update environment...[$(get_status $?)]"
    sudo rsync dotfiles/misc/bg.jpg /usr/share/pixmaps/
    echo "Copying over bg image...[$(get_status $?)]"
    sudo rsync dotfiles/misc/lightdm-gtk-greeter.conf /etc/lightdm/
    echo "Copying over lightdm gtk greeter conf...[$(get_status $?)]"
fi
popd &>/dev/null
    
pushd /usr/local &>/dev/nul
if [[ -d st ]]; then
    sudo rm -rf st/ &>/dev/null
    echo "Remove old st installation...[$(get_status $?)]"
fi

if [[ -d go ]]; then
    sudo rm -rf go/
    echo "Remove old Go installation...[$(get_status $?)]"
fi
popd &>/dev/null

if [[ ! -d /usr/local/share/fonts ]]; then
    sudo mkdir /usr/local/share/fonts &>/dev/null
    echo "Create user fonts dir...[$(get_status $?)]"
fi

pushd /usr/local/share/fonts &>/dev/null
if [[ -d JetBrainsMono ]]; then
    sudo rm -rf JetBrainsMono/
    echo "Remove old JetBrainsMono font...[$(get_status $?)]"
fi

sudo mkdir JetBrainsMono
popd &>/dev/null

pushd /tmp &>/dev/null
git clone https://github.com/riadhlaabidi/st.git --depth=1 &>/dev/null
echo "Download st repo...[$(get_status $?)]"

sudo mv st /usr/local/st &>/dev/null
echo "Move st repo...[$(get_status $?)]"
popd &>/dev/null

# install st build deps
sudo dnf install -y fontconfig-devel libXft-devel
echo "Install st deps...[$(get_status $?)]"

pushd /usr/local &>/dev/null
if [[ -d st ]]; then
    cd st/
    sudo make clean install &>/dev/null
    echo "Build and install st...[$(get_status $?)]"
fi
popd &>/dev/null

pushd /tmp &>/dev/null
wget https://go.dev/dl/go1.23.2.linux-amd64.tar.gz &>/dev/null
echo "Download Go archive...[$(get_status $?)]"

if [[ -e "go1.23.2.linux-amd64.tar.gz" ]]; then
    echo "542d3c1705f1c6a1c5a80d5dc62e2e45171af291e755d591c5e6531ef63b454e go1.23.2.linux-amd64.tar.gz" > go_sha.txt

    sha256sum --check --status go_sha.txt
    sha_ec=$?
    echo "Verify checksum for Go archive...[$(get_status $sha_ec)]"

    if [[ sha_ec -eq 0 ]]; then
        sudo tar -xf go1.23.2.linux-amd64.tar.gz -C /usr/local &>/dev/null
        echo "Unarchive go...[$(get_status $?)]"
    fi
fi

wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip &>/dev/null
echo "Download JetbrainsMono archive...[$(get_status $?)]"

if [[ -e JetBrainsMono.zip ]]; then
    echo "6596922aabaf8876bb657c36a47009ac68c388662db45d4ac05c2536c2f07ade JetBrainsMono.zip" > jb_mono_sha.txt

    sha256sum --check --status jb_mono_sha.txt
    sha_ec=$?
    echo "Verify checksum for JetbrainsMono archive...[$(get_status $sha_ec)]"

    if [[ sha_ec -eq 0 ]]; then
        sudo unzip JetBrainsMono.zip -d /usr/local/share/fonts/JetBrainsMono &>/dev/null
        echo "Unarchive JetbrainsMono...[$(get_status $?)]"
    fi
fi

fc-cache -f &>/dev/null
echo "Update font cache...[$(get_status $?)]"
popd &>/dev/null
