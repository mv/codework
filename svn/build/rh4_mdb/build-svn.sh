#!/bin/bash -x
# $Id: build-svn.sh 2527 2006-10-30 23:33:15Z marcus.ferreira $
#
# Subversion 1.3.2 - OpenBSD
# Ago/2006
#
# neon: package 0.25.5
# OpenBSD packages: ruby, perl, swig, python
#
# ldap? kerberos?
#

DIR=./subversion-1.4.2
cd $DIR

    ./configure                             \
        --prefix=$PREFIX                    \
        --with-apr=$PREFIX/apache           \
        --with-apr-util=$PREFIX/apache      \
        --with-apxs=$PREFIX/apache/bin/apxs \
        --with-swig=$PREFIX/swig            \
        --with-berkeley-db                  \
        --with-neon=$PREFIX                 \
        --with-ldap                         \
        --with-swig=/usr/local/bin/swig     \
        2>&1 | tee configure.my.log

#       --with-ssl=/usr/bin/openssl         \

#   [ "$?" == "0" ] && make         | tee make.my.log
#   [ "$?" == "0" ] && make install | tee make.my.install.log

#   [ "$?" == "0" ] && make swig-py         | tee make.my.py.log
#   [ "$?" == "0" ] && make install-swig-py | tee make.my.py.install.log

#   echo $PREFIX/lib/svn-python \
#          > $PREFIX/lib/python2.5/site-packages/subversion.pth

#   [ "$?" == "0" ] && make swig-pl         | tee make.my.pl.log
#   [ "$?" == "0" ] && make check-swig-pl   | tee make.my.pl.check.log
#   [ "$?" == "0" ] && make install-swig-pl | tee make.my.pl.install.log

#   [ "$?" == "0" ] && make swig-rb         | tee make.my.rb.log
#   [ "$?" == "0" ] && make check-swig-rb   | tee make.my.rb.check.log
#   [ "$?" == "0" ] && make install-swig-rb | tee make.my.rb.install.log



    ./configure                             \
        --prefix=$PREFIX                    \
        --with-apr=$PREFIX/apache           \
        --with-apr-util=$PREFIX/apache      \
        --with-apxs=$PREFIX/apache/bin/apxs \
        --with-berkeley-db                  \
        --with-ldap                         \
        2>&1 | tee configure.my.log

        --with-swig                         \
        --with-neon                         \
