#!/bin/bash
#
# check_mongo_rsync.sh
#     Verifica arquivos de backup recebidos de prod
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

    Nagios: Verifica arquivos de backup recebidos de prod.

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
    echo "Mongo RSYNC OK - $TODAY"
    exit 0
else
    echo "Mongo RSYNC FAIL - $TODAY"
    exit 1
fi

# vim:ft=sh:

