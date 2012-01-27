#!/bin/bash
#
# mysql-dump-ins.sh
#     data only, using INSERT VALUES
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-01
#

[ -z "$1" ] && {

    echo
    echo "Usage: $0 db_name"
    echo
    echo "    data only, using INSERT VALUES"
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
    --no-create-db      \
    --no-create-info    \
    --complete-insert   \
    --skip-extended-insert \
    ${1} | gzip -c > ${1}_`/bin/date "+%Y-%m-%d-%H%M"`.ins.sql.gz


