#!/bin/sh

script_location=$(find "$HOME" -type f -iname "setup.sh")
echo "Script location: $script_location"
working_dir=$(dirname -- $script_location)
echo "Working directory: $working_dir\n"

if [ $(find ~ -iname "setup.sh" | wc -l) -gt 1 ]; then
	echo "Multiple setup.sh scripts found. Exiting."
	return
fi

if [ $(ls "$working_dir/zsh/zsh-autosuggestions" | wc  -l) -eq 2 ]; then
	echo "Directory \"zsh-autosuggestions\" appears to be empty. \"Git clone\" was likely run without the \"--recurse-submodules\" option. Exiting."
	return
fi

if [ $(ls "$working_dir/zsh/zsh-completions" | wc  -l) -eq 2 ]; then
	echo "Directory \"zsh-completions\" appears to be empty. \"Git clone\" was likely run without the \"--recurse-submodules\" option. Exiting."
	return
fi

if [ ! -d ~/.config/ ]; then
	echo "~/.config/ not found. Creating..."
	mkdir -p ~/.config/
fi

if command -v nano >/dev/null 2>&1 ; then
	echo "Nano installed at $(command -v nano)..."
	echo "\tRecursively deleting existing nanorc..."
	find ~ -maxdepth 1 -iname "*nanorc*" -delete
	if [ -d ~/.config/nano ]; then
		echo "\tOld ~/.config/nano found. Removing..."
		rm -r ~/.config/nano
	fi
	echo "\tCopying $working_dir/nano to ~/.config..."
	cp -r $working_dir/nano ~/.config/
fi

if command -v zsh >/dev/null 2>&1 ; then
	echo "Zsh installed at $(command -v zsh)"
	echo "\tRecursively deleting existing zshenv, zshrc, and zcompdump files..."
	find ~ -maxdepth 1 -type f \( -iname ".zshenv" -or -iname "*zsh*" -or -iname "*zcomp*" \) -delete
	if [ -d ~/.config/zsh ]; then
		echo "\tOld ~/.config/zsh found. Removing..."
		rm -r ~/.config/zsh
	fi
	echo "\tCopying $working_dir/.zshenv to ~"
	cp $working_dir/.zshenv ~
	echo "\tCopying $working_dir/zsh to ~/.config/"
	cp -r $working_dir/zsh ~/.config/
fi

echo "Setup complete!"
