#!/bin/bash
#


[ -f config.sh ] && /bin/rm config.sh

#    ./Configure -h
bash ./Configure -sed       \
   -Darchname=i386-openbsd  \
   -Dcc=gcc                 \
   -Doptimize='-O2'         \
   -Duseposix               \
   -Duseperlio              \
   -Duselargefiles          \
   -Dusenm                  \
   -Duseld                  \
   -Duseshrplib             \
   -Uuse64bitint            \
   -Uuselongdouble          \
   -Uusemymalloc            \
   -Uusethreads             \
   -Uusemultiplicity        \
   -Uusesocks               \
   2>&1 | tee configure.my.log

   [ "$?" == "0" ] && make         | tee make.my.log
   [ "$?" == "0" ] && make depend  | tee make.my.depend.log
   [ "$?" == "0" ] && make test    | tee make.my.test.log
   [ "$?" == "0" ] && make install | tee make.my.install.log

#    -Dccflags='-fno-strict-aliasing -fno-delete-null-pointer-checks
#    -pipe -I/usr/local/include' \
#    -Dcppflags='-fno-strict-aliasing -fno-delete-null-pointer-checks
#                -pipe -I/usr/local/include' \
   # d_sigaction=define
   # hint=recommended,
   # -Dopenbsd_distribution
