#!/usr/bin/env bash
#
# ferreira.mv
# 2025-05-22
#

usage() {
    echo
    echo "Usage: $0 -s src_dir -d dst_dir [-n new_name] [-t] [-f] [-v]"
    echo
    echo "  -s: source dir"
    echo "  -d: destination root dir"
    echo "  -n: set new name. (Assumes -t)"
    echo "  -t: set timestamp in filename"
    echo "  -f: force"
    echo "  -v: verbose"
    echo
    exit 1
}

[ "${1}" == "" ] && usage

while getopts "s:d:n:tfv" opt
do
  case $opt in
    s) _srcdir=$( echo "${OPTARG}" | sed -e 's|/$||' )  # dir: remove trailing '/'
      ;;
    d) _dstdir=$( echo "${OPTARG}" | sed -e 's|/$||' )  # dir: remove trailing '/'
      ;;
    n) _newname="${OPTARG}"
      ;;
    t) _timestamp="true"
      ;;
    f) _force="true"
      ;;
    v) _verbose="true"
      ;;
    *) usage
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
[ "${_srcdir}"  == "" ] && usage
[ "${_dstdir}"  == "" ] && usage

# coreutils: MacOS vs Linux
which gstat  2>/dev/null && alias stat="gstat"
which gcp    2>/dev/null && alias cp="gcp"
which gtouch 2>/dev/null && alias touch="gtouch"

## Black        0;30     Dark Gray     1;30
## Red          0;31     Light Red     1;31
## Green        0;32     Light Green   1;32
## Brown/Orange 0;33     Yellow        1;33
## Blue         0;34     Light Blue    1;34
## Purple       0;35     Light Purple  1;35
## Cyan         0;36     Light Cyan    1;36
## Light Gray   0;37     White         1;37
  gry='\033[1;30m'
  red='\033[1;31m'
  grn='\033[1;32m'
  ylw='\033[1;33m'
  blu='\033[1;34m'
  prp='\033[1;35m'
  cyn='\033[1;36m'
  wht='\033[1;37m'
  rst='\033[0m' # No Color

#
#
### Prepare
_kount=1
_qtd=$(/bin/ls -l "${_srcdir}"/* | wc -l | tr -d ' ')


for f in "${_srcdir}"/*
do
  # album is a dir named by date
# _dtdir=$(  stat -x -t '%F'          "${f}" | grep Modify | awk -F': ' '{print $2}' )
# _dtdir=$(  stat --format '%y' "${f}" | awk '{print $1}' )

# _dtfile=$( stat -x -t '%F_%H-%M-%S' "${f}" | grep Modify | awk -F': ' '{print $2}' )
  _dtfile=$( stat --format '%y' "${f}" | awk -F'.' '{print $1}' | tr ' ' "_" | tr ':' "-")
  _dtdir=$(  echo "${_dtfile}" | awk -F'_' '{print $1}' )

  _bname="${f##*/}"     # basename
  _fname="${_bname%.*}" # file name, no extension
  _fext="${_bname##*.}" # file extension
  _lext=".${_fext,,}"   # lower

  _dst="${_dstdir}/${_dtdir}"   # destination
  _new="${_dst}/${_bname}"      # new name

  if [ "${_timestamp}" == "true" ]
  then
    _new="${_dst}/${_fname}.${_dtfile}${_lext}"   # new name + timestamp
  fi

  if [ "${_newname}" != "" ]
  then
    _new="${_dst}/${_newname}.${_dtfile}${_lext}" # new name using '-n'
  fi

  echo -n "File: [${_kount}/${_qtd}]: [${f}]"

  if [ "${_verbose}" == "true" ]
  then
    echo
    echo -e -n "File: [${_kount}/${_qtd}]: [${cyn}${_new}${rst}]"
  fi

  if [ "${_force}" == "true" ]
  then
    [ -d "${_dst}" ] || mkdir -p "${_dst}"

    /bin/cp -f "${f}"  "${_new}"
    touch   -r "${f}"  "${_new}"

    echo -n -e "${grn} Done.${rst}"
  fi

  [ "${_verbose}" == "true" ] && echo

  _kount=$((_kount+1))
  echo
done

exit 0
