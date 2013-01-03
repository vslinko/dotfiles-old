ZSH=$HOME/.oh-my-zsh
ZSH_THEME="af-magic"
plugins=(history brew npm composer gem git git-flow node symfony2 sublime)
source $ZSH/oh-my-zsh.sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/bin
export EDITOR=nano
export LANG=en_US.UTF-8

if [ -x /usr/local/bin/brew ]; then
    prefix=$(brew --prefix php54)
    if [ $? -eq 0 ]; then
        export PATH=$(brew --prefix php54)/bin:$PATH
    fi
    prefix=$(brew --prefix node)
    if [ $? -eq 0 ]; then
        export PATH=/usr/local/share/npm/bin:$PATH
    fi
fi

unalias c
alias -r gaa='git add .'
alias -r www='sudo -u www-data'
hash -d c=$HOME/Code

_cap () {
    compadd $(cap -vT 2>/dev/null | grep '^cap' | cut -d ' ' -f 2)
}

compdef _cap cap
