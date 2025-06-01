#!/usr/bin/env bash


[ "${1}" == "" ] && {
    echo
    echo "Usage: $0  resultfile.txt"
    echo
    exit 1
}

while true
do
    echo
    date

    time awk '{print $3}' "${1}" | sort | uniq -d | \
    while read x
    do grep $x  "${1}" | sort
    done | cat -n
    
    echo
    date
    echo

    sleep 30

done
