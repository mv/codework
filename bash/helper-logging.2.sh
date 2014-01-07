
### Running from cron?
if [ -t 1 ]
then
    # cron: all output to logfile
    exec 1>> $logfile
    exec 2>> $logfile
fi

### helpers
touch $logfile
log() {

if [ -t 0 ]
then
  # cron: already sending to lofile
  echo "$( /bin/date +"%F_%H:%M:%S" ): $1"
else
    # terminal: show to me, baby
    echo "$( /bin/date +"%F_%H:%M:%S" ): $1" | tee -a $logfile
fi

}


