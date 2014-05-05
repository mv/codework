


    # List of devices
    fdisk -l | grep dev | grep bytes
    lsblk

    # list of partitions
    partx -l /dev/xvdj

    # Refreshing/Adding partitions, if necessary
    partx -v -a /dev/xvdj  # ?

    # resizing
    resize2fs /dev/xvdj    # ext4: device
    xfs_growfs -d /mnt     # xfs: mount point

    # Adding a new disk
    mkfs -t ext4 /dev/xvdj

    mkdir /mnt/vol-j
    mount /dev/xvdj /mnt/vol-h



## Reference

    http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
    http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-expand-volume.html
    http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/storage_expand_partition.html