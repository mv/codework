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
# Process list
#
    _dt="$(date '+%F.%s')"
_result="md5.${_dt}.${_listname%.*}.result.txt"
  _dups="md5.${_dt}.${_listname%.*}.dups.csv"


  red='\033[0;31m'
green='\033[0;32m'
   nc='\033[0m' # No Color

_kount=1
_qtd=$(grep -v '^\s*#|^\s*$' "${_listname}" | wc -l | awk '{print $1}')

grep -v '^\s*#|^\s*$' "${_listname}" | while read _file
do

  echo -n "[${_kount}/${_qtd}] Path: [${_file}]: "
    
  _md5_file=$(md5sum "${_file}" | awk '{print $1}' ) # md5 of each file 
  _filename=${_file##*/}                             # file without path

  printf '     | | %s | %-80s | | %s\n' ${_md5_file} "${_file}"  "${_filename}" >> "${_result}"

  echo -e "${green}md5${nc}"
  _kount=$((_kount+1)) 

done

# header
echo 'seq | status | group | md5 | path | obs | file ' > "${_dups}"

# get dups/repetitions
awk -F"|" '{print $3}' "${_result}" | sort | uniq -d | \
while read _md5
do grep ${_md5}  "${_result}"
done | sort | cat -n >> "${_dups}"

# number of lines
_lines=$(wc -l "${_dups}" | awk '{print $1}' )
    
if [ "${_lines}" == "1" ]
then
  echo
  echo -e "Done: ${green}no duplicates. ${nc}"
  echo
else
  echo
  echo "Mac:      open ${_dups}"
  echo "Win:  explorer ${_dups}"
  echo
fi

exit 0
