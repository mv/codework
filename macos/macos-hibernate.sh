#!/bin/bash
#
#

uname -s | grep -i darwin || {
    echo
    echo "MacOS only"
    echo
    exit 1
}

case "${1}" in
    on) 
        sudo pmset -a hibernatemode 1
        echo Hibernate mode on.
        ;;

    off) 
        sudo pmset -a hibernatemode 0
        echo Hibernate mode off.
        ;;

    *) 
        echo "[$1]: not defined."
        ;;
esac


