SAVEHIST=1000
HISTFILE=~/.zsh_history

bindkey -e

autoload -Uz compinit
compinit

autoload -U colors
colors

# Variables
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/bin
EDITOR=nano

# Aliases
if [ $OSTYPE = 'linux-gnu' ]; then
    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
fi

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# Functions
function dotfiles {
    if [ $1 ]; then
        ssh "$1" "if [ -d .git ]; then git pull; else git clone -n https://github.com/vslinko/dotfiles.git && mv dotfiles/.git . && rm -r dotfiles && git reset --hard; fi"
    else
        old=$(pwd)
        cd
        git pull && source .zshrc
        cd "$old"
    fi
}

if [ -d ~/Code ]; then
    function c {
        cd ~/Code/$1
    }
fi

. ~/.zsh_todo

# PROMPT
. ~/.zsh_prompt
