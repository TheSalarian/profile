# Utility Functions - not intended for use outside of this .zshrc file.
function zshrc_prompt_yes_no() {
	read "?$* (y/n): " ans
	case $ans in
		[Yy]*) return 0 ;;
		[Nn]*) return 1 ;;
		*) echo "$(zshrc_prompt_yes_no $*)" ;;
	esac
}

function zshrc_install_package() {

	if ! zshrc_prompt_yes_no "$1 not installed. Install $1?"; then
		return 1
	fi

	if command -v pacman >/dev/null 2&>1; then
		sudo pacman -S $1
		if [[ "$?" -ne "0" ]]; then
			paru -S $1
		fi
		return $?
	fi

	if command -v apt-get >/dev/null 2&>1; then
		sudo apt install $1
		return $?
	fi

	if command -v apk >/dev/null 2&>1; then
		sudo apk add $1
		return $?
	fi
}

function zshrc_format_duration() {
	local total_seconds=$1
	local hours=$(( total_seconds / 3600 ))
	local minutes=$(( (total_seconds % 3600) / 60 ))
	local seconds=$(( total_seconds % 60 ))

	if (( hours > 0 )); then echo "${hours}h ${minutes}m ${seconds}s"
	elif (( minutes > 0 )); then echo "${minutes}m ${seconds}s"
	else; echo "${seconds}s"
	fi
}

function zshrc_start_timer() {
	TIMER_START=$SECONDS
}

function zshrc_command_duration() {
	local timer_end=$SECONDS
	local duration=$(( timer_end - TIMER_START ))
	local current_time=$(date +"%Y/%m/%d %H:%M:%S")

	if [[ -n "$TIMER_START" && "$duration" -gt 30 ]]; then
		local formatted_duration=$(zshrc_format_duration $duration)
		printf "\nCommand finished at %s, took %s\n\n" "$current_time" "$formatted_duration"
	fi

	TIMER_START=""
}

# Functions
function mywget() {
	if ! command -v wget2 >/dev/null 2>&1; then
		zshrc_install_package "wget2"
		if [[ "$?" -ne "0" ]] ; then
			echo "wget2 isn't installed. Failed to install wget2."
			return 1
		fi
	fi
	wget2 --recursive --level=10 --tries=5 --no-clobber --no-parent --continue -R "index.html" $1
}

# Enable built-in tab completion
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then # Run compinit and generate cache only if cache hasn't been updated for 24 hours.
	compinit
else
	compinit -C
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Enables searching history based on typed characters
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Enable zsh-suggestions (https://github.com/zsh-users/zsh-autosuggestions)
source $ZDOTDIR/zsh-completions/zsh-completions.plugin.zsh
source $ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_BUFFER_MAX=20
bindkey '^ ' autosuggest-accept

# Adds additional command option completions (https://github.com/zsh-users/zsh-completions)
fpath=($ZDOTDIR/zsh-completions/src $fpath)

# Set prompts
PS1="%(!.%F{#FF4141}%n%f@%m %3d #.%F{#3380FF}%n%f@%m %3d %%) " # Left
RPS1="%(0?..(%F{red}%?%f%) )[%D{%I:%M %p}]" # Right

# Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias clera="clear"
alias grep="grep --color=auto"
alias ls="ls --color -a"
alias la="ls -l"

# Misc
HISTFILE=$ZDOTDIR/history

bindkey "^[[1;5D" backward-word   # Ctrl + Left arrow
bindkey "^[[1;5C" forward-word    # Ctrl + Right arrow
bindkey "^H" backward-delete-word # Ctrl + Backspace
bindkey "^[[3;5~" kill-word       # Ctrl + Delete

setopt correct # Enable correction of mistyped commmands
setopt autocd # Enables changing directories by name alone, without 'cd'

preexec() { zshrc_start_timer }
precmd() { zshrc_command_duration }
