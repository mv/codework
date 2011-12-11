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

DIR=./subversion-1.4.4
cd $DIR

unset RUBYOPT

BerkeleyDB() {
cd /usr/lib
ln -s libdb-4.2.a libdb.a
ln -s libdb-4.2.la libdb.la
ln -s libdb-4.2.dll.a libdb.dll.a
cd /usr/include
rm db.h ; ln -s db4.2/db.h
rm db4  ; ln -s db4.2 db4
}

export LD_LIBRARY_PATH=/usr/local/lib

unset RUBYOPT

    ./configure                             \
        --prefix=$PREFIX                    \
        --with-apxs=/usr/local/apache/bin/apxs  \
        --disable-neon-version-check        \
        --with-berkeley-db                  \
        --with-ldap                         \
        2>&1 | tee configure.my.log

#       --with-berkeley-db                  \
#       --with-apr=$PREFIX/apache           \
#       --with-apr-util=$PREFIX/apache      \


#  make         | tee make.my.log                       && \
#  make install | tee make.my.install.log               && \
#  make swig-py         | tee make.my.py.log            && \
#  make install-swig-py | tee make.my.py.install.log    && \
#  make swig-pl         | tee make.my.pl.log            && \
#  make check-swig-pl   | tee make.my.pl.check.log      && \
#  make install-swig-pl | tee make.my.pl.install.log    && \
#  make swig-rb         | tee make.my.rb.log            && \
#  make check-swig-rb   | tee make.my.rb.check.log      && \
#  make install-swig-rb | tee make.my.rb.install.log


