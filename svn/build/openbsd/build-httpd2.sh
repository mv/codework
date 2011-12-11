#!/bin/bash -x
# $Id$
#
# Apache 2.2.3 - OpenBSD
# Ago/2006
#
# no LDAP! (-> apr-util  -> httpd)
# no suexec (obsd snprintf)

export AUTOCONF_VERSION=2.59
export CC="gcc"
export CFLAGS="-O2"

# ./buildconf

cat >/dev/null <<CAT
    cd srclib/apr
        ./configure --prefix=/usr/local/apr
        make
        make install
        cd ../..

     cd srclib/apr-util
        ./configure \
            --prefix=/usr/local/apr         \
            --with-apr=/usr/local/apr       \
            --with-berkeley-db              \
            && \
        make            && \
        make install    && \
        cd ../..

#            --with-ldap                     \
#            --with-dbm=44                   \

    exit 1
CAT

export LD_LIBRARY_PATH=/usr/local/apr/lib/

./configure     \
    --prefix=/usr/local/apache2             \
    --with-apr=/usr/local/apr               \
    --with-apr-util=/usr/local/apr          \
    --enable-layout=Apache                  \
    --with-ssl                              \
    --enable-mods-shared="all dav_lock proxy cgid"    \
    2>&1 | tee configure.all.log
    
#     --enable-mods-shared="most ldap proxy dav_lock cgid authnz_ldap cache log_forensic suexec version"    \
    
    