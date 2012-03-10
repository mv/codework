# $Id: home.profile.sh 28 2004-10-14 19:44:08Z marcus $
#
# Postgres ~/.profile
#
# Created
#       Marcus Vinicius Ferreira    Out/2004

[ -e /etc/bash.bashrc ] && . /etc/bash.bashrc
[ -e ~/.bashrc  ]       && . ~/.bashrc
[ -d ~/bin ]            && export PATH=~/bin:$PATH

EDITOR=vi
PAGER=less
export EDITOR PAGER

umask 022
ulimit -c 0     # No core dumps

# Enviroment
. ~postgres/bin/pgenv.sh
. ~postgres/bin/pgalias.sh
