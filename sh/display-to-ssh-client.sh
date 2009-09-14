#!/bin/bash
# $Id$
#

[ -z "$SSH_CLIENT" ] && {
    cat <<CAT

    SSH_CLIENT is not defined!

CAT
exit 1
}

echodo() {
    echo $@
    $@
}

IP=`echo $SSH_CLIENT | awk -F: '{print $4}'`
IP=`echo $IP         | awk     '{print $1}'`

echodo export DISPLAY=${IP}:0

