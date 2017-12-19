
if [[ -d ~/antigen ]]; then
    source ~/antigen/antigen.zsh
    antigen bundle git
    antigen bundle pip
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle ssh-agent

    if [[ "$(uname -o)" = "Cygwin" ]]; then
        antigen bundle cygwin
    fi
    antigen apply
fi

autoload -U add-zsh-hook
autoload -U colors && colors
autoload -U compinit && compinit

# auto-complete case-insensitive, hyphen insensitive
# partial-word matching. Copied from OMZ
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# highlight autocomplete menu
zstyle ':completion:*' menu select
# show info messages during autocomplete
zstyle ':completion:*' verbose yes
zstyle ':completion:*:messages' format "$fg_bold[white]%d$reset_color"
zstyle ':completion:*:warnings' format "$fg_bold[red]No match: $reset_color%d"
zstyle ':completion:*:descriptions' format "$fg_bold[yellow]# %d%b$reset_color"
zstyle ':completion:*:corrections' format "$fg_bold[magenta]%B: $reset_color%d (errors: %e)%b"
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''

# ignore completion functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# pushd on cd
setopt AUTO_PUSHD

# save history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTDUPE=erase
setopt hist_ignore_dups
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt extendedhistory

# extended glob
setopt extended_glob

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
    printf '\033]2;%s\007' "$1" 
}

change_title_to_pwd() {
    set_window_title "$(print -P "%25<...<%~%<<")"
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
PROMPT="$PROMPT%{$fg_bold[white]%} %{$fg_bold[blue]%}%~ %{$fg_bold[cyan]%}[%!] %{$fg_bold[white]%}%# %{$reset_color%}"

# pretty git log
alias glog="git log --all --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"
alias grep="grep --color"
alias ls='ls --color'
alias gitk='gitk --all &!'

if ! command -v vi > /dev/null && command -v vim > /dev/null; then
    alias vi=vim
fi

# make gui applications easier to use
gui() {
    "$@" > "/tmp/gui.$(basename $1).$$.log" 2>&1 &
}

# shift+tab to go back
bindkey '^[[Z' reverse-menu-complete

# fix delete on gentoo
bindkey "\x1b\x5b\x33\x7e" delete-char

if which vim > /dev/null; then
    export VISUAL=vim
    export EDITOR="$VISUAL"
fi

export PATH="$HOME/wbk/bin:$PATH"

# shift-tab auto-complete
bindkey '^[[Z' reverse-menu-complete
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# tmux+zsh hax
bindkey '^R' history-incremental-search-backward

# assume default DISPLAY if on WSL
if grep -qi Microsoft /proc/sys/kernel/osrelease 2> /dev/null; then
    export DISPLAY=localhost:0
    bindkey '^R' history-incremental-search-backward
    umask 022
    # Docker on Windows host
    export DOCKER_HOST=tcp://127.0.0.1:2375
fi

# command not found handler
if [[ -f /etc/zsh_command_not_found ]]; then
    source /etc/zsh_command_not_found
fi

# Cygwin hax
if [[ "$(uname -o)" = "Cygwin" ]]; then
    export DISPLAY=localhost:0
	export SHELLOPTS="igncr"
fi

# antigen install
install_antigen() {
    git clone https://github.com/zsh-users/antigen.git ~/antigen
}

# ctrl+left right to move between words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# remove the stupid suspend
stty stop '^-'
# stop rogue apps from changing stty
ttyctl -f

# reload all of my zsh
trap "echo Reloading zsh; exec zsh" USR1

reload_all_zsh() {
    pkill -U $USER --signal USR1 zsh
}

if [[ -f "$HOME/.cargo/env" ]]; then
    source ~/.cargo/env
fi

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

alias install_vundle="git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
