#!/bin/bash

if [ -e /bin/pacman ]
then
   sudo pacman -Syu zsh wget tmux nano
else 
   sudo apt-get update
   sudo apt-get upgrade
   sudo apt-get install zsh wget tmux nano
fi

if [ ! -d ~/.oh-my-zsh/ ]
then
   cp ~/profile/.zshrc ~
   sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
   cp ~/profile/thesalarian.zsh-theme ~/.oh-my-zsh/themes/

else
   cp ~/profile/.zshrc ~
   cp ~/profile/thesalarian.zsh-theme ~/.oh-my-zsh/themes/
fi

zsh
