#!/bin/bash -x
# $Id: build-BerkeleyDB.sh 2265 2006-10-26 17:17:22Z marcus.ferreira $
#
# Subversion 1.4.0 - Linux
# Ago/2006
#
# BerkeleyDB 4.4
#

# PREFIX="$PREFIX/BerkeleyDB"
DIR=./db-4.2.52

# used by APR: apu-1-config --libs
#

cd $DIR
cd build_unix 2>/dev/null

    ../dist/configure                   \
        2>&1 | tee configure.my.log

    [ "$?" == "0" ] && make         | tee make.my.log
    [ "$?" == "0" ] && make install | tee make.my.install.log

