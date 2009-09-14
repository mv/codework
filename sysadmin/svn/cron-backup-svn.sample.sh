#!/bin/bash
# $Id$
#
# Subversion hot backup cron job
#
# Marcus Vinicius Ferreira      ferreira.mv[ at ]gmail.com
# Out/2006
#

PATH=/bin:/usr/bin:/u01/subversion/local/bin
 LOG=/tmp/${0##*/}.$$.log

usage() {
    cat <<CAT

    Usage: $0 -f

CAT
    exit 2
}

[ "$1" != "-f" ] && usage

touch $LOG
{
    # Env
        OPTIONS="--archive-type=bz2"
     REPOS_PATH="/u01/subversion/repos/db01"
    BACKUP_PATH="/u01/subversion/backup/repos"
       RUN_PATH="/u01/subversion/local/bin"

    # Main
    $RUN_PATH/hot-backup.py $OPTIONS $REPOS_PATH $BACKUP_PATH 2>&1
    ERR="$?"
} 2>&1 | tee $LOG

# Post
if [ "$ERR" != "0" ]
then

    fi
