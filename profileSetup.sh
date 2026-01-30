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
   
   # --unattended: prevents install script from using chsh or switching immediately to zsh, which stops the rest of this script from running.
   # --keep-zsh: prevents overwriting of .zshrc with the default version.
   sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
   
   cp ~/profile/thesalarian.zsh-theme ~/.oh-my-zsh/themes/

else
   cp ~/profile/.zshrc ~
   cp ~/profile/thesalarian.zsh-theme ~/.oh-my-zsh/themes/
fi

chsh -s /bin/zsh
zsh
