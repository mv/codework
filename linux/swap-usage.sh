#!/bin/bash
#
# Linux: processes using swap space
#
# Marcus Vinicius Ferreira            [ferreira.mv at gmail.com]
# 2013-04
#

declare -i sum=0
declare -i total=0

echo "PID    Swapped     Command"
echo "------ ----------- -------"

ps -e -o pid,command | while read pid prog
do

    # sum all swapped pages
    for swap in $( awk '/Swap/ {print $2}' /proc/${pid}/smaps 2>/dev/null )
    do let sum=${sum}+${swap}
    done

    # swapped?
    if (( ${sum} > 0 ))
    then
        printf "%6d %8d KB [%s]\n" $pid $sum "${prog:0:50}"
    fi

    let total=${total}+${sum}
    let sum=0
done

# echo total=${total}+${sum}
# printf "\nOverall swap used: %d KB\n\n" ${total}

# vim:ft=sh:

