#!/bin/bash -x
# $Id: build-BerkeleyDB.sh 2265 2006-10-26 17:17:22Z marcus.ferreira $
#
# Subversion 1.4.5 - Linux
# Out/2007
#
# BerkeleyDB 4.4
#

# PREFIX="$PREFIX/BerkeleyDB"
DIR=db-4.4.20

cd $DIR
cd build_unix 2>/dev/null

    ../dist/configure                   \
        --prefix=$PREFIX/BerkeleyDB.4.4 \
        2>&1 | tee configure.my.log

    [ "$?" == "0" ] && make         | tee make.my.log
    [ "$?" == "0" ] && make install | tee make.my.install.log

ln -s /usr/local/BerkeleyDB.4.4                 $PREFIX/BerkeleyDB
ln -s /usr/local/BerkeleyDB/lib/libdb.so        /usr/local/lib/
ln -s /usr/local/BerkeleyDB/lib/libdb-4.so      /usr/local/lib/
ln -s /usr/local/BerkeleyDB/lib/libdb-4.4.so    /usr/local/lib/
