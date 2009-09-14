#!/bin/bash

[ -f 1.txt ] && /bin/rm 1.txt

ROOT=~/trunk/gaps/
for f in `find $ROOT/*/*/p* -type f \
            | grep -v .svn      \
            | grep -v pex.      \
            | grep -v .lst      \
            | grep -v build.txt \
            | grep -v cp.sh     \
            `
do

    # svn info $f ; continue

    SVN=`svn info $f | grep "Last Changed Rev"`
    ERR=$?
    [ "$ERR" != "0" ] && continue

    REV=`echo $SVN | awk -F: '{print $2}'`
     DIR=${f%/*}
    FILE=${f##*/}
    printf "%-35s %5d %s\n" $FILE $REV $DIR | tee -a 1.txt


done
