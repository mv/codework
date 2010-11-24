
PID=/tmp/${0##*/}.pid

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


