

PKG="postgres_ofa-7.4.7-noarch-1ign.tgz"

[ -f $PKG ] && /bin/rm $PKG

makepkg --linkadd y \
        --chown   n \
         $PKG

