

./configure \
    --prefix=/usr/local         \
    --enable-storeio=ufs,aufs   \
    --enable-removal-policies   \
    --with-pthreads             \
    --with-aio                  \
    --with-large-files          \
    --with-maxfd=16384          \
    --with-openssl=/usr/local   \
    --enable-pf-transparent     \
    | tee configure.my.log


make | tee make.my.log
make install | tee make.install.my.log

# 32Mb Ram x 1 GB disk

# http://blog.last.fm/2007/08/30/squid-optimization-guide
# http://blog.ptpn-xi.com/?cat=3
# https://www.linuxquestions.org/questions/linux-server-73/squid-cache-big-files.-668345/
# http://wiki.squid-cache.org/SquidFaq/ConfiguringSquid#head-8cbd306242ac3a1704cd5eb623d51b035c00b904
