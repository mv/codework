#!/bin/sh
#
# zookeeper
#
# Author:	Marcus Vinicius Ferreira,   <ferreira.mv@gmail.com>
#
# chkconfig:    2345 98 02
# description:  Zookeeper is a high-performance coordination service for
#               distributed applications
# processname:  monit
# pidfile:      /var/run/monit.pid
# config:       /etc/zookeeper/zoo.cfg

# Source function library.
. /etc/rc.d/init.d/functions


#
# my service
#
prog="zookeeper"
exec="/usr/bin/zookeeper.sh"
user="zkeeper"
pid="/var/lib/${prog}/${prog}.pid"

syscfg="/etc/sysconfig/${prog}"

#
# my helpers
#
endnow() {
  echo "$1" && exit 1
}

sig() {
  test -s "${pid}" && kill -${1} `cat ${pid}` 2>/dev/null
}


###
### functions!
###

f_start() {
    # sanity check
    [ -f ${exec} ] || endnow "Cannot find prog: [${prog}]"

    # # Source 'prog' configuration.
    # if [ -f /etc/sysconfig/${prog} ]
    # then . /etc/sysconfig/${prog}
    # fi

    sig 0 && echo "${prog}: Already running" && exit 0

    echo
    echo -n "Starting ${prog}: "

    runuser $user -m -s /bin/bash \
    -c "${exec} -c ${syscfg} -p ${pid} start" # 2>&1 > /dev/null &
    RETVAL=$?
    if [ $RETVAL = 0 ]
    then
        echo_success
        touch /var/lock/subsys/${prog}
    else
        echo_failure
    fi
    echo
}

f_stop() {
    echo
    echo -n "Stopping ${prog}: "

    runuser $user -m -s /bin/bash \
    -c "${exec} -c ${syscfg} -p ${pid} stop" # 2>&1 > /dev/null &
    RETVAL=$?
    if [ $RETVAL = 0 ]
    then
        echo_success
        rm -f /var/lock/subsys/${prog}
    else
        echo_failure
    fi
    echo
}

f_restart() {
    f_stop
    f_start
}

f_condrestart() {
    if [ -e /var/lock/subsys/${prog} ]
    then
        f_restart
    else
        echo "Not started: ${prog}"
    fi
}

f_status() {
    status -p ${pid} ${prog}
}

###
### Do it.
###

case "$1" in
    start|stop|restart|condrestart|status)
        f_${1}
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|condrestart|status}"
        exit 1
esac

# vim:ft=sh:

