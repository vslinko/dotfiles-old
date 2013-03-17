ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="steeef"
plugins=(brew coffee extract git history knife npm sublime)
source "$ZSH/oh-my-zsh.sh"

unsetopt correct_all
alias -r gaa="git add ."
alias -r gdh="git diff HEAD --"
hash -d q="$HOME/q"

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export EDITOR=nano
export LANG=en_US.UTF-8

if [ -d /usr/local/share/npm/bin ]; then
    export PATH=$PATH:/usr/local/share/npm/bin
fi

if [ -x /usr/local/bin/hub ]; then
    eval "$(hub alias -s)"
fi

if [ -d "$HOME/.rvm" ]; then
    export PATH="$PATH:$HOME/.rvm/bin"
    source "$HOME/.rvm/scripts/rvm"
fi
