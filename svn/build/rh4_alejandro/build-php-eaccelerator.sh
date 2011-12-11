#!/bin/bash -x
# $Id: build-svn.sh 2527 2006-10-30 23:33:15Z marcus.ferreira $
#
# PHP 5.2.5
# Fev/2008
#
# rh-4:
#     * flex: Version 2.5.4
#     * bison: Version 1.28 (preferred), 1.35, or 1.75
#     ln -s /usr/lib/libgcrypt.so.11    /usr/lib/libgcrypt.so
#     ln -s /usr/lib/libgpg-error.so.0  /usr/lib/libgpg-error.so
#

DIR=eaccelerator-0.9.5.2
cd $DIR

    PHP_PREFIX="$PREFIX"
    $PREFIX/bin/phpize

    ./configure                                         \
        --enable-eaccelerator=shared                    \
        --with-php-config=$PREFIX/bin/php-config    \
        2>&1 | tee configure.my.log


    [ "$?" == "0" ] && make         | tee make.my.log
    [ "$?" == "0" ] && make test    | tee make.my.test.log
    [ "$?" == "0" ] && make install | tee make.my.install.log

