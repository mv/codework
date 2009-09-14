# System-wide .bashrc file

alias ls='ls -AFh --color'
alias  l='ls'
alias la='ls -la'
alias ll='ls -l'

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

alias cd..="cd .."

alias df="df | grep cygdrive"

function dt(){

  /bin/date "+%Y-%m-%d_%H%M"

}

