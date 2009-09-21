
# PATH sample
PATH=/opt/csw/bin:opt/csw/sbin
PATH=$PATH:/opt/local/bin:/opt/local/sbin
PATH=$PATH:/usr/local/bin:/usr/local/sbin
PATH=$PATH:/usr/bin:/usr/sbin:/bin:/sbin

[ "$1" != "-f" ] && {
cat <<CAT

Usage: $0 -f

    usage here.....

CAT
exit 1
}


# Log
[ -z $LOG_DIR ] && LOG_DIR=/tmp
LOG=${LOG_DIR}/${0##*/}.log

# Auto-rotate, if log > 5Mb
size=$( /bin/ls -l $LOG | awk '{print $5}' ) # size bytes
[ $size -gt 5242880 ] && > $LOG              # 5000k, 5m

logmsg() {
    if tty -s
    then echo "$( date '+%Y-%m-%d %X'): $1" | tee -a $LOG
    else echo "$( date '+%Y-%m-%d %X'): $1" >> $LOG
    fi
}

# email
emailmsg() {
    subject="$(hostname) - $0"
    mail -s "$subject - $1" $MAIL_TO <<MAIL
From: no-reply@oracle
To: $MAIL_TO
Subject: $subject - $1

Log: $LOG
________________________________________________________________________

$( cat -n $LOG | tail -15 )
________________________________________________________________________

MAIL
}


