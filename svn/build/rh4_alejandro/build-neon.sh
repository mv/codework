#!/bin/bash -x
# $Id: build-neon.sh 2527 2006-10-30 23:33:15Z marcus.ferreira $
#
# Subversion 1.4.5 - Linux
# Out/2007
#
# neon: package 0.26.1
#

DIR=neon-0.26.1

cd $DIR
    ./configure                         \
        --prefix=$PREFIX                \
        --enable-shared                 \
        --with-libs=/usr/local          \
        --with-libxml2                  \
        --with-expat                    \
        --with-ssl                      \
        --with-zlib                     \
        2>&1 | tee configure.my.log


    [ "$?" == "0" ] && make         | tee make.my.log
    [ "$?" == "0" ] && make install | tee make.my.install.log

