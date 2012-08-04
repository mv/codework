#!/bin/sh
#
# Ref: http://fedoraproject.org/wiki/Packaging:SysVInitScript
#
# <daemonname> <summary>
#
# chkconfig:   <default runlevel(s)> <start> <stop>
# description: <description, split multiple lines with \
#              a backslash>

# Source function library.
. /etc/rc.d/init.d/functions

# exec="/path/to/<daemonname>"
exec="/path/to/<daemonname>"

# prog="<service name>"
prog="<service name>"

# config="<path to major config file>"
config="<path to major config file>"

# user to run $prog
user="user name"

# logfile, if needed
logfile="/var/log/${user}/${prog}.log"

pidfile=/var/run/${prog}.pid
lockfile=/var/lock/subsys/$prog

# stop_timeout
#stop_timeout=10

# $OPTIONS defined in /etc/sysconfig/$prog
. /etc/sysconfig/$prog || true

start() {
    [ -x $exec   ] || exit 5
    [ -f $config ] || exit 6

    echo -n "Starting $prog: "

    ### Pick one:
  # daemon $exec $OPTIONS
  # daemon --pidfile=${pidfile} $exec $OPTIONS
  # daemon --user "$user" $exec $OPTIONS
  # daemon --user "$user" $exec $OPTIONS &

    retval=$?
    echo

    [ $retval -eq 0 ] && touch $lockfile && pidofproc $prog > $pidfile
    return $retval
}

stop() {
    echo -n "Stopping $prog: "

    ### Pick one:
  # killproc $prog
  # killproc -p ${pidfile} $prog
  # killproc -p ${pidfile} -t ${stop_timeout} -TERM $prog

    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile $pidfile
    return $retval
}

restart() {
    stop
    start
}

reload() {
    restart
}

force_reload() {
    restart
}

rh_status() {
    # run checks to determine if the service is running or use generic status
    status -p $pidfile $prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}


case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?

# vim:ft=sh:

