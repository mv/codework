#!/bin/bash
#
# mysql-dump-ddl.sh
#     ddl only
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-01
#

[ -z "$1" ] && {

    echo
    echo "Usage: $0 db_name"
    echo
    echo "    ddl only"
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
    --no-data             \
    --routines            \
    --triggers            \
    --skip-add-drop-table \
    ${1} > ${1}_`/bin/date "+%Y-%m-%d-%H%M"`.ddl.sql


