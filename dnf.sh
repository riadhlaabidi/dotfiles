#!/bin/bash

dnf update -y

# dnf tools 
dnf install -y dnf-plugins-core

# Github
dnf install -y gh

# Neovim 
dnf install -y gcc make ripgrep fd-find neovim

# Tmux 
dnf install -y tmux

dnf install alacritty

# i3
dnf install i3 i3status rofi 

# Docker
dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Media 
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y vlc 

