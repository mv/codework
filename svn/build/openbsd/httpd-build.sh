#!/bin/bash
# $Id$
#
# Apache 2.2 - OpenBSD
# Ago/2006
#

export AUTOCONF_VERSION=2.59
export CC="gcc"
export CFLAGS="-O2"

./buildconf

cd srclib/apr
    ./configure --prefix=/usr/local/apr
    make
    make install
    cd ..

cd srclib/apr-util
    ./configure --prefix=/usr/local/apr
    make
    make install
    cd ..

exit 1

./configure     \
    --prefix=/usr/local/apache2         \
    --with-apr=/usr/local/apr           \
    --with-apr-util=/usr/local/apr      \
    --enable-layout=Apache              \
    --enable-mods-shared="most ldap"    \
    2>&1 | tee configure.most.log
    
    
    

