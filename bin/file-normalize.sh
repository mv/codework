#!/usr/bin/env bash
#
# ferreira.mv
# 2025-05-22
#

usage() {
    echo
    echo "Usage: $0 -l listname [-f] [-v] [-d] [-h]"
    echo
    echo "  -l: listname"
    echo "  -f: force"
    echo "  -v: verbose"
    echo "  -d: debug"
    echo "  -h: help"
    exit 1
}

[ "${1}" == "" ] && usage

while getopts "l:fvdh" opt
do
  case $opt in
    l) _listname="${OPTARG}"
      ;;
    f) _force="true"
      ;;
    v) _verbose="true"
      ;;
    d) _debug="true"
      ;;
    h) usage
      ;;
    *) usage
      ;;
  esac
done

# set -x

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
[ "${_listname}"  == "" ] && usage
[ ! -f "${_listname}"   ] && usage

#
#
_rename() {
  _src=$( echo "${1}" | sed -e 's|/$||' )  # dir: remove trailing '/'
  _dst="${2}"
  #  
  if [ "${_debug}" == "true" ]
  then
    echo
    echo
    echo "/bin/mv [${_src}]       [${_dst}__tmp]"  
    echo "/bin/mv [${_dst}__tmp]  [${_dst}]"       
    echo
  fi
  #
  if [ "${_force}" == "true" ]
  then
    if [ -f "${_src}" ] || [ -d "${_src}" ]
    then
      /bin/mv "${_src}"      "${_dst}__tmp"  
      /bin/mv "${_dst}__tmp" "${_dst}"       # Becaue of windows filesystem case insensitive...
      return 0
    else
      return 1
    fi
  fi
  #
}

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

### Prepare
_kount=1
_qtd=$(grep -v '^[ ]*#|^[ ]*$' "${_listname}" | wc -l )

### Do it
grep -v '^[ ]*#|^[ ]*$' "${_listname}" | while read f
do

    echo -n "Rename: [${_kount}/${_qtd}]: [${f}]: "
    
    if [ -f "${f}" ]
    then
      _fname="${f%.*}"    # file name, no extension
      _fext="${f##*.}"    # file extension
      _lext=".${_fext,,}" # lower
    else
      _fname=$( echo "${f}" | sed -e 's|/$||' )  # dir: remove trailing '/'
      _lext=""
    fi

    _spc=$( echo "${_fname}" | perl -pe 's/ +/_/g' )   # no [multiple] spaces
    _acc=$( echo "${_spc}"   | sed  -e  'y/āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙǕǗǙǛçÇãÃõÕ/aaaaeeeeiiiioooouuuuüüüüAAAAEEEEIIIIOOOOUUUUÜÜÜÜcCaAoO/' )  # translit accents
    
    _new="${_acc}${_lext}"

    # troubleshooting
    if [ "${_verbose}" == "true" ]  
    then
      echo
      echo -n -e "Rename: [${_kount}/${_qtd}]: [${cyn}${_new}${rst}]:"
    fi
    
    # action
    if _rename "${f}"   "${_new}"
    then 
      echo -e "${grn} Done.${rst}"      
      [ "${_verbose}" == "true" ]  && echo
    else 
      echo -e "${red} NOT FOUND.${rst}"
      [ "${_verbose}" == "true" ]  && echo
    fi

    _kount=$((_kount+1)) 
done

exit 0
