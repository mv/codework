#!/bin/bash
#
# Dump from pg, to be used on MySQL
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2013-01
#

mysql -B -s -e 'show tables' | \
while read tab;
do
    echo -n "$tab " && \
    mysql -B -s -e "select count(1) from $tab";
done | column -t


# vim:ft=sh:

