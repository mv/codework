# $Id: home.bashrc.sh 28 2004-10-14 19:44:08Z marcus $
#
# Postgres ~/.bashrc
#
# Created
#       Marcus Vinicius Ferreira    Out/2004

[ -e /etc/bash.bashrc ] && . /etc/bash.bashrc

alias cd..="cd .."
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

alias du="du -h"
alias ds="ds -h"
alias env="env | sort"

alias ls="ls -hF --color"
alias  l="ls"
alias la="ls -A"
alias ll="ls -l"

# alias acclog="tail -f /usr/www/logs/access_log"
# alias errlog="tail -f /usr/www/logs/error_log"

. ~postgres/bin/pgofa.sh
