# $Id: env.sh 2527 2006-10-30 23:33:15Z marcus.ferreira $
#
# Clear environment for compilation
#

PATH=/bin:/sbin
PATH=$PATH:/usr/bin:/usr/sbin:/usr/X11R6/bin
PATH=$PATH:/usr/local/bin:/usr/local/sbin

export CC="gcc"
export CFLAGS="-O2 -pipe"
export PREFIX=/usr/local

LIB=$PREFIX/lib:$PREFIX/apache/lib:$PREFIX/BerkeleyDB/lib

export PATH=$PREFIX/BerkeleyDB/bin:$PREFIX/apache/bin
export PATH=$PREFIX/bin:$PREFIX/sbin:/bin:/usr/bin:$PATH
export LD_LIBRARY_PATH=$LIB

unset PERLBIN PERL5LIB ADPERLPRG LIB
