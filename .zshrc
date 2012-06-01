HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=10000

bindkey -e

autoload -Uz compinit
compinit

autoload -U colors
colors

# Variables
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/.pear/bin
EDITOR=nano

# Aliases
if [ $OSTYPE = 'linux-gnu' ]; then
    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
fi

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias www='sudo -u www-data'

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

CODE_DIR=~/Code
function c {
    [ -d $CODE_DIR/$1 ] && cd $CODE_DIR/$1
}

function c_comp {
    old=$(pwd)
    cd $CODE_DIR
    reply=($(ls -d */ | sed 's/\/$//'))
    cd $old
}
compctl -K c_comp c

_symfony2_get_command_list () {
    app/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
    if [ -f app/console ]; then
        compadd $(_symfony2_get_command_list)
    fi
}

compdef _symfony2 app/console

. ~/.zsh_prompt
