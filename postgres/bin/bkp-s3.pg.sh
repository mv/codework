#!/bin/bash
#
# Dump from postgres to S3
#     Must be run using 'postgres' user
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-06
#

[ -z "$1" ] && {

    echo "Usage: $0 -f"
    echo
    echo "pg_dumpall to S3"
    echo
    exit 2

}

### Custom
mailto="mv@baby.com.br"
bucket="s3://us.backup.db/postgres"
    db="dinda_production"
   dir="/var/lib/postgresql/dump"

### Setup
PATH=/usr/bin:/bin:/usr/sbin:/sbin
file=${db}.dumpall.$( /bin/date '+%F-%H%M' ).sql.gz
 log="/tmp/${0##*/}.log"

### Main
echo "$(date '+%F %T'): BEGIN"
mkdir -p $dir

if pg_dumpall | gzip -c > ${dir}/${file}          2>>$log
then
    if s3cmd put ${dir}/${file} ${bucket}/${file} 2>>$log
    then
        MSG="Ok."
    else
        ERR="$?"
        MSG="Error: s3cmd [$ERR]"
    fi
else
    ERR="$?"
    MSG="Error: pg_dumpall [$ERR]"
fi

# Final
[ "$ERR" != "" ] && cat $log | mailx -s "DindaDB: $MSG" $mailto
/bin/rm -f $log

echo "$(date '+%F %T'): END"

# vim:ft=sh:

