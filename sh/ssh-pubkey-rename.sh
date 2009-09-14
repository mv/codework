#!/bin/bash
#
# ssh pub key rename
#
# Marcus Vinicius Ferreira                  ferreira.mv[ at ]gmail.com
# 2009/Jul
#

[ -z "$1" ] && {
    echo
    echo "Usage: $0 <pub_file>"
    echo
    exit 1
}

 keytype=$( awk '{print $1}' $1 )
filename=$( awk '{print $3}' $1 )

file="${filename}_${keytype}.pub"
echo
echo "Creating [$file] ..."
echo
/bin/cp "$1" ${file}

