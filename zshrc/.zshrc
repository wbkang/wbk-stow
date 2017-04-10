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

add-zsh-hook preexec record_last_command_time
add-zsh-hook precmd display_last_command_time

# pretty prompt to my liking
PROMPT="%{$fg_bold[yellow]%}%n%{$fg_bold[white]%}@%{$fg_bold[green]%}%M"
PROMPT="$PROMPT%{$fg_bold[white]%} %{$fg_bold[blue]%}%~ %{$fg_bold[white]%}\$ %{$reset_color%}"

# pretty git log
alias glog="git log --all --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"

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

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi
