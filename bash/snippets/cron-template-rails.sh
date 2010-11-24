#!/bin/bash
#
# FTP Mirror para arquivos XML da punch
#     de minuto em minuto:
#         * * * * * /path/cron-ftp-punch-xml.sh -f
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2010/05

[ "$1" != "-f" ] && {
    echo
    echo "Usage: $0 -f"
    echo
    echo "    Executa $0 via cron"
    echo
    exit 1
}

### Setup
MAIL_TO=""
SUBJECT=""

APP_DIR=/abd/app/bra2010
LOG_DIR=/abd/logs/bra2010

PID=/tmp/${0##*/}.pid
touch $PID

# Log
[ -d $LOG_DIR ] || LOG_DIR=/tmp
LOG=${LOG_DIR}/${0##*/}.log
touch $LOG

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
        echo "$( date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a $LOG
    else
        # caller via cron: this output is already redirected
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

#    cd /abd/app/xxx/current && \
#    rake utils:generate:sitemap RAILS_ENV=production \
#    1>> $LOG 2>> $LOG

cd $APP_DIR/current && \
    php  
    1>> $LOG 2>> $LOG

for file in /work/leslie/*txt
do
    log $file
    php from-the-hell $file
    log "php: END"
done


ERR="$?"
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

