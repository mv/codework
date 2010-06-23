#!/bin/bash
#
# check_mongo_bkp.sh
#     Verifica backup do mongodb
#
# Marcus Vinicius Ferreira
# Jun/2010

PATH=/opt/csw/bin:opt/csw/sbin
PATH=$PATH:/opt/local/bin:/opt/local/sbin
PATH=$PATH:/usr/local/bin:/usr/local/sbin
PATH=$PATH:/usr/bin:/usr/sbin:/bin:/sbin

[ "$1" != "-l" ] && {
cat <<CAT

Usage: $0 -l logpath

    Nagios: Verifica backup do mongodb.

CAT
exit 4
}

TODAY=`date '+%Y-%m-%d'`
 FILE="$2"

if [ ! -f "$FILE" ]
then
    echo "Logfile [$FILE] not found."
    exit 5
fi

if grep -i "$TODAY" "$FILE" | grep -i Success > /dev/null
then
    echo "Mongo Backup OK - $TODAY"
    exit 0
else
    echo "Mongo Backup FAIL - $TODAY"
    exit 1
fi

# vim:ft=sh:

