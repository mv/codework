#!/bin/bash
#
# mysql-dump.sh
#     default: ddl + data
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-01
#

[ -z "$1" ] && {

    echo
    echo "Usage: $0 db_name"
    echo
    echo "    mysqldump ddl + data"
    echo
    echo "    Assumes ~/.my.cnf is configured:"
    echo "      [client]"
    echo "      username=root"
    echo "      password=root"
    echo
    exit 2
}

mysqldump \
    --flush-logs        \
    --hex-blob          \
    --quick             \
    --quote-names       \
    --disable-keys      \
    --extended-insert   \
    ${1} | gzip -c > ${1}_`/bin/date "+%Y-%m-%d-%H%M"`.dump.sql.gz


