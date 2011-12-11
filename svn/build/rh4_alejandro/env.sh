# $Id: env.sh 2527 2006-10-30 23:33:15Z marcus.ferreira $
#
# Clear environment for compilation
#

# rh4 alejandro:
#   pre-installed: swig
#

PATH=/bin:/sbin
PATH=$PATH:/usr/bin:/usr/sbin:/usr/X11R6/bin
PATH=$PATH:/usr/local/bin:/usr/local/sbin

export CC="gcc"
export CFLAGS="-O2 -pipe"
export PREFIX=/usr/local

LIB=$PREFIX/apache/lib:$PREFIX/BerkeleyDB/lib:$PREFIX/lib
# LIB=$LIB:/usr/local/lib:/lib:/usr/lib:/usr/X11R6/lib

export PATH=$PREFIX/BerkeleyDB/bin:$PREFIX/apache/bin:$PATH  # $PREFIX/swig/bin:
export PATH=$PREFIX/bin:$PREFIX/sbin:$PATH
export LD_LIBRARY_PATH=$LIB

unset PERLBIN PERL5LIB ADPERLPRG LIB
