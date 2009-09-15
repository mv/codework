#!/bin/sh

#####################################################################
##
## Rcs_ID="$RCSfile: duplicate.sh,v $"
## Rcs_ID="$Revision: 1.2 $ $Date: 2000/02/03 22:06:55 $"
##
##  Original author: Robert Richardson
##  
#####################################################################

#
##########################################################################
# Begin site-specific configuration information

LOG=/var/log/osback.log

# End site-specific configuratation information
##########################################################################


# Backup the last 10 log files

if [ -f $LOG.0 ]
then

for i in $LOG.*
do
	NUM=`echo $i | cut -f3 -d"."`
	NEWNUM=`expr $NUM + 1`
	[ $NEWNUM -lt 10 ] && mv $i $LOG.$NEWNUM  || rm $i
done

fi

if [ -f $LOG ]; then
mv $LOG ${LOG}.0
fi

# Create the new log
#exec >> $LOG 2>&1
DATE=`date`
export DATE
PATH=$PATH:/bin:/usr/bin:/sbin:/usr/sbin:/usr/ucb:/etc:/usr/etc:/usr/local/bin

mail_sas ()
{
MAIL=root
LOG1=log1
> $LOG1
HOST=`hostname`
echo "Duplicate disk script did NOT complete - $ERROR"  >> $LOG1
mailx -s "DUPLICATE DISK SCRIPT DID *NOT* RUN" $MAIL < $LOG1
}

#		If /mnt is mounted, exit and complain					#
echo "Looking to see if mnt is currently mounted....\n"
MNTTHERE=`df -k | grep mnt | head -1 | awk '{print $6}' | awk -F/ '{print $2}'`
if [ "$MNTTHERE" = mnt ]
then
	echo "\n$Something is already mounted on /mnt, exiting osback.sh...\n"
	ERROR="Something already mounted on /mnt, exiting..."
	mail_sas
	exit 1
else
	echo "Nothing is currently mounted on /mnt.  Good!"
fi

############################################################################
#Determine which drive we are currently booted off of.  The OTHER drive
#will be the one we duplicate to.

echo "Determining the currently booted disk, architecture, and alternate disk."

DISK=`df -k | grep '/c0t' | head -1 | awk -F/ '{print $4}' | cut -c1-4`

PLATFORM=`uname -m`
HARDWARE=`uname -i`
 
case "$PLATFORM" in
	"sun4d" | "sun4u")
	case $HARDWARE in
		*Ultra-250* )

		#The 250's only have c0t0 and c0t8, however, there is no
		#devalias for disk8.  Disk1 is actually aliased to target 8
		#on a default 250 setup. Therefore, we dd to c0t8, but boot
		#off of disk1

		if [ "$DISK" = c0t0 ]
		then
			ALTERNATE=c0t8
			PRIMARY=disk0
			SECONDARY=disk1
		else
			ALTERNATE=c0t0
			PRIMARY=disk1
			SECONDARY=disk0
		fi
		;;
		* )
		if [ "$DISK" = c0t0 ]
		then
			ALTERNATE=c0t1
			PRIMARY=disk0
			SECONDARY=disk1
		else
			ALTERNATE=c0t0
			PRIMARY=disk1
			SECONDARY=disk0
		fi
		;;
	esac
	;;
	"sun4m")
			if [ "$DISK" = c0t3 ]
			then
				ALTERNATE=c0t1
				PRIMARY=disk
				SECONDARY=disk1
			else
				ALTERNATE=c0t3
				PRIMARY=disk1
				SECONDARY=disk
			fi
	;;
esac

export ALTERNATE PRIMARY SECONDAY
echo "\nThe alternate boot disk is now $ALTERNATE"
echo "\n${DISK}'s data will be duplicated to: $ALTERNATE"

echo "\nThe machine's platform is $PLATFORM"

#########################################################################
# check for existence of /usr/local/data

#if [ ! -d /usr/local/data ] 
#then
#mkdir /usr/local/data
#chmod 744 /usr/local/data
#fi

# Define log files for format commands
GET_FORMAT_LOG=/var/log/format.get.log
PUT_FORMAT_LOG=/var/log/format.put.log

# Define the name of the disk/partition definition to save in /etc/format.dat
PARTITION_NAME=`hostname`

# Move /etc/format.dat out of the way if one exists
if [ -f /etc/format.dat ]
	then
	mv /etc/format.dat /etc/format.dat.save
fi

# Determine status of disk0/disk1 formats and sync as needed
prtvtoc -h /dev/rdsk/"$DISK"d0s2 |awk '{print $1,$2,$3,$4,$5,$6}' > /tmp/"$DISK".format
prtvtoc -h /dev/rdsk/"$ALTERNATE"d0s2 |awk '{print $1,$2,$3,$4,$5,$6}' > /tmp/"$ALTERNATE".format
diff /tmp/"$DISK".format /tmp/"$ALTERNATE".format > /tmp/format.diff
FORMAT_DIFF=`wc -l /tmp/format.diff |awk '{print $1}'`
if [ $FORMAT_DIFF = "0" ]
then
	echo " $ALTERNATE already formatted the same as $DISK"
	mv /etc/format.dat.save /etc/format.dat
else
	echo "Formatting $ALTERNATE disk as duplicate of $DISK disk...."

	# Gather formatting info from boot disk and store in /etc/format.dat
	format -d "$DISK"d0 << EOF
partition
name
"$PARTITION_NAME"
quit
save
"/etc/format.dat"
quit
EOF
	# End of EOF for gather of root disk format info

	# Format alternate disk using data gathered from boot disk
	format -d "$ALTERNATE"d0 << EOF
type
1
partition
select
0
label
y
quit
quit
EOF
# End of EOF for alternate disk format

fi

prtvtoc -h /dev/rdsk/"$DISK"d0s2 |awk '{print $1,$2,$3,$4,$5,$6}' > /tmp/"$DISK".format.new
prtvtoc -h /dev/rdsk/"$ALTERNATE"d0s2 |awk '{print $1,$2,$3,$4,$5,$6}' > /tmp/"$ALTERNATE".format.new
diff /tmp/"$DISK".format.new /tmp/"$ALTERNATE".format.new > /tmp/format.diff.new
FORMAT_DIFF=`wc -l /tmp/format.diff.new |awk '{print $1}'`
if [ $FORMAT_DIFF = "0" ]
then
	echo ""
	echo "Done formatting $ALTERNATE disk"
else
	echo ""
	echo "Unable to format $ALTERNATE disk as duplicate of $DISK disk"
	echo "Exiting ....."
	ERROR="Unable to format $ALTERNATE disk as duplicate of $DISK disk"
	mail_sas
	exit 1
fi

# Create new file systems on alternate disk

echo "\nCreating new file systems..."

for SLICE in `df -k | grep c0t |grep -v cdrom |  cut -c 17`
do
	newfs /dev/rdsk/${ALTERNATE}d0s$SLICE << EOF
y
EOF

	if [ $? -gt 0 ] ; then
		echo "Newfs failed on /dev/rdsk/${ALTERNATE}d0s${SLICE}."
		ERROR="newfs did not complete successfully"
		mail_sas
		exit 1
	fi
	fsck /dev/rdsk/${ALTERNATE}d0s$SLICE
done

#####################################################################
#Mount each partition, back up and restore to it.

echo "Copying current operating systems to alternate disk using ufsdump|ufsrestore."

DISK=`df -k | grep c0t | sed -n '1p' | cut -d/ -f4 | cut -c1-4`
CT=1
for MOUNTPOINT in `df -k | grep "$DISK" | awk '{print $6}' | sed 's/\//\/mnt\//'`
	do
	i=`df -k | grep c0t |  cut -c 17|head -$CT | tail -1`
	DISK_ORIG=`df -k | grep $DISK | awk '{print $6}' |head -$CT | tail -1`
	CT=`expr $CT + 1`
	mount /dev/dsk/${ALTERNATE}d0s$i $MOUNTPOINT
	cd $MOUNTPOINT
	ufsdump 0sf 160000 - $DISK_ORIG | ufsrestore -rf - > /dev/null
	if [ $? != "0" ]
	then
		 echo ""
		 echo "Restore of /dev/dsk/${ALTERNATE}d0s$i failed, please check...."
		 echo "		The boot device order was set to: $NEWSETUP"
		 echo "		Resetting eeprom boot device order ......"
		 echo ""
		 eeprom boot-device="$PRIMARY $SECONDARY"
		 NEWSETUP=`eeprom boot-device | cut -d= -f2`
		 echo "The boot device order is reset to: $NEWSETUP due to ufsdump failure"

		 ERROR="ufsdump|ufsrestore of /dev/dsk/${ALTERNATE}d0s$i failed"
		 mail_sas
		 exit 1
	else
		 echo "ufsdump from $DISK $DISK_ORIG to $ALTERNATE $DISK_ORIG was successfull...."
		 /bin/rm restoresymtable
		 sync;sync;sync
	fi
	cd /
done

#####################################################################
#Copy the vfstab

echo "COPYING THE	<< VFSTAB >>  FILE FROM /ETC"
echo ""
DISK=`df -k | grep c0t | sed -n '1p' | cut -d/ -f4 | cut -c1-4`
sed -e "s/$DISK/$ALTERNATE/g" /etc/vfstab > /mnt/etc/vfstab
#####################################################################

#####################################################################
#Install the boot block

SPAR=`uname -i` 
echo "INSTALLING THE << BOOT BLOCK >> TO THE BACKUP FILE SYSTEM"
echo ""
cd /mnt
installboot /usr/platform/${SPAR}/lib/fs/ufs/bootblk /dev/rdsk/${ALTERNATE}d0s0
cd /
echo "UNMOUNTING ALL << /MNT >> FILE SYSTEMS"
echo ""
# Added the umount statements below - Robert Richardson
for i in `df -k |grep $ALTERNATE | awk '{print $6}' | sort -r`
do 
echo "Unmounting $i"
umount $i
done
echo ""
echo "Unmounting of all /mnt filesystems completed"
echo ""

#####################################################################
#This changed to boot-device paramater so that the system will boot from
#the alternate disk

echo "The system was booting from:  $PRIMARY"
eeprom boot-device="$SECONDARY $PRIMARY"
#
NEWSETUP=`eeprom boot-device | cut -d= -f2`
echo "The boot order is now set to: $NEWSETUP"

echo ""
echo "Boot disk duplication script completed at `/usr/bin/date`"
echo ""
