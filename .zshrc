SAVEHIST=1000
HISTFILE=~/.zsh_history

bindkey -e

autoload -Uz compinit
compinit

autoload -U colors
colors

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/bin

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

function precmd {
    PROMPT="%{$fg[magenta]%}%n%{$reset_color%} at%{$fg[yellow]%} %m%{$reset_color%} in %{$fg_bold[green]%}%c%{$reset_color%}$(git_prompt_branch)$(git_prompt_status)
$(prompt_char) "
}
