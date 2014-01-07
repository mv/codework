
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

