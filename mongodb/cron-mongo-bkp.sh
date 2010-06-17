#!/bin/bash
#
# Cron para mongodb: bkp + rsync + purgedir
#     de hora em hora
#         00 * * * * /abd/scripts/cron-mongo-bkp.sh
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2010/06

PATH=/abd/db/mongodb/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/sbin:/usr/sbin

# Log
LOG_DIR=/abd/logs/mongodb
LOG=${LOG_DIR}/${0##*/}.log
touch $LOG

[ "$1" != "-f" ] && {
    echo
    echo "Usage: $0 -f"
    echo
    echo "    Executa $0 via cron"
    echo "    Tarefas: bkp + rsync + purgedir "
    echo "    Log do script em [$LOG]."
    echo
    exit 1
}

### Setup
MAIL_TO="marcus.ferreira@abril.com.br"
SUBJECT="Cron: Bkp MongoDB"

APP_DIR=/abd/scripts
BKP_DIR=/abd/bkp/mongodb
NAS_DIR=/data/mongodb/dump

PID=/tmp/${0##*/}.pid
touch $PID

# Auto-rotate
size=$( /bin/ls -l $LOG | awk '{print $5}' ) # size bytes
[ $size -gt 5242880 ] && > $LOG              # 5000k, 5mb

### Caller via cron: redirect output globally
if ! tty -s
then exec 1>> $LOG
     exec 2>> $LOG
fi

log() {
    if tty -s
    then
        # caller via terminal: add to log explicitly
        echo "$( date '+%Y-%m-%d %H:%M:%S'): $0 $1" | tee -a $LOG
    else
        # caller via cron: no terminal output
        echo "$( date '+%Y-%m-%d %H:%M:%S'): $1"
    fi
}

email() {
    [ -z "$MAIL_TO" ] && return
    subject="$(hostname) - $SUBJECT - $1"

    mail -s "$subject" $MAIL_TO <<MAIL
From: no-reply@$(hostname)
To: $MAIL_TO
Subject: $subject

Log: $LOG

____________________________________________________________

$( cat -n $LOG | tail -15 )

____________________________________________________________
MAIL
}

check_pid() {
    # 2:pid, 8:cmd
    if ps -ef | awk '{ print $2,$8}' | grep -w `cat $PID` 2>/dev/null
    then
        log   "Process still running: $( cat $PID )"
        email "Process still running: $( cat $PID )"
        exit 0;
    fi

    echo $$ > $PID
    log "My pid: $PID: $$"
}

check_pid

log "BEGIN"

##########
## Commands here:

cd $APP_DIR

if $APP_DIR/mongo.bkp.sh -f
then
    log "Mongo bkp: SUCCESS"
else
    log "Mongo bkp: Error - verifique o log."
    exit 2
fi

if rsync -av --progress $BKP_DIR/  $NAS_DIR/ 1>> $LOG 2>> $LOG
then
    log "Mongo rsync: SUCCESS"
else
    log "Mongo rsync: Error - verifique o log."
    exit 3
fi

# Limpeza
### Local: limpa arquivos criados a mais de 15 dias, mantém pelo menos 120 arquivos
### NAS:   limpa arquivos criados a mais de 10 dias, mantém pelo menos 120 arquivos

$APP_DIR/purgedir.pl -d $BKP_DIR -k 120 -m 20 1>> $LOG 2>> $LOG
[ "$?" == "0" ] && ERR="$?"

$APP_DIR/purgedir.pl -d $NAS_DIR -k 120 -m 15 1>> $LOG 2>> $LOG
[ "$?" == "0" ] && ERR="$?"

##
###########

/bin/rm -f $PID
log "END"

if [ "$ERR" != "0" ]
then
    email "Error: $ERR"
    exit 1
else
   #email "Success"
    exit 0;
fi

# vim:ft=sh:

