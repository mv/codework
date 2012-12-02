
instance_id="i-2184263d"

 login='root'
sshkey='~/.ssh/sp-baby-production.pem'
sshkey='/work/mv-priv/awsenv/profiles/edenbr-prd/sp-baby-production.pem'
   ssh="ssh -i $sshkey -l $login "

log() {
  echo "$(date '+%F %X') - $@"
}

log "Instance: [$instance_id]"

## which server?
log "which server?"
server=$( aws din --simple       | grep $instance_id | awk '{print $3}' )
log "Server: [$server]"

# avzone=$( ec2-describe-instances | grep $instance_id | grep INSTANCE | awk '{print $11}' )
avzone=$( aws din | grep i-2184263d | awk -F\| '{print $10}' | awk -F= '{print $2}' )
log "AvZone: [$avzone]"


## connect to server
log "connect to server"

if ssh -i $sshkey -l $login $server 'uname -a'
then log "connect to server: OK"
else log "connect to server: ERROR"
     log "Exiting..."
     exit 1
fi

## new EBS volume
log "Disk size"
#isk_size=`ssh -i $sshkey -l $login $server 'set -x ; device=$( df / | awk "/dev/ {print \\$1}") ; echo $device ; fdisk -l $device | grep $device | awk "{print \\$5}" ' `
disk_size=`ssh -i $sshkey -l $login $server 'device=$( df / | awk "/dev/ {print \\$1}") ; fdisk -l $device | grep $device | awk "{print \\$5}" ' `
disk_size=$(( $disk_size/1024/1024/1024 ))
log "Disk size: $disk_size G"


log "Creating a new volume"
volume_id=$( aws create-volume --size $disk_size --zone $avzone | awk -F\| '/vol-/ {print $3}' )

log "New volume: [$volume_id]"

while aws describe-volumes | grep $volume_id | grep -v available
do log "Waiting for $volume_id"
   sleep 1
done

log "New volume: [$volume_id]: done."


log "Attaching volume"
aws attach-volume $volume_id -i $instance_id -d /dev/sdp

while aws describe-volumes | grep $volume_id | grep -v in-use
do log "Waiting for $volume_id"
   sleep 1
done

log "Attaching volume: [$volume_id]: done."

log "Partitioning to new volume"

cmd='
  while ! fdisk -l /dev/xvdp | grep /dev/xvdp ;
  do echo "Waiting for fdisk to detect volume ..."; sleep 1;
  done;
  ( echo p; echo n; echo p; echo 1; echo ; echo ; echo w; ) | fdisk /dev/xvdp > /dev/null;
  fdisk -l /dev/xvdp;
  mkfs.ext4 /dev/xvdp1;
'

log ssh -i $sshkey -l $login $server $cmd
    ssh -i $sshkey -l $login $server $cmd


log "Mounting new volume"
ssh -i $sshkey -l $login $server 'mkdir -p /mnt/ebs && mount -t ext4 /dev/xvdp1 /mnt/ebs'


cmd='
  device=$( df / | awk "/dev/ {print \$1}")          ; echo $device ;
  time dd if=$device of=/dev/xvdp1 bs=10240 & pid=$! ; echo $pid    ;
  sleep 1 ;
  while [ -d /proc/$pid ] ; do kill -USR1 $pid && sleep 5 ; done
'
# log "Checking new volume"
# ssh -i $sshkey -l $login $server 'fsck -y /dev/xvdp1'

log "Copying to new volume"
cmd='
  time rsync -aHx /    /mnt/ebs;
  time rsync -aHx /dev /mnt/ebs;
  sync;sync;sync;sync ;
  e2label /dev/xvdp1 ROOT;
  umount /mnt/ebs
'
ssh -i $sshkey -l $login $server $cmd

log "Snapshot volume"
snap_id=$( aws create-snapshot $volume_id --description "/dev/xvdp1 to EBS root" | grep $volume_id | awk '{print $4}' )

while aws describe-snapshots | grep $snap_id | grep -v completed > /dev/null
do
  log "Waiting for snapshot"
  sleep 5
done
log "Snapshot volume: completed"

log "Register ami"
ami_id=$( ec2-register \
            --architecture x86_64               \
            --name         "Test_${snap_id}"    \
            --description  "Converted from $instance_id" \
            --root-device-name "/dev/sda1"          \
            -b "/dev/sda1=$snap_id:$disk_size:true" \
            | awk '{print $2}' )

# --kernel
# --ramdisk
# --snapshot $snap_id

# while aws dim -o self | grep $ami_id | awk '{print $2,$4,$6}' | grep -v available
# do sleep 1
# done
log "AMI: completed"



log "========="
log "========= Undo: what you should do..."
log "========="

log aws detach-volume $volume_id
log aws delete-volume $volume_id

log aws deregister      $ami_id
log aws delete-snapshot $snap_id

log "========="
log "========= Summary"
log "========="
log "Reference Server: $server"
log "        Instance: $instance_id"
log "       Disk size: $disk_size"
log "  Volume created: $volume_id"
log "Snapshot created: $snap_id"
log "     AMI created: $ami_id"


