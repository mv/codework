#!/bin/bash -x
# $Id: build-neon.sh 2527 2006-10-30 23:33:15Z marcus.ferreira $
#
# Subversion 1.4.5 - Linux
# Out/2007
#
# Python
#

DIR=Python-2.5.1

cd $DIR
    ./configure                         \
        --prefix=$PREFIX                \
        --enable-shared                 \
        --with-libs=/usr/local          \
        --without-threads                  \
        --without-pth                 \
        2>&1 | tee configure.my.log


    [ "$?" == "0" ] && make         | tee make.my.log
    [ "$?" == "0" ] && make install | tee make.my.install.log

