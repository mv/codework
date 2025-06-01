#!/usr/bin/env bash
#
# ferreira.mv
# 2025-05-22
#

usage() {
    echo
    echo "Usage: $0 -l listname [-v]"
    echo
    exit 1
}

[ "${1}" == "" ] && usage

while getopts "l:v" opt
do
  case $opt in
    l)
      _listname="${OPTARG}"
      ;;
    v)
      _verbose="true"
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


#
# coreutils: MacOS vs Linux
#
if which gstat 2>/dev/null
then alias stat=gstat
fi
# stat "${_dirname}"

#
# helpers
#
_msg() {
  if [ "${_verbose}" == "true" ] 
  then echo "## ${@}" 
  fi
}

_has_dir() {

  _path="${1}"
  for item in "${_path}"/*
  do
    _res=$( file "${item}" | grep directory )
    if [ "${_res}" != "" ]
    then 
      _msg "Item: [${_res}] "
      return 0  # has a dir, skip
    fi
  done
  return 1      # no dir, only files
}

#
# Process list
#
_dt="$(date '+%F.%s')"
_result="./md5.${_dt}.${_listname%.*}.result.txt"
_sorted="./md5.${_dt}.${_listname%.*}.sorted.txt"
_unique="./md5.${_dt}.${_listname%.*}.unique.txt"
_repeat="./md5.${_dt}.${_listname%.*}.repeat.txt"


  red='\033[0;31m'
green='\033[0;32m'
   nc='\033[0m' # No Color

# export IFS="\n" 
# for _dirname in $( "${_listname}" )
grep -v '^\s*#' "${_listname}" | while read _dirname
do

# echo -n "Path: [${_dirname}]: "
# if _has_dir "${_dirname}"
# then echo -e "${red}skip...${nc}"
#      continue
# else echo -e "${green}md5${nc}"
# fi
 
  echo -e "Path: [${_dirname}]: ${green}md5${nc}"
    
  # md5 of each file inside dir
  _md5_file=$(md5sum "${_dirname}"/* 2>/dev/null | awk '{print $1}' )   # keep hash, ignore file path

  # md5 'total' (if null: use epoch for md5 total for that dir)
# _md5_total=$( echo "${_md5_file:-$(date '+%s')}" | md5sum | awk '{print $1}')
#
  # md5 'total' (if null: use UUID for md5 total for that dir)
  _md5_total=$( echo "${_md5_file:-$(uuidgen)}" | md5sum | awk '{print $1}')

  echo "${_md5_total} | [${_dirname}]" >> "${_result}"
  
done

# get repetitions
sort "${_result}" > "${_sorted}"
awk '{print $1}' "${_sorted}" | uniq -d > "${_unique}"

# show repetitions
for _md5 in $(cat "${_unique}")
do grep "${_md5}" "${_sorted}" >> "${_repeat}"
done

echo
echo "Done: [${_repeat}]"
echo

exit 0
