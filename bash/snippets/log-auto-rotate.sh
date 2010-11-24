
# Log
[ -d $LOG_DIR ] || LOG_DIR=/tmp
LOG=${LOG_DIR}/${0##*/}.log
touch $LOG

# Auto-rotate
size=$( /bin/ls -l $LOG | awk '{print $5}' ) # size bytes
[ $size -gt 5242880 ] && > $LOG              # 5000k, 5mb


