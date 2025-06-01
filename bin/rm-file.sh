#!/usr/bin/env bash
#
# ferreira.mv
# 2025-05-22
#

usage() {
    echo
    echo "Usage: $0 file(s)"
    echo
    exit 1
}

[ "${1}" == "" ] && usage


### Do it
  red='\033[0;31m'
green='\033[0;32m'
   nc='\033[0m' # No Color

_kount=1

for f in "${@}"
do
    echo
    echo "Remove: ${_kount}: [${f}]: "
    
#   find . -type d -name "${f}" -exec /bin/rm -f "${f}" \;
    find . -type f -name "${f}" -exec /bin/ls -1  {} \; -exec /bin/rm -f {} \;
    
    _kount=$((_kount+1)) 
done

exit 0
