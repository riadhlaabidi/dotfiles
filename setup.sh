#!/bin/bash

DEFAULT='\033[0m'
BLUE='\033[1;34m'

# echo -e "${BLUE} \n Setting hostname ...\n${DEFAULT}"
# echo "Enter your hostname: "
# read HOSTNAME
# hostnamectl set-hostname $HOSTNAME

echo -e "${BLUE} \nInstalling packages...\n${DEFAULT}"
./dnf.sh

echo -e "${BLUE} \nCopying config files...\n${DEFAULT}"
cp -r ./.bashrc.d ~/
cp -r ./nvim ~/.config/
cp -r ./config/tmux ~/.config/

