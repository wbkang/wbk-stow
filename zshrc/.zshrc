# load oh-my-zsh if available
[ -d ~/.oh-my-zsh ] && source ~/.zshrc.omz

autoload -U add-zsh-hook
autoload -U colors && colors
autoload -U compinit && compinit

# sync displays across terminals
sync_display() {
	display_file="/tmp/current_display.$UID"
	if [ -z "$TMUX" ] && [ ! -z "$DISPLAY" ]; then
		# if we are not in tmux & display is defined, then save this.
		echo $DISPLAY > $display_file
	elif [ ! -z "$TMUX" ] && [ -f "$display_file" ]; then
		export DISPLAY=`cat $display_file`
	fi	
}

add-zsh-hook preexec sync_display

print_tmux_colors() {
    for i in {0..31}; do
        for j in {0..7}; do
            idx=$((j+i*8))
            printf "\x1b[38;5;${idx}m%-10s\x1b[0m" "colour${idx}"
        done
        printf "\n"
    done
}

# display how long it look to execute last command
record_last_command_time() {
	_wbk_last_command_time=${timer:-$SECONDS}
}

display_last_command_time() {
	if [[ -n "${_wbk_last_command_time}" ]]; then
		local elapsed=$(($SECONDS - ${_wbk_last_command_time}))
		export RPROMPT="%{$fg_nobold[white]%}last[${elapsed}s]%{$reset_color%}"
		_wbk_last_command_time=""
	fi
}

set_window_title() {
    printf '\033k%s\033\\' "$1"
}

change_title_to_pwd() {
    set_window_title "$(print -P "%~")"
}

change_title_to_command() {
    set_window_title "$1"
}

add-zsh-hook preexec record_last_command_time
add-zsh-hook preexec change_title_to_command
add-zsh-hook precmd display_last_command_time
add-zsh-hook precmd change_title_to_pwd

# pretty prompt to my liking
PROMPT="%{$fg_bold[yellow]%}%n%{$fg_bold[white]%}@%{$fg_bold[green]%}%M"
PROMPT="$PROMPT%{$fg_bold[white]%} %{$fg_bold[blue]%}%~ %{$fg_bold[white]%}\$ %{$reset_color%}"

# pretty git log
alias glog="git log --all --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"
alias grep="grep --color"
alias ls='ls --color'

if which vim > /dev/null; then
    export VISUAL=vim
    export EDITOR="$VISUAL"
fi

export PATH="$HOME/wbk/bin:$PATH"

# shift-tab auto-complete
bindkey '^[[Z' reverse-menu-complete
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# assume default DISPLAY if on WSL
if grep -qi Microsoft /proc/sys/kernel/osrelease 2> /dev/null; then
    export DISPLAY=:0
    bindkey '^R' history-incremental-search-backward
    umask 022
fi

# command not found handler
if [[ -f /etc/zsh_command_not_found ]]; then
    source /etc/zsh_command_not_found
fi

# Cygwin hax
if [[ "$(uname -o)" = "Cygwin" ]]; then
    export DISPLAY=:0
	export SHELLOPTS="igncr"
fi

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

if command -v tmux > /dev/null && [ -z "$TMUX" ]; then
    exec tmux attach-session -t default || exec tmux new-session -s default
fi
