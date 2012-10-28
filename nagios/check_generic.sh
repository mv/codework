#!/bin/sh
#
# Nagios: template script
#
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-10
#


###
###
###
   NAME="check_generic"
VERSION="0.1"

usage() {

    cat<<CAT

  Usage: $0 -H host -u url -w warning -c critical

    Options:
      -H host     host/ip to check
      -u uri      uri path component
      -w warning  warning threshold
      -c critical critical threshold

CAT
    exit 0
}

###
### Parameters
###

[ -z "$1" ] && usage

while getopts ":H:u:w:c:" opt; do
  case "$opt" in
    h)   usage ;;
    H)   host=$OPTARG     ;;
    u)   url=$OPTARG      ;;
    w)   warning=$OPTARG  ;;
    c)   critical=$OPTARG ;;
    v)   echo "$NAME version $VERSION"
         exit 0
         ;;
    :)   echo "Error: -$option requires an argument"
         usage
         exit 1
         ;;
   \?)   usage
         exit 1
         ;;
  esac
done

[ -z "$host" ] && { echo "Host must be informed." ; exit 0 }
[ -z "$url"  ] && { echo "URL  must be informed." ; exit 0 }

# Nagios/Icinga API convention
EXIT_OK=0
EXIT_WARNING=1
EXIT_CRITICAL=2
EXIT_UNKNOWN=3

exit 99

###
### Command processing
###

result=$( echo /usr/bin/cmd  ; return 0 )
if [ "$?" != "0" ]
then
    echo "Could not process command."
    exit $EXIT_UNKNOWN
fi


###
### Alarm logic
###

if [ $result -lt $critical ]
then
    echo "OK: message critical."
    exit $EXIT_CRITICAL
elif [ $result -lt $warning ]
then
    echo "OK: message warning."
    exit $EXIT_WARNING
else
    echo "OK: message ok."
    exit $EXIT_OK
fi


# vim:ft=sh

