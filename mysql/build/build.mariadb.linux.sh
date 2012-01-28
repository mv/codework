
   BASE=/usr/local
   BASE=/u01/app/mysql
     DB=mariadb
VERSION=5.1.39
COMMENT="-- MariaDB, a branch of MySQL at `date`"

CURRENT=${DB}-${VERSION}
 PREFIX=${BASE}/${CURRENT}
 PREFIX=${BASE}/${CURRENT}_1

# Ref:
#     http://rpbouman.blogspot.com/2008/07/building-mysql-from-source-theres-fine.html
#     http://www.primebase.org/documentation/

export       CC='ccache gcc -static-libgcc'
export      CXX='ccache gcc -static-libgcc'
export       CC='       gcc -static-libgcc'
export      CXX='       gcc -static-libgcc'
export   CFLAGS='-g -O3'
export CXXFLAGS='-g -O3'

export   CFLAGS='   -O3'
export CXXFLAGS='   -O3'

#   --with-server-suffix=''                     \
#   --sysconfdir=$BASE/etc                      \
#   --docdir=$PREFIX/doc                        \
#   --mandir=$PREFIX/man                        \

make clean
#   --with-fast-mutexes                         \

./configure     \
    --prefix=$PREFIX                            \
    --sbindir=$PREFIX/bin                       \
    --libexecdir=$PREFIX/bin                    \
    \
    --with-comment="$COMMENT"                   \
    --with-mysqld-user=mysql                    \
    --with-tcp-port=3306                        \
    --with-unix-socket-path=/tmp/mysql.sock     \
    \
    --with-charset=latin1                       \
    --with-extra-charsets=all                   \
    --with-collation=latin1_general_ci          \
    \
    --enable-thread-safe-client                 \
    --enable-local-infile                       \
    --enable-assembler                          \
    --enable-profiling                          \
    --enable-dtrace                             \
    \
    --with-fast-mutexes                         \
    --with-pic                                  \
    --with-client-ldflags=-static               \
    --with-mysqld-ldflags=-static               \
    --with-ssl                                  \
    --with-readline                             \
    --with-zlib-dir=bundled                     \
    \
    --with-big-tables                           \
    --with-maria-tmp-tables                     \
    --with-plugins=max-no-ndb                   \
    --without-plugin-example                    \
    \
    --with-embedded-server                      \
    --with-mysqlmanager                         \
    --with-docs                                 \
    \
    | tee configure.my.log
exit 99
  [ "$?" == "0" ] && make             | tee make.my.log
# [ "$?" == "0" ] && make test        | tee make.test.my.log
  [ "$?" == "0" ] && make install     | tee make.install.my.log
# [ "$?" == "0" ] && cd $BASE && rm -f current && ln -s ${DB}-${VERSION} current && ls -lh

# luiz.albuquerque@starmedia.net
#


