#!/bin/bash
#
# mysql-dump-data.sh
#     data only
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-01
#

[ -z "$1" ] && {

    echo
    echo "Usage: $0 db_name"
    echo
    echo "    mysqldump: data only"
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
    --no-create-db      \
    --no-create-info    \
    ${1} | gzip -c > ${1}_`/bin/date "+%Y-%m-%d-%H%M"`.data.dump.sql.gz


