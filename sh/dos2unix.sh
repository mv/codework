#!/bin/bash
# $Id: dos2unix.sh 10636 2007-02-28 16:48:59Z marcus.ferreira $
#
# http://partmaps.org/era/unix/award.html#gripes
#
# Marcus Vinicius Ferreira      ferreira.mv[  at  ]gmail.com
#
# Fev/2007

[ -z "$1" ] && {
    echo
    echo "Usage: $0 file"
    echo
    echo "    dos 2 unix in place "
    echo
    exit 2
}

FILE="$1"
WORK="${1}.tmp"

if ! /bin/mv $FILE $WORK
then
    echo "Cannot create work copy."
fi

< $WORK tr -d "\r" > $FILE

if ! /bin/rm $WORK
then
    echo "Cannot remove work copy."
fi

