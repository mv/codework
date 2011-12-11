#!/bin/bash -x
# $Id$
#
# Perl/svn/Mdias - RH ES 4 - post BerkeleyDB 4.4
# Ago/2006
#

DIR=./perl-5.8.8

/bin/cp build-perl.Policy.sh $DIR/Policy.sh

cd $DIR

    [ -f config.sh ] && /bin/rm config.sh
    export CFLAGS="$CFLAGS -shared -L/usr/local/lib"

    sh Configure        -des        \
        -Dprefix=$PREFIX            \
        -Dinstallprefix=$PREFIX     \
        -Dcc=gcc                    \
        -Duse64bitint               \
        -Duselargefiles             \
        -Duseperlio                 \
        -Dusemultiplicity           \
        -Dusemymalloc               \
        -Dusenm=yes                 \
        -Dusedl                     \
        -Uuseshrplib                \
        -Doptimize="-O2 -pipe" \
        -Dlocincpth="/usr/local/include /usr/include"   \
        -Dloclibpth="/usr/local/lib /usr/lib /lib"      \
        2>&1 | tee configure.my.log

#       -Dusethreads                \
#       -Dusesocks                  \
#       -no-stric-aliasing

    [ "$?" == "0" ] && make         | tee make.my.log
    [ "$?" == "0" ] && make test    | tee make.my.test.log
    [ "$?" == "0" ] && make install | tee make.my.install.log
