#!/bin/bash
#
# mongo.bkp.sh
#     bkp mongo db
#
# Marcus Vinicius Ferreira                  ferreira.mv[ at ]gmail.compression
# 2010/06
#

PATH=/abd/db/mongodb/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/sbin:/usr/sbin

BKP_DIR=/abd/bkp/mongodb/
LOG_DIR=/abd/logs/mongodb/

# Log
[ -d $LOG_DIR ] || LOG_DIR=/tmp
LOG=${LOG_DIR}/${0##*/}.log
touch $LOG

[ "$1" != "-f" ] && {
    echo
    echo "Usage: $0 -f"
    echo
    echo '    Backup do mongo db no format ${hostname}.mongo.${dt}.dump.tar.gz'
    echo "    no diretorio [$BKP_DIR]."
    echo "    Log do script em [$LOG]."
    echo
    exit 1
}

LISTEN_IP=`ifconfig -a | grep inet | egrep "172.16.202" | head -1 | awk '{print $2}' | awk -F: '{print $2}'`
[ -z $LISTEN_IP ] && LISTEN_IP=127.0.0.1

HOSTNAME=`hostname`
    HOST=${HOSTNAME%%.*}
      DT=`date  "+%Y-%m-%d_%H%M"`
    DUMP=${HOST}.mongo.${DT}.dump
    FILE=${DUMP}.tar.gz

# Auto-rotate log
size=$( /bin/ls -l $LOG | awk '{print $5}' ) # size bytes
[ $size -gt 5242880 ] && > $LOG              # 5000k, 5mb

log() {
    if tty -s
    then
        # caller via terminal: add to log explicitly
        echo "$( date '+%Y-%m-%d %H:%M:%S'): $0 $1" | tee -a $LOG
    else
        # caller via cron: no output to terminal
        echo "$( date '+%Y-%m-%d %H:%M:%S'): $1" >> $LOG
    fi
}


cd $BKP_DIR
log "BEGIN"

if mongodump --host $LISTEN_IP --out ${HOST}.mongo.${DT}.dump 2>&1 >>$LOG
then
    log "Dump SUCCESS"
else
    log "Dump Error - verifique o log"
    exit 2
fi

if tar cfz $FILE $DUMP 2>&1 >>$LOG
then
    /bin/rm -rf $DUMP
    /bin/rm -f  current.tar.gz
    ln -s $FILE current.tar.gz
    log "Backup SUCCESS"
else
    log "Backup Error - verifique o log"
    exit 3
fi

log "END"

# vim:ft=sh:


