
ScriptVersion="1.0"

function usage() {
    cat <<- CAT

  Usage :  ${0##/*/} [options] [--]

  Options:
  -h|help       Display this message
  -v|version    Display script version

    CAT
    exit 1
}

### Handle command line arguments
while getopts ":hvf:" opt
do
    case $opt in

    f|file     )  file="$OPTARG"; ;;
    h|help     )  usage; exit 0   ;;
    v|version  )  echo "$0 -- Version $ScriptVersion"; exit 0   ;;

    \? )  echo -e "\n  Option does not exist : $OPTARG\n"
          usage; exit 1   ;;

    esac
done
shift $(($OPTIND-1))

