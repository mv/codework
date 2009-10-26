
[ "$1" != "-f" ] && { 

cat <<CAT

Usage: $0 -f

    apply FreeBSD security patches
        
CAT
exit 1
}

cd /usr/src
    fetch -o  openssl.0908.patch http://security.FreeBSD.org/patches/SA-09:08/openssl.patch
    patch < openssl.0908.patch
        cd /usr/src/secure/lib/libcrypto
        make obj && make depend && make includes && make && make install

