#!/bin/bash
#
# $Id$
# Dez/2007      Marcus Vinicius Ferreira        ferreira.mv[ at ]gmail.com
# Cygwin


gw=`ipconfig | grep "Gateway" | head -1 | awk -F ": " '{print $2}' | awk -F "\r" '{print $1}'`

cat <<EOF >&1

    [$gw]

EOF
