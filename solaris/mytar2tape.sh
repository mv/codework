#!/bin/bash
# $Id$
#
# Marcus Vinicius Ferreira

[ -z "$1" ] && {
    echo
    echo Usage: $0 <dir>
    echo
    exit 1
}

set -x
dt=`date "+%Y-%m-%d_%M%H"`
time ( tar cvf /dev/st0 $* > tar.${dt}.cvf.txt)
mt -f /dev/st0 rewind
mt -f /dev/st0 status
time ( tar tvf /dev/st0 > tar.${dt}.tvf.txt )

exit 0


