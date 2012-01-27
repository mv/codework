#!/bin/bash
#
# mysql-dump-ddl.sh
#     routines only
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-01
#

[ -z "$1" ] && {

    echo
    echo "Usage: $0 db_name"
    echo
    echo "    routines only"
    echo
    echo "    Assumes ~/.my.cnf is configured:"
    echo "      [client]"
    echo "      username=root"
    echo "      password=root"
    echo
    exit 2
}

mysqldump \
    --quote-names         \
    --routines            \
    --triggers            \
    --no-create-db        \
    --no-create-info      \
    --no-data             \
    ${1} > ${1}_`/bin/date "+%Y-%m-%d-%H%M"`.ddl.sql


