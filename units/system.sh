#!/bin/sh

. util.sh

sudo dnf update
echo "Update system packages...[$(get_status $?)]"

sudo dnf install -y dnf-plugins-core tar unzip wget ripgrep fd-find \
	fzf xclip htop neovim rofi tmux ristretto evince
echo "Install all packages...[$(get_status $?)]"

sudo dnf remove -y azote cups-browsed mousepad volumeicon \
    pavucontrol system-config-language system-config-printer feh \
    gnome-abrt tecla
echo "Remove unused packages...[$(get_status $?)]"

