# User dependent .bashrc file

# See man bash for more options...
  # Don't wait for job termination notification
  # set -o notify

  # Don't use ^D to exit
  # set -o ignoreeof

  # Don't put duplicate lines in the history.
  # export HISTCONTROL=ignoredups

# Some example alias instructions
# alias less='less -r'
# alias rm='rm -i'
# alias whence='type -a'
# alias ls='ls -F --color=tty'
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'
# alias la='ls -A'
# alias l='ls -CF'

# Some example functions
# function settitle() { echo -n "^[]2;$@^G^[]1;$@^G"; }

function svnpset()
{
    [ "$1" = "" ] && return
    svn pset svn:keywords "Id Author HeadURL LastChangedBy" "$@"
}

function tpad()
{
    textpad $1 &
}

function tst()
{
    [ "$1" = "" ] && return
    echo "$@"
}


