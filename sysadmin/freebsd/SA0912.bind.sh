
[ "$1" != "-f" ] && { 

cat <<CAT

Usage: $0 -f

    apply FreeBSD security patches
        
CAT
exit 1
}

cd /usr/src
    fetch -o  bind.0912.patch http://security.FreeBSD.org/patches/SA-09:12/bind.patch   
    patch < bind.0912.patch
        cd /usr/src/lib/bind
        make obj && make depend && make && make install
        cd /usr/src/usr.sbin/named
        make obj && make depend && make && make install
        /etc/rc.d/named restart

