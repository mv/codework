#!/bin/bash -x
# $Id: build-svn.sh 2527 2006-10-30 23:33:15Z marcus.ferreira $
#
# Subversion 1.4.5
# Out/2007
#
# oel-4:
#   pre-installed: swig, python
#

DIR=subversion-1.4.6
cd $DIR

    ./configure                             \
        --prefix=$PREFIX                    \
        --with-apr=$PREFIX/apache           \
        --with-apr-util=$PREFIX/apache      \
        --with-apxs=$PREFIX/apache/bin/apxs \
        --with-berkeley-db                  \
        --with-neon=$PREFIX                 \
        --with-ldap                         \
        --without-ruby                      \
        2>&1 | tee configure.my.log

#       --with-ssl=/usr/bin/openssl         \
#       --with-swig=$PREFIX/swig            \
#       --with-swig=/usr/local/bin/swig     \

    [ "$?" == "0" ] && make         | tee make.my.log
    [ "$?" == "0" ] && make install | tee make.my.install.log

    [ "$?" == "0" ] && make swig-py         | tee make.my.py.log
    [ "$?" == "0" ] && make install-swig-py | tee make.my.py.install.log

#   echo $PREFIX/lib/svn-python \
#          > $PREFIX/lib/python2.5/site-packages/subversion.pth

    [ "$?" == "0" ] && make swig-pl         | tee make.my.pl.log
    [ "$?" == "0" ] && make check-swig-pl   | tee make.my.pl.check.log
    [ "$?" == "0" ] && make install-swig-pl | tee make.my.pl.install.log

#   [ "$?" == "0" ] && make swig-rb         | tee make.my.rb.log
#   [ "$?" == "0" ] && make check-swig-rb   | tee make.my.rb.check.log
#   [ "$?" == "0" ] && make install-swig-rb | tee make.my.rb.install.log

