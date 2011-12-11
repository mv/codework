#!/bin/bash -x
# $Id: build-httpd2.sh 58 2006-09-27 17:02:47Z marcus.ferreira $
#
# Apache 2.2.6 - RH ES 4
# Out/2007
#


# export BERKELEY_DB="/usr/local/svn/BerkeleyDB"
# export LD_LIBRARY_PATH=$BERKELEY_DB/lib

DIR=httpd-2.2.8
cd $DIR

cd srclib/apr-util 2>/dev/null

    ./configure                             \
        --prefix=$PREFIX/apache             \
        --with-apr=$PREFIX/apache           \
        --with-expat=$PREFIX                \
        --with-berkeley-db=$PREFIX/BerkeleyDB.4.4   \
        --with-ldap                         \
        2>&1 | tee configure.my.log

       #--with-ldap                      \
       #--with-dbm=db44                     \

    [ "$?" == "0" ] && make         | tee make.log
    [ "$?" == "0" ] && make test    | tee make.test.log
    [ "$?" == "0" ] && make install | tee make.install.log
