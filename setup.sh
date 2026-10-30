#!/bin/sh

script_location=$(find "/home/$USERNAME" -type f -iname "setup.sh")
working_dir=$(dirname -- $script_location)

if [ ! -d ~/.config/ ]; then mkdir -p ~/.config/; fi

if command -v nano >/dev/null 2>&1 ; then
	find ~ -maxdepth 1 -iname "*nanorc*" -delete
	if [ -d ~/.config/nano ]; then rm -r ~/.config/nano; fi
	cp -r $working_dir/nano ~/.config/
fi

if command -v zsh >/dev/null 2>&1 ; then
	find ~ -maxdepth 1 -type f \( -iname ".zshenv" -or -iname "*zsh*" -or -iname "*zcomp*" \) -delete
	rm -rf ~/.config/zsh
	if [ -d ~/.config/zsh ]; then rm -r ~/.config/zsh; fi
	cp $working_dir/.zshenv ~
	cp -r $working_dir/zsh ~/.config/
fi
