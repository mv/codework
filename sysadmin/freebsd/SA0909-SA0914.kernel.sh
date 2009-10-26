
[ "$1" != "-f" ] && { 

cat <<CAT

Usage: $0 -f

    apply FreeBSD security patches
    http://www.freebsd.org/security/advisories.html
    
Create custom kernel first:
    cd /usr/src/sys/i386/conf
    cp GENERIC abd
    # vim abd
    
CAT
exit 1
}

cd /usr/src
    fetch -o 0909.pipe.patch   http://security.FreeBSD.org/patches/SA-09:09/pipe.patch   
    fetch -o 0913.pipe.patch   http://security.FreeBSD.org/patches/SA-09:13/pipe.patch   

    fetch -o 0910.ipv6.patch   http://security.FreeBSD.org/patches/SA-09:10/ipv6.patch   
    fetch -o 0914.devfs7.patch http://security.FreeBSD.org/patches/SA-09:14/devfs7.patch 

    for f in *patch; do echo $f; patch < $f ; read x; echo ;done 
    
    
    make buildkernel   KERNCONF=GENERIC && \
    make installkernel KERNCONF=GENERIC

