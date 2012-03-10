#!/bin/bash
# $Id: wget_bookshelf.sh 150 2005-04-16 02:13:41Z marcus $
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

wget    -c --http-user=mvini29     \
        --http-passwd=terra29   \
        $1

#       --timestamping          \
#       --background            \

#--user-agent "$AGENT"   \
#        -erobots=off            \
