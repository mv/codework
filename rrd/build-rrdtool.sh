#!/bin/bash -x
# $Id: build-svn.sh 2527 2006-10-30 23:33:15Z marcus.ferreira $
#
#

export CC="gcc"
export CFLAGS="-O3 -DALL_STATIC -pipe"
export CFLAGS="-O3 -DPNG_STATIC -pipe"
export PREFIX=/usr/local

export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

#    --prefix=$PREFIX                    \

if \
    ./configure                          \
    --disable-tcl                       \
    --disable-python                    \
    --disable-ruby                      \
    2>&1 | tee configure.my.log
then
    make         | tee make.my.log
    make test    | tee make.my.test.log
    make install | tee make.my.install.log
    cd perl-shared &&
        perl Makefile.PL &&
        make &&
        make test &&
        make install &&
    cd ..
    cd perl-piped &&
        perl Makefile.PL &&
        make &&
        make test &&
        make install &&
    cd ..
fi

