#!/bin/bash -x
# $Id$
#
# Subversion 1.3.2 - OpenBSD
# Ago/2006
#
# neon: package 0.25.5
# OpenBSD packages: ruby, perl, swig, python
#

export CC="gcc"
export CFLAGS="-O2 -pipe -fno-strict-aliasing"

export PATH=/usr/local/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/BerkeleyDB.4.4/lib:/usr/local/apr/lib:/lib

    ./configure                             \
        --prefix=/usr/local/subversion      \
        --with-apr=/usr/local/apr           \
        --with-apr-util=/usr/local/apr      \
        --with-apxs=/usr/local/apache2/bin/apxs \
        --with-berkeley-db                  \
        --with-ssl                          \
        2>&1 | tee configure.my.log

#  make | tee make.log_${DT_INST}
#  make install | tee make_install.log_${DT_INST}

