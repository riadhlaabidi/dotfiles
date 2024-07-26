#!/bin/bash

set -e

DEFAULT='\033[0m'
BLUE='\033[1;34m'

script_dir=$(readlink -f $(dirname $0))

echo -e "${BLUE} \n Setting hostname ...\n${DEFAULT}"
echo "Enter your hostname: "
read HOSTNAME
hostnamectl set-hostname $HOSTNAME

# =========================================================================================
# =========================================================================================

echo -e "${BLUE} \nInstalling packages...\n${DEFAULT}"
chmod +x $script_dir/dnf.sh
sudo $script_dir/dnf.sh

# =========================================================================================
# =========================================================================================

echo -e "${BLUE} \nCreating symlinks for config files in home directory...\n${DEFAULT}"

# Create .config if it doesn't exist in the home directory
if [ ! -d $HOME/.config ]
then
  echo "Creating .config directory..." 
  mkdir $HOME/.config
fi

# Delete nvim config if somehow existed and create symlink for 
# its config from dotfiles
if [ -d $HOME/.config/nvim ]
then
  echo "Deleting old neovim config..."
  rm -rf $HOME/.config/nvim
fi
echo "Creating symlink for neovim config from dotfiles..."
ln -s $script_dir/nvim $HOME/.config/ 

# Delete alacritty config if somehow existed and create symlink for 
# its config from dotfiles
if [ -d $HOME/.config/alacritty ]
then
  echo "Deleting old alacritty config..."
  rm -rf $HOME/.config/alacritty
fi
echo "Creating symlink for alacritty config from dotfiles..."
ln -s $script_dir/alacritty $HOME/.config/ 

# Delete starship config if somehow existed and create symlink for 
# its config from dotfiles
if [ -f $HOME/.config/starship.toml ]
then
  echo "Deleting old starship config..."
  rm -rf $HOME/.config/starship.toml
fi
echo "Creating symlink for starship config from dotfiles..."
ln -s $script_dir/starship.toml $HOME/.config/ 

# Delete tmux config if somehow existed and create symlink for 
# its config from dotfiles
if [ -d $HOME/.config/tmux ]
then
  echo "Deleting old tmux config..."
  rm -rf $HOME/.config/tmux
fi
echo "Creating symlink for tmux config from dotfiles..."
ln -s $script_dir/tmux $HOME/.config/ 

# i3
if [ -d $HOME/.config/i3 ]
then
  echo "Deleting old i3 config..."
  rm -rf $HOME/.config/i3
fi
echo "Creating symlink for i3 config from dotfiles..."
ln -s $script_dir/i3 $HOME/.config/ 

# i3status
if [ -d $HOME/.config/i3status ]
then
  echo "Deleting old i3status config..."
  rm -rf $HOME/.config/i3status
fi
echo "Creating symlink for i3status config from dotfiles..."
ln -s $script_dir/i3status $HOME/.config/ 

if [ -d $HOME/.bashrc.d ]
then
  echo "Deleting old bashrc.d config..."
  rm -rf $HOME/.bashrc.d
fi
echo "Creating symlink for bashrc.d config from dotfiles..."
ln -s $script_dir/.bashrc.d $HOME/ 

if [ -f $HOME/.gitconfig ]
then
  echo "Deleting old git config..."
  rm -rf $HOME/.gitconfig
fi
echo "Creating symlink for git config from dotfiles..."
ln -s $script_dir/.gitconfig $HOME/.gitconfig
