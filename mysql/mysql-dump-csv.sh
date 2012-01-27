#!/bin/bash
#
# mysql-dump-csv.sh
#     each table as a csv file
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-01
#

[ -z "$1" ] && {

    echo
    echo "Usage: $0 db_name"
    echo
    echo "    each table as a csv file"
    echo
    echo "    Assumes ~/.my.cnf is configured:"
    echo "      [client]"
    echo "      username=root"
    echo "      password=root"
    echo
    exit 2
}

dir="${1}_`/bin/date '+%Y-%m-%d-%H%M'`"
mkdir -p "${dir}"

mysqldump \
    --flush-logs        \
    --hex-blob          \
    --quick             \
    --quote-names       \
    --no-create-db      \
    --tab="./${dir}"    \
    --fields-enclosed-by='"'            \
    --fields-terminated-by=','          \
    --lines-terminated-by="\n"          \
    ${1} && tar cvfz ${dir}.tar.gz ${dir}

#   --fields-escaped-by=              \
#   --fields-optionally-enclosed-by='"'  \

