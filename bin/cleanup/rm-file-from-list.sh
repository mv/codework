#!/usr/bin/env bash
#
# ferreira.mv
# 2025-05-22
#

usage() {
    echo
    echo "Usage: $0 -l listname [-f] [-h]"
    echo
    echo "  -l: listname"
    echo "  -f: force"
    echo "  -h: help"
    exit 1
}

[ "${1}" == "" ] && usage

while getopts "l:fh" opt
do
  case $opt in
    l)
      _listname="${OPTARG}"
      ;;
    f)
      _force="true"
      ;;
    h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

# set -x

#
# Remaining arguments
#
shift $((OPTIND - 1))
if [ "${@}x" != "x" ]
then
  echo
  echo "Unknown argument: [${@}]"
  usage
fi

#
# sanity check
#
[ "${_listname}"  == "" ] && usage


### Do it
  red='\033[0;31m'
green='\033[0;32m'
   nc='\033[0m' # No Color

_kount=1
_qtd=$(grep -v '^[ ]*#|^[ ]*$' "${_listname}" | wc -l )

grep -v '^[ ]*#|^[ ]*$' "${_listname}" | while read f
do
    echo -n "Remove: [${_kount}/${_qtd}]: [${f}]: "

    if [ -f "${f}" ]
    then
      if [ "${_force}" == "true" ] 
      then /bin/rm -f "${f}"
           echo -e "${green}Done.${nc}"
      else echo -e "${green}Found.${nc}"
      fi
    else echo -e "${red}NOT_Found...${nc}"
    fi

    _kount=$((_kount+1)) 
done

exit 0
