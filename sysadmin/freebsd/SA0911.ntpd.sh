
[ "$1" != "-f" ] && { 

cat <<CAT

Usage: $0 -f

    apply FreeBSD security patches
        
CAT
exit 1
}


cd /usr/src
    fetch -o ntpd.0911.patch http://security.FreeBSD.org/patches/SA-09:11/ntpd.patch  
    patch < ntpd.0911.patch
        cd /usr/src/usr.sbin/ntp/ntpd
        make obj && make depend && make && make install && \
        /etc/rc.d/ntpd restart

