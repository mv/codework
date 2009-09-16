#!/bin/sh
# $Id: rc.orca 6 2006-09-10 15:35:16Z marcus $
#
# orca: Unix Performance collector tool
#
# by    Marcus Vinicius Ferreira (marcus@mvway.com)     Jan/2004
#

ORCA_HOME=/usr/local/orca
ORCA_VAR=/var/orca
ORCALLATOR=procallator

usage() {
cat >&1 <<CAT


    Usage: $0 <start|stop|restart>

CAT
exit 1
}

case "$1" in
    start)
	    if [ -x ${ORCA_HOME}/bin/${ORCALLATOR} ]
        then
            echo "ORCA statistics colector: ${ORCALLATOR}.pl "
            ${ORCA_HOME}/bin/${ORCALLATOR} &

            echo "ORCA daemon mode"
            ${ORCA_HOME}/bin/orca -d -v -l ${ORCA_VAR}/alert_orca.log \
                                  ${ORCA_HOME}/lib/${ORCALLATOR}.cfg
	    fi
	    ;;
    stop)
	    echo "Stoping procallator"
        /bin/killal ${ORCALLATOR}

	    echo "Stoping orca daemon"
        /bin/killal orca
	    ;;
    *)
        usage
esac

exit 0
