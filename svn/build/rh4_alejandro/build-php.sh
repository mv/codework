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

DIR=php-5.2.5
cd $DIR

    ./configure                                 \
        --prefix=$PREFIX                        \
        --with-apxs2=$PREFIX/apache/bin/apxs    \
        --enable-fastcgi                        \
        --enable-force-cgi-redirect             \
        --enable-discard-path                   \
        --with-config-file-path=$PREFIX/etc     \
        --with-openssl                          \
        --with-kerberos                         \
        --with-curl                             \
        --with-zlib                             \
        --with-bz2                              \
        --enable-dba                            \
        --with-db4                              \
        --with-mysql                            \
        --with-pgsql                            \
        --enable-ftp                            \
        --with-gd                               \
        --with-imap                             \
        --with-imap-ssl                         \
        --with-readline                         \
        --with-xsl                              \
        --enable-zip                            \
        2>&1 | tee configure.my.log

#       --with-snmp                             \

    [ "$?" == "0" ] && make         | tee make.my.log
    [ "$?" == "0" ] && make test    | tee make.my.test.log
    [ "$?" == "0" ] && make install | tee make.my.install.log

    [ "$?" == "0" ] && libtool --finish /usr/local/src/php-5.2.5/libs

