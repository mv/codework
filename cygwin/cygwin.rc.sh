

alias explo='Explorer `cygpath -w $PWD`'
alias tpad='tpad.sh'
alias pset='svn pset svn:keywords Id '
alias pset2='svn pset svn:keywords "Id URL Date Author Rev"'

# Functions
# #########

# Some example functions
function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

function putty() {
    if [ -z "$1" ] 
    then
        echo 
        echo "Usage: putty user@host"
        echo
    else
        /c/usr/putty/0.60/putty -load default $1 &
    fi
}

