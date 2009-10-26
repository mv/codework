
[ "$1" != "-f" ] && { 

cat <<CAT

Usage: $0 -f

    apply FreeBSD security patches
        
CAT
exit 1
}

cd /usr/src
    fetch -o 0907.libc.patch http://security.FreeBSD.org/patches/SA-09:07/libc.patch
    patch <  0907.libc.patch
        cd /usr/src/lib/libc
        make obj && make depend && make && make install

