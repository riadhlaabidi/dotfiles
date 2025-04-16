#!/bin/bash

SUCCESS_CC=32
FAILURE_CC=31
SUCCESS_MSG="OK"
FAILURE_MSG="FAILED"

GIT_SSH="git@github.com:riadhlaabidi"
GO_VERSION="1.24.2"
GO_CHECKSUM="68097bd680839cbc9d464a0edce4f7c333975e27a90246890e9f1078c7e702ad"
GO_ARCHIVE="go$GO_VERSION.linux-amd64.tar.gz"
JBM_CHECKSUM="2d83782a350b604bfa70fce880604a41a7f77c3eec8f922f9cdc3c20952ddbe4"
JBM_ARCHIVE="JetBrainsMono.zip"

get_status() {
    if [[ $# -eq 1 ]]; then
        if [[ $1 -eq 0 ]]; then
            echo -e "\x1b[1;${SUCCESS_CC}m${SUCCESS_MSG}\x1b[m"
        else
            echo -e "\x1b[0;${FAILURE_CC}m${FAILURE_MSG}\x1b[m"
        fi
    fi
}

if eval "$(ssh-agent -s)"; then
    echo "Adding SSH keys to agent..."
    ssh-add
fi 

sudo dnf update
echo "Update system packages...[$(get_status $?)]"

sudo dnf install -y dnf-plugins-core tar unzip wget ripgrep fd-find \
	fzf xclip htop git neovim i3 i3status rofi tmux ImageMagick \
	ristretto light-locker evince make gcc
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
    sudo rsync misc/bg.jpg /usr/share/pixmaps/
    echo "Copying over bg image...[$(get_status $?)]"
    sudo rsync misc/lightdm-gtk-greeter.conf /etc/lightdm/
    echo "Copying over lightdm gtk greeter conf...[$(get_status $?)]"
fi
popd &>/dev/null
    
pushd /usr/local &>/dev/null
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
git clone "$GIT_SSH/st.git" --depth=1 &>/dev/null
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
if [[ -e $GO_ARCHIVE ]]; then
    rm -rf $GO_ARCHIVE
fi
wget "https://go.dev/dl/$GO_ARCHIVE" &>/dev/null
echo "Download Go archive...[$(get_status $?)]"

if [[ -e $GO_ARCHIVE ]]; then
    echo "$GO_CHECKSUM $GO_ARCHIVE" > go_sha.txt

    sha256sum --check --status go_sha.txt
    sha_ec=$?
    echo "Verify checksum for Go archive...[$(get_status $sha_ec)]"

    if [[ sha_ec -eq 0 ]]; then
        sudo tar -xf $GO_ARCHIVE -C /usr/local &>/dev/null
        echo "Unarchive go...[$(get_status $?)]"
    fi

    rm -rf go_sha.txt
fi

if [[ -e $JBM_ARCHIVE ]]; then
    rm -rf $JBM_ARCHIVE
fi

wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$JBM_ARCHIVE" &>/dev/null
echo "Download JetbrainsMono archive...[$(get_status $?)]"

if [[ -e $JBM_ARCHIVE ]]; then
    echo "$JBM_CHECKSUM $JBM_ARCHIVE" > jb_mono_sha.txt

    sha256sum --check --status jb_mono_sha.txt
    sha_ec=$?
    echo "Verify checksum for JetbrainsMono archive...[$(get_status $sha_ec)]"

    if [[ sha_ec -eq 0 ]]; then
        sudo unzip $JBM_ARCHIVE -d /usr/local/share/fonts/JetBrainsMono &>/dev/null
        echo "Unarchive JetbrainsMono...[$(get_status $?)]"
    fi

    rm -rf jb_mono_sha.txt
fi

fc-cache -f &>/dev/null
echo "Update font cache...[$(get_status $?)]"
popd &>/dev/null
