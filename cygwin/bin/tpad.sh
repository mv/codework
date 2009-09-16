#!/bin/bash
# $Id: tpad.sh 19717 2007-11-09 21:51:22Z marcus.ferreira $
# Marcus Vinicius Ferreira      ferreira.mv[  at  ]gmail.com
# v2/cygwin
# Nov/2006

TPAD=/usr/local/bin/tpad

[ -f $TPAD ] || {

    echo "tpad for TEXTPAD is not defined in /usr/local/bin"
    echo "You must do something like:"
    echo '    ln -s "/c/arquivos_de_programas/TextPad 4/TextPad.exe" /usr/local/bin/tpad'
    exit 1
}

if [ -z "$1" ]
then
    $TPAD &
    exit 0
fi

WAIT=1
for f in $@
do
    if [ -f $f ]
    then
        tpad `cygpath -w $f` &
        [ "$WAIT" == "1" ] && sleep 1
        WAIT=0
    fi
done
