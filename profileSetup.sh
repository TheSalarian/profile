#!/bin/bash

if [ -e /bin/pacman ]
then
   sudo pacman -Syu git zsh wget tmux nano
else 
   sudo apt-get update
   sudo apt-get upgrade
   sudo apt-get install git zsh wget tmux nano
fi

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


