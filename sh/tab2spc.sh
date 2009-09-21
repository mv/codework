#!/bin/bash
# $Id: tab2spc.sh 8459 2007-01-25 19:29:22Z marcus.ferreira $
#
# (c) Marcus Vinicius Ferreira  [ ferreira.mv at gmail ]  Ago/2006
#

[ -z "$1" ] &&  {
cat <<CAT

    Usage: $0 <file_name>

    Converts a tab to 8 spaces.

CAT
exit 1
}

for f in "$@"
do
    [ ! -f $f ] && continue
    echo -n "Tab to space: $f "

    if perl -pi -e "s/\t/        /g" $f
    then echo "  ok..."
    else echo "  error."
    fi

done
