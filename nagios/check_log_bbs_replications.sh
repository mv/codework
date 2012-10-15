#!/bin/bash
#
# check_replication.sh
#     Envia o dump da base do Brasigo para Stag01 para a replicacao
#
# Marcio Seiji                    mtakahasi[ at ]webcointernet[ dot ]com
# Fev/2009
#
# v2: parameter reuse: bbs and brasigo
# Marcus Vinicius Ferreira
# Set/2009

PATH=/opt/csw/bin:opt/csw/sbin
PATH=$PATH:/opt/local/bin:/opt/local/sbin
PATH=$PATH:/usr/local/bin:/usr/local/sbin
PATH=$PATH:/usr/bin:/usr/sbin:/bin:/sbin

[ "$1" != "-l" ] && {
cat <<CAT

Usage: $0 -l logpath

    Nagios: check bbs/brasigo d-1 replication for today

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
    echo "Replication D-1 OK - $TODAY"
    exit 0
else
    echo "Replication D-1 FAIL - $TODAY"
    exit 1
fi


