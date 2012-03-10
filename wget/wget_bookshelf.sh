#!/bin/bash
# $Id$
#
# wget for a web html tree
#
# Marcus Vinicius Ferreira Nov/2004
#

usage ()
{
cat >&1 <<EOF

    Usage: $0 URL

EOF
exit 1
}

[ -z $1 ] && usage

AGENT="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.5) Gecko/20041107 Firefox/1.0"

wget    --background            \
        --no-clobber            \
        --limit-rate=20k        \
        --wait=5                \
        --random-wait           \
        --user-agent "$AGENT"   \
        --recursive             \
        --level=inf             \
        --convert-links         \
        --page-requisites       \
        --no-parent             \
        -erobots=off            \
        $1

#       --timestamping          \
