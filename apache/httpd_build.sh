#!/bin/bash

export PREFIX='/usr/local/apache-2.2.11'
export CFLAGS='-O2'

./configure                 \
    --prefix=$PREFIX        \
    --enable-modules=all    \
    --enable-proxy          \
    --enable-ssl            \
    | tee configure.my.log

make            | tee make.my.test.log
make test       | tee make.my.test.log
make install    | tee make.my.install.log

