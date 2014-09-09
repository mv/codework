#!/bin/bash
#
# swap-create.sh
#
# Marcus Vinicius Ferreira          ferreira.mv[ at ]gmail.com
# 2014-07
#

to_bytes() {
  echo "$1" \
  | sed 's/[gG]/ * 1024 M/;s/[mM]/ * 1024 K/;s/[kK]/ * 1024/; s/$/ +\\/; $a0' \
  | bc
}

as_file() {
  target="$1"
  size=$( to_bytes "$2" )

  /bin/dd if=/dev/zero of=${target} bs=1024 count=$(( ${size} / 1024 ))

  /bin/chown root:root ${target}
  /bin/chmod 0600      ${target}

  /sbin/mkswap ${target}
  /sbin/swapon ${target}
}

as_device() {
  target="$1"
  size=$( fdisk -l /dev/sdb | grep /dev/sdb | awk '{print $5}' )

  /bin/dd if=/dev/zero of=${target} bs=1024 count=$(( ${size} / 1024 ))

  /sbin/mkswap ${target}
  /sbin/swapon ${target}

  # $ fdisk -l /dev/sdb
  #
  # Disk /dev/sdb: 512 MiB, 536870912 bytes, 1048576 sectors
  # Units: sectors of 1 * 512 = 512 bytes
  # Sector size (logical/physical): 512 bytes / 512 bytes
  # I/O size (minimum/optimal): 512 bytes / 512 bytes
}

update_fstab() {
  # Avoid repetitions
  egrep -v "${target}" /etc/fstab > /tmp/fstab1

  # At the end, please
  printf "\n${target}  swap  swap  defaults  0 0\n" >> /tmp/fstab1

  # Rebuild
  egrep -v '^\s*#' /tmp/fstab1 | column -t > /etc/fstab
}

###
### swap-file.sh
###

function usage() {
  cat <<-CAT

  Usage :
    ${0##/*/} [-u] -d /path/to/device
    ${0##/*/} [-u] -f /path/to/file -s size

  Options:
    -u        update /etc/fstab
    -d        create from device
    -f        create as a file
    -s        size of file. Example: 512M, 1G, 2G.
    -h|help   Display this message

  Examples:
    $ ${0##/*/} -u -d /dev/sdb
    $ ${0##/*/} -u -f /swapfile1 -s 512M

CAT
    exit 1
}

### What
[ -z "$1" ] && usage

file=""
size=""
device=""
update=""

echo
while getopts ":huf:s:d:" opt
do
    case $opt in

        f|file)
            file="$OPTARG";
            echo "## Creating as a file: path [$file]"
            ;;

        s|size)
            size="$OPTARG";
            echo "## Creating as a file: size [$size]"
            ;;

        d|device)
            device="$OPTARG";
            echo "## Creating as a device: [$device]"
            ;;

        u|update)
            update="yes";
            echo "## Updating /etc/fstab: [yes]"
            ;;

        h|help)
            usage
            exit 0
            ;;

        *)
            echo -e "\n  Option does not exist : $OPTARG\n"
            usage
            ;;

    esac
done
shift $(($OPTIND-1))

echo

### How
set -o nounset  # Error on undefined variables
set -o errexit  # Exit on error

if [ -z "$file" -a -z "$device" ]; then usage ; fi
if [ -n "$file" -a -n "$device" ]; then usage ; fi

if [ -n "$file" -a -n "$size" ]
then
    as_file $file $size
elif [ -n "$device" ]
then
    as_device $device
else
    usage
fi

if [ -n "$update" ]
then
    update_fstab
fi

# vim:ft=sh:

