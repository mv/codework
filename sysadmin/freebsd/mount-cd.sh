# FreeBSD 5.x,6,7

    mdconfig -a -t vnode  -u 0 -f image.iso
    mount -t cd9660 /dev/md0 /mnt/whatever

    umount /mnt/whatever
    mdconfig -d -u 0

# FreeBSD 4.x Mount

    vnconfig -c vn0c image.iso
    mount -t cd9660 /dev/vn0c /mnt/whatever

    umount /mnt/whatever
    vnconfig -u vn0c
    
    