
ScriptVersion="1.0"

function usage() {
    cat <<-CAT

  Usage :  ${0##/*/} [options] [--]

  Options:
  -h|help       Display this message
  -v|version    Display script version

CAT
    exit 1
}

### Handle command line arguments
[ -z "$1" ] && usage

while getopts ":hvf:" opt
do
    case $opt in

        f|file)

            file="$OPTARG";
            printf "\n  $0 ## File: [$file] \n\n"
            ;;

        h|help)
            usage
            exit 0
            ;;

        v|version)

            printf "\n  $0 ## Version [$ScriptVersion] \n\n"
            exit 0
            ;;

        *)

            echo -e "\n  Option does not exist : $OPTARG\n"
            usage
            ;;

    esac
done
shift $(($OPTIND-1))

