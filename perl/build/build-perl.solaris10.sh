#!/bin/bash -x
# $Id$
#
# Perl solaris10x86 - post BerkeleyDB 4.4
# Ago/2006
#

DIR=./perl-5.8.8

# /bin/cp build-perl.Policy.solaris10.sh \
#         $DIR/Policy.sh

[ -f config.sh ] && /bin/rm config.sh

  bash Configure        -sed        \
        -Darchname=i86pc-solaris    \
        -Dcc=cc                     \
        -Doptimize='-xO3 -xspace -xildoff'  \
        -Duseposix                  \
        -Duseperlio                 \
        -Duselargefiles             \
        -Dusenm                     \
        -Dusedl                     \
        -Duseshrplib                \
        -Uuse64bitint               \
        -Uuselongdouble             \
        -Uusemymalloc               \
        -Uusethreads                \
        -Uusemultiplicity           \
        -Uusesocks                  \
        2>&1 | tee configure.my.log

#
# nm: lib function extraction
# dl: dynamic loading
# shrplib: shared perl library
#       -Darchname=i86pc-solaris-64int      \
#       -Duse64bitint               \
#
#

    [ "$?" == "0" ] && make         | tee make.my.log
    [ "$?" == "0" ] && make depend  | tee make.my.depend.log
    [ "$?" == "0" ] && make test    | tee make.my.test.log
    [ "$?" == "0" ] && make install | tee make.my.install.log


