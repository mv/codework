#!/bin/bash
# $Id$
#

[ -z "$1" ] && {
    echo
    echo "Usage: $0 <file>"
    echo
exit 2
}

for f in $@
do
    filename=${f##*/}
    name=${filename%%.*}

    echo "Processing $f"
    if tar xfz $f
    then
        [ -f ${name}.zip ] && /bin/rm ${name}.zip
        zip -r -m -q ${name}.zip $name || echo "    Erro zip: $f"
    else
        echo "    Erro tar: $f"
    fi
    [ -d $name ] && /bin/rm -rf $name

done
