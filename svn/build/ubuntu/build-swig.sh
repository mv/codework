#!/bin/bash -x
# $Id: build-swig.sh 1905 2006-10-20 20:06:30Z marcus.ferreira $
#
# Subversion 1.4.0 - Linux
# Ago/2006
#

DIR=./swig-1.3.29

cd $DIR
    ./configure             \
        --prefix=$PREFIX    \
        --without-java          \
        --without-chicken       \
        --without-csharp        \
        --without-guile         \
        2>&1 | tee configure.my.log


    [ "$?" == "0" ] && make         | tee make.log
    [ "$?" == "0" ] && make install | tee make.install.log
    [ "$?" == "0" ] || exit $?
