#!/bin/sh
#
# zookeeper.sh
#
# Author:	Marcus Vinicius Ferreira,   <ferreira.mv@gmail.com>
#


###
### defaults
###
user="zookeep"
prog="zookeeper"
pid="/tmp/${prog}.pid"
syscfg="/etc/sysconfig/${prog}"


###
### script options
###
usage() {
    echo
    echo "Usage: $0 [-p pidfile] [-c sysconfigfile] start|stop|restart|status"
    echo
    echo "    sysconfigfile: '/etc/sysconfig/file' or similar containing"
    echo "                   environment variables to be used by this start/stop"
    echo "                   script."
    echo
    exit 1
}

[ -z "$1" ] && usage

while [ "$1" != "" ]
do
    case "$1" in
        start|stop|restart|status)
            action="f_${1}"
            shift
            ;;
        -c)
            syscfg="$2"
            shift 2
            ;;
        -p)
            pid="$2"
            shift 2
            ;;
        *)
            usage
    esac
done

if [ ! -f ${syscfg} ]
then
    logger -i -t $0 "sysconfigfile: NOT FOUND: [$syscfg]"
    exit 2
fi

#
# my helpers
#
endnow() {
  echo "$1" && exit 1
}

sig() {
  test -s "${pid}" && kill -${1} `cat ${pid}` 2>/dev/null
}

log() {
  logger -i -t $0 "$@"
}

###
### Specifics
###

source $syscfg

jmx_check() {
    # See the following page for extensive details on setting
    # up the JVM to accept JMX remote management:
    # http://java.sun.com/javase/6/docs/technotes/guides/management/agent.html
    # by default we allow local JMX connections
    if [ "${JMXLOCALONLY}" = "" ]
    then JMXLOCALONLY=false
    fi

    if [ "${JMXDISABLE}" = "" ]
    then
        logger -i -t $0 "JMX enabled by default"
        # for some reason these two options are necessary on jdk6 onbuzz Ubuntu
        #   accord to the docs they are not necessary, but otw jconsole cannot
        #   do a local attach
        jmx="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=$JMXLOCALONLY"
    else
        logger -i -t $0 "JMX disabled by user request"
        jmx=""
    fi
}

if [ "${SERVER_JVMFLAGS}"  != "" ]
then
    JVMFLAGS="$SERVER_JVMFLAGS $JVMFLAGS"
fi

main="org.apache.zookeeper.server.quorum.QuorumPeerMain"
defs="-Dzookeeper.log.dir=${ZOO_LOG_DIR} -Dzookeeper.root.logger=${ZOO_LOG4J_PROP}"
cmdl="${defs} -cp ${CLASSPATH} ${JVMFLAGS} ${jmx} ${main} ${ZOO_CFG}"


###
### Tasks
###

f_start() {

    sig 0 && echo "Already running" && exit 0

    logger -i -t $0 "Starting ${prog}. "
    if ! touch ${pid}
    then
        logger -i -t $0 "pidfile: CANNOT CREATE: [$pid]"
        exit 3
    fi

    logger -i -t $0 "java ${cmdl}"

    jmx_check

    # scenario 1: java program is a deamon
    #echo $$ > ${pid}
    #exec 2>&1 java $cmdl 1>/tmp/${prog}.out

    # scenario 2: java program does not daemonize by itself
    java $cmdl 2>&1>/tmp/${prog}.out &
    echo $! > ${pid}


}

f_stop() {
    if sig 0
    then
        log "Stopping... "
        sig TERM && log "Stop OK."
    else
        log "Stopped."
        /bin/rm -f ${pid}
        exit 0
    fi

    # just in case
    log "Sleeping..."
    sleep 2
    f_stop
}

f_restart() {
    f_stop
    f_start
}

f_status() {

    if [ ! -f ${pid} ]
    then
        echo "Pidfile does not exist: [${pid}]"
        exit
    fi

    if sig 0
    then
        echo "${prog} is running with pid: [$(cat ${pid})]"
    else
        echo "${prog} error: cannot find process."
    fi
}


###
### Main
###

# echo "action: [$action]"
# echo "syscfg: [$syscfg]"
# echo "   pid: [$pid]"

$action


# vim:ft=sh:

