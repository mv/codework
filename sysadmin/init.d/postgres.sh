#!/bin/bash
#
# $Id: rc.pgsql.sh 6 2006-09-10 15:35:16Z marcus $
# /etc/rc.d/rc.pgsql
#
# Start/stop/restart the pgsql
#
# To make pgsql start automatically at boot, make this
# file executable:  chmod 755 /etc/rc.d/rc.pgsql
#

PGHOME=/u01/app/pgsql/product/7.4.5
PGDATA=/u01/pgdata
PGLOG=/u01/app/pgsql/admin/ign/log/logfile

usage() {
cat >&1 <<CAT


    Usage: $0 <start|stop|restart>

CAT
exit 1
}

pgsql_start() {
    echo "Starting pgsql: $PGHOME"
    su - postgres -c \
    "$PGHOME/bin/pg_ctl start -w -s -D $PGDATA -l $PGLOG"
}

pgsql_stop() {
    echo "Stoping pgsql: $PGHOME"
    su - postgres -c \
    "$PGHOME/bin/pg_ctl stop -m fast -w -s -D $PGDATA -l $PGLOG"
    sleep 30
}

pgsql_restart() {
    pgsql_stop
    sleep 2
    pgsql_start
}

case "$1" in
    'start') pgsql_start
             ;;
     'stop') pgsql_stop
             ;;
  'restart') pgsql_restart
             ;;
          *) usage
             ;;
esac
