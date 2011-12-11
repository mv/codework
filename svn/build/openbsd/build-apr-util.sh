#!/bin/bash
# $Id$
#
# Apache 2.2 - OpenBSD
# Ago/2006
#

    ./configure --prefix=/usr/local/apr \
    --with-berkeley-db \
    tee configure.my.log

    make | tee make.my.log
    make test | tee make.my.test.log
    make install | tee make.my.install.log

