#!/bin/bash
#
# $Id: pgsql.sh 6 2006-09-10 15:35:16Z marcus $
#

# PostGreSQL Variables
PGDATA=/usr/local/pgsql/data            # Default para initdb
PGHOME=/usr/local/pgsql                 # MVF
 PGLOG=/usr/local/pgsql/log/logfile     # MVF

PGDATABASE=manesco_01                   # MVF
PGHOST=localhost
PGPORT=5432
PGUSER=manesco
PGPASSWORD=manesco
PGOPTIONS="-i"
PGTTY=""

export PGDATABASE PGHOST PGUSER PGPASSWORD PGOPTIONS PGTTY

           PATH=/usr/local/pgsql/bin:$PATH
        MANPATH=/usr/local/pgsql/man:$MANPATH
LD_LIBRARY_PATH=/usr/local/pgsql/lib:$LD_LIBRARY_PATH

export PGHOME PGDATA PGLOG
export PATH MANPATH LD_LIBRARY_PATH

LANG="en_US.UTF-8"
SUPPORTED="en_US.UTF-8:en_US:en"
#SYSFONT="latarcyrheb-sun16"
export LANG SUPPORTED # SYSFONT LC_ALL LC_CTYPE LC_COLLATE LC_NUMERIC LC_CTYPE LC_TIME

alias pgdata="cd $PGDATA"
alias pghome="cd $PGHOME"
alias pglog="tail -f $PGLOG"

