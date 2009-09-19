#!/bin/bash -x
#
# MacOS 10.5.7 x86
# 2009/09

VERSION=5.10.1
  PERLV=perl-${VERSION}
 PREFIX=/u01/perl

/bin/rm -f config.sh
/bin/rm -f Policy.sh

CC=/Developer/usr/bin/gcc

### Creating Policy.sh, for verification:
# sh Configure -des -D prefix=/u01/perl \
#     | tee configure.des.log
# cat -n -l Policy.sh | egrep -v '#' cat

### Verifying default compilation options
# perl -V:config_args
#

# sh Configure -h
#     -f : specify an alternate default configuration file.
#     -d : use defaults for all answers.
#     -e : go on without questioning past the production of config.sh.
#     -s : silent mode, only echoes questions and essential information.
#     -D : define symbol to have some value:
#     -U : undefine symbol

sh ./Configure -des             \
    -D prefix=$PREFIX           \
    -D cc=gcc                   \
    -D optimize='-O3'           \
    \
    -D usedtrace                \
    \
    -D     man1dir=$PREFIX/share/man/man1      \
    -D     man3dir=$PREFIX/share/man/man3p     \
    -D siteman1dir=$PREFIX/site_perl/man/man1  \
    -D siteman3dir=$PREFIX/site_perl/man/man3  \
    2>&1 | tee configure.my.log              && \
    \
    make         2>&1 | tee make.my.log          && \
    make depend  2>&1 | tee make.my.depend.log   && \
    make test    2>&1 | tee make.my.test.log     && \
    make install 2>&1 | tee make.my.install.log

# Add to @INC:
#   -D otherlibdirs=/opt/local/lib/perl5/vendor_perl/5.8.8:/path1:etc...
# Ignore previous version search trees to @INC
#   -D inc_version_list=none

# Obs
#    -Dccflags='-fno-strict-aliasing -fno-delete-null-pointer-checks -pipe -I/usr/local/include' \
#    -Dcppflags='-fno-strict-aliasing -fno-delete-null-pointer-checks -pipe -I/usr/local/include' \

cpan \
    Test::Pod
    Test::Pod::Coverage
    DBI
    DBD::mysql
    DBD::Oracle


