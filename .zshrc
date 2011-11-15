SAVEHIST=1000
HISTFILE=~/.zsh_history

bindkey -e

autoload -Uz compinit
compinit

autoload -U colors
colors

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/bin

EDITOR=nano

if [ $OSTYPE = 'linux-gnu' ]; then
    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
fi

function prompt_char {
    git branch &>/dev/null && echo '±' && return
    echo '○'
}

function git_prompt_branch {
    ref=$(git symbolic-ref HEAD 2>/dev/null) || return
    echo " on %{$fg[magenta]%}${ref#refs/heads/}%{$reset_color%}"
}

function git_prompt_status {
    index=$(git status --porcelain 2>/dev/null) || return
    [ $index ] && echo '?' && return
    echo '!'
}

function prompt_return_code {
     echo "%(?.. %{$fg[red]%}[%?]%{$reset_color%})"
}

function prompt_battery_status {
    battery=$(ioreg -n AppleSmartBattery -r | grep Capacity | grep -v Legacy | tr '\n' ' | ' | awk '{printf("%.0f", $6/$3 * 100)}')

    if [ $battery -lt 20 ]; then
        color="%{$fg[red]%}"
    elif [ $battery -lt 50 ]; then
        color="%{$fg[yellow]%}"
    else
        color="%{$fg[green]%}"
    fi

    filled=${(l:$(expr $battery / 10)::▸:)}
    empty=${(l:$(expr 10 - $battery / 10)::▹:)}

    echo $color$filled$empty"%{$reset_color%}"
}

if [ -x /usr/sbin/ioreg ]; then
    rprompt="$(prompt_battery_status)"
else
    rprompt=""
fi

function precmd {
    PROMPT="%{$fg[magenta]%}%n%{$reset_color%} at%{$fg[yellow]%} %m%{$reset_color%} in %{$fg_bold[green]%}%~%{$reset_color%}$(git_prompt_branch)$(git_prompt_status)$(prompt_return_code)
$(prompt_char) "
    RPROMPT="$rprompt"
}

function dotfiles {
    if [ $1 ]; then
        ssh "$1" "if [ -d .git ]; then git pull; else git clone -n https://github.com/vslinko/dotfiles.git && mv dotfiles/.git . && rm -r dotfiles && git reset --hard; fi"
    else
        git pull && source .zshrc
    fi
}
