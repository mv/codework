
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


