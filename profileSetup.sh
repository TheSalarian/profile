#!/bin/bash

usage="
$(basename "$0") -- Bash script to configure basic settings.

Options:
  -h: Display this help text.

  -a: All. Functions as -nopu
  -n: Set .nanorc configuration file.
  -o: Install Oh My Zsh, set .zshrc configuration file, chsh to Zsh.
  -p: Install a number of useful packages.
  -u: Perform full system update. Works for pacman- or apt-managed systems.
"

main() {

   if [[ $# == 0 ]]; then echo "$usage"; exit 0; fi

   while getopts "ahnopu" flag; do
      case $flag in
         h) echo "$usage"; exit 0;; # Display help
         u) updateSystem ;;    # Run system updates
         p) installPackages ;; # Install packages
         o) installOMZ ;;      # Install Oh My ZSH
         n) configureNano ;;   # Configure Nano
         a)                    # Run all functions
            updateSystem
            installPackages
            installOMZ
            configureNano
            exit
            ;;
         *) # Handle invalid flags
            echo "Invalid flag(s) specified. $usage"
            ;;
      esac
   done

}

updateSystem() {

   if [ -e /bin/pacman ]
   then
      sudo pacman -Syu
   else
      sudo apt-get update
      sudo apt-get upgrade
   fi

}

installPackages() {

   if [ -e /bin/pacman ]
   then
      sudo pacman -S zsh wget tmux nano
   else
      sudo apt-get install zsh wget tmux nano
   fi

}

installOMZ() {

   if [ ! -d ~/.oh-my-zsh/ ]
   then
      cp ./zshrc ~/.zshrc

      # --unattended: prevents install script from using chsh or switching immediately to zsh, which stops the rest of this script from running.
      # --keep-zsh: prevents overwriting of .zshrc with the default version.
      sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

      cp ./thesalarian.zsh-theme ~/.oh-my-zsh/themes/

   else
      cp ./zshrc ~/.zshrc
      cp ./thesalarian.zsh-theme ~/.oh-my-zsh/themes/
   fi

   chsh -s /bin/zsh
   zsh
}

configureNano() {

   if [ ! -e /usr/bin/nano ]; then installPackages; fi

   cp ./nanorc ~/.nanorc

}

main "$@"
