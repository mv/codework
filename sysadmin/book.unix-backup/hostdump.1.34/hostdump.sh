#!/bin/sh
#
#
###################################################################
#
# Rcs_ID="$RCSfile: hostdump.sh,v $"
# Rcs_ID="$Revision: 1.34 $ $Date: 2000/12/14 09:36:05 $"
#
# Authors: Curtis Preston
# (Inspired by a script written by Andrew Blair that backed up Ultrix systems.)
#
###################################################################
#

BINDIR="CHANGEME"

if [ "$BINDIR" = "CHANGEME" ] ; then
	echo "You must change the value of BINDIR in $0 to the name"
	echo "of the directory where you installed $0 and accompanying"
	echo "scripts."
fi

Usage()
{
[ "$DEBUG" = Y ] && set -x
 echo "
Usage:  $SCRIPT level device log_file system_list

 Where:
  level           = Valid dump level (e.g. 0-9)
  device          = NO REWIND Tape Drive (e.g. /dev/rmt/0cn)
                    OR, a directory to backup to (e.g. a removable zip disk)
  log_file        = FULL Pathname of log file for this backup
  system_list     = List of systems or file systems to back up

Examples:

$SCRIPT 0 /dev/rmt/0n /tmp/backup/log apollo elvis bambi

$SCRIPT 0 /zipdrive/backupdir /tmp/backup/log apollo elvis bambi

You can give just a list of system names to $SCRIPT.  If you do do this,
this script will automatically backup all filesystems on the systems that
you list, excluding any that you list in a file called /etc/\$FSTAB.exclude.
(Where \$FSTAB is the name of the fstab file for that platform. For example,
on Solaris you would have an /etc/vfstab.exclude.)

$SCRIPT 0 /dev/rmt/0n /tmp/backup/log apollo:/ apollo:/usr elvis:/ bambi:/

If you list the file systems one by one, as in the second option above,
it will backup ONLY those filesystems that you list."

}
Log_err()
{
[ "$DEBUG" = Y ] && set -x
 #This function determines the success of a previous command, and performs
 #the following actions: Puts the error in a log that will be mailed and in
 #the master log for this session, and exits the script after running the mail
 #function (if the third argument is "exit").

 STATUS=$1 ; ERR_MESS=$2
 if [ $STATUS -gt 0 ] ; then
  echo 
  echo "$ERR_MESS" >> $TMP/$X.MAIL.LOG
  [ -n "$LOG" ] && echo "$ERR_MESS" >> $LOG
  if [ "$3" = exit ] ; then
   Mail_logs
   exit 1
  fi
 fi
}
Mail_logs()
{
[ "$DEBUG" = Y ] && set -x
 #The only thing that is put in the MAIL.LOG is errors, so if there are
 #any, then mail them with notification
 if [ -s $TMP/$X.MAIL.LOG ] ; then
  echo
  echo "Backup error message from $SERVER, trying to do a backup." \
   |tee $TMP/$X.MAIL.TMP
  echo "$SCRIPT received these arguments: $ARGS" | tee -a $TMP/$X.MAIL.TMP
  cat $TMP/$X.MAIL.LOG | tee -a $TMP/$X.MAIL.TMP
  cat $TMP/$X.MAIL.TMP | $L_MAIL $L_S "Backup_Status" $ADMINS
 else
  if [ -n "$SUCCESSMAIL" ] ; then
   echo "The following backup completed with no errors:" >$TMP/$X.MAIL.TMP
   echo "$SCRIPT $ARGS" >> $TMP/$X.MAIL.TMP
   cat $TMP/$X.MAIL.TMP | $L_MAIL $L_S "Backup_Status" $ADMINS
  fi
 fi
  [ -n "$TMP/$X*" ] && rm -f $TMP/$X.* $TMP/BACKUP.LABEL
}
Check_fs_type()
{
[ "$DEBUG" = Y ] && set -x
 case $REMOTE_OSnR in 
 *aix* )
  #This awk line is required to turn the multi-line, stanza format
  #of aix's /etc/filesystems into a single-line variable
  FSTYPE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB |grep -v '^\*' \
   |awk '$0 ~ /^\/.*:/ { printf $0 } $0 ~ /vfs.*=/ { print $0 }' \
   |sed 's/	 //g' \
   |sed 's/[	 ][	 ]*vfs[	 ][	 ]*=[	 ][	 ]*//' \
   |grep "^/" |egrep -v ':cdrfs|:nfs|/tmp:' \
   |grep "$FILE_SYS:"|awk -F: '{print $2}'`
 ;;
 *bsdi*|*dgux*|*freebsd*|*next*|*osf*|*irix*|*ultrix*|*sunos*|*convex*|*linux*)
  FSTYPE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -v '^#|:' \
   | egrep "^/|#.*advfs" |grep -v '#.*#.*advfs' |awk '{ print $2":"$3 }' \
   | egrep -v ':swap|:nfs|:proc|:iso9660|:nucfs|:dos|:cd*fs' \
   | egrep -v ':rfs|:tmp|:hsfs|:swapfs|:ignore|:procf*s*'\
   | egrep -v ':pcfs|:dos|:msdos|/tmp:|^\(.*\):' \
   |grep "$FILE_SYS:"|awk -F: '{print $2}'`
 ;;
 *hpux9* )
  FSTYPE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -v '^#|:' \
   | grep "^/" |awk '{ print $2":"$3 }' \
   | egrep -v ':swapf*s*|:nfs|:proc|:cdfs|:ignore' \
   | egrep -v '/tmp:|^\(.*\):' \
   |grep "$FILE_SYS:"|awk -F: '{print $2}'`
 ;;
 *hpux10* )
  FSTYPE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -v '^#|:' \
   | grep "^/" |awk '{ print $2":"$3 }' \
   | egrep -vi ':swapf*s*|:nfs|:ignore|:cdfs|:nfs' \
   | egrep -v '/tmp:|^\(.*\):' \
   |grep "$FILE_SYS:"|awk -F: '{print $2}'`
 ;;
 *sysv4*)
  FSTYPE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -v '^#|:' \
   | grep "^/" | awk '{ print $3":"$4 }' \
   | egrep -v ':swap|:nfs|:procf*s*' \
   | egrep -v '/tmp:|/dev/fd:|/dev/dsk/f' \
   |grep "$FILE_SYS:"|awk -F: '{print $2}'`
 ;;
 *sco* )
  #This awk line is required because sco's fstab can go over multiple lines
  #each ending with a '\' until the last line.  This turns them into
  #one line, then chops out the extraneous data
  FSTYPE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB |egrep -v '^#|:' \
   |awk '$NF ~ /\\/ { printf $0 } $NF !~ /\\/ { print $0 }' \
   |sed 's/.*mountdir=//'|sed 's/[	 ].*fstyp=/:/' \
   |sed 's/[	 ].*//'egrep -vi ':HS|:DOS' \
   |grep "$FILE_SYS:"|awk -F: '{print $2}'`
 ;;
 *solaris* )
  FSTYPE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -vi ':|^#' \
   |grep '^/' |awk '{ print $3":"$4 }' \
   |egrep -v ':swap|:nfs|:hsfs|:proc|-:|/tmp:|/dev/fd:' \
   |grep "$FILE_SYS:"|awk -F: '{print $2}'`
 ;;
 esac
 [ -n "$FSTYPE" ] || FSTYPE=unk
}

Check_if_client_is_remote()
{
[ "$DEBUG" = Y ] && set -x
 if [ $CLIENT = $SERVER ] ; then
  RSH_IF_REMOTE=
  CLIENT_IF_REMOTE=
 else
  RSH_IF_REMOTE=$L_RSH
  CLIENT_IF_REMOTE=$CLIENT
 fi
 export RSH_IF_REMOTE CLIENT_IF_REMOTE
}

#Essential variables, that are needed even if we bomb out...


if [ ! -f $BINDIR/hostdump.sh ] ; then
	echo "There is a variable called BINDIR in this script, and it is"
	echo "either NOT set, or is set to the incorrect value."
	echo "Please edit $0 and set it to the name of the directory in which"
	echo "you installed this script."
	exit 1
fi

L_MAIL=mail
L_S=''
MESS=''
export BINDIR L_MAIL L_S MESS

#Set this variable to Y to turn on set -x for all functions
DEBUG=N
[ "$DEBUG" = Y ] && set -x

#config.guess is the GNU platform guessing script. Check to make sure it's there
if [ ! -f ${BINDIR}/config.guess -o ! -x ${BINDIR}/config.guess ] ; then
 Log_err $? "${BINDIR}/config.guess is missing or not executable!
 You may need to change the BINDIR variable in $0 to where you placed
 config.guess and $0.
 You may also need to set it's executable bit (chmod 755 config.guess)." exit
fi

#If you want to TRY to back up IRIX xfs file systems via the xfsdump program,
#Set the following variable to "YES."  Warning:  Your mileage may vary
#significantly backing up to other OS's, but it can work.  If you have
#ANY problems, just change this variable to NO (the default), and
#it will default back to cpio for xfs file systems

XFSDUMP=YES

SERVER=`uname -n 2>/dev/null|awk -F'.' '{print $1}'`
#If it doesn't return anything, try hostname
[ -n "$SERVER" ] || SERVER=`hostname|awk -F'.' '{print $1}'`

#Use config.guess to get OS-n-Revision (OSnR)
LOCAL_OSnR=`${BINDIR}/config.guess`
export LOCAL_OSnR

#List of id's to be mailed upon success or failure
ADMINS="root" 

#Will only mail on error if SUCCESSMAIL set to no
SUCCESSMAIL=no

SCRIPT=`basename $0` 
X=$$
ARGS=$*
TMP=/usr/tmp
DAY=`date +"%a"`
TMPDF=$TMP/$X.$SERVER
DEVSHORT=`echo $2|sed 's-/--g'`
export LOCAL_OSnR ADMINS SUCCESSMAIL SCRIPT X ARGS TMP DAY TMPDF DEVSHORT

#Most systems don't add much performance after a 64k blocking factor
#So I have hard-coded it to be 64.  Feel free to change it, but make
#sure you test it, to make sure you OS can write AND READ at the B_FACTOR
B_FACTOR=64

TMPLIST="$TMP/$X.$SCRIPT.$SERVER.$DEVSHORT.tmp.list"
INCLIST="$TMP/$X.$SCRIPT.$SERVER.$DEVSHORT.list"
export B_FACTOR TMPLIST INCLIST

cp /dev/null $TMPLIST 
 Log_err $? "Could not create $TMPLIST" exit
cp /dev/null $INCLIST
 Log_err $? "Could not create $INCLIST" exit

##############################################################

PATH=/bin:/usr/bin:/etc:/bin:/usr/ucb:/usr/sbin:/sbin:/usr/bsd:/usr/local/bin
export PATH

#Check for -h flag asking for help on command
if [ "$1" = -h ] ; then
 Usage ; exit
fi

ARGNUM=$#
LEVEL=$1
DEVICE=$2
LOG=$3
[ $ARGNUM -gt 3 ] && shift 3 #This will leave a list of clients
CLIENTS="$*"

. ${BINDIR}/localpath.sh

#Check for sufficient number of arguments
if [ $ARGNUM -lt 4 ] ; then
 Usage ; Log_err 1 "$SCRIPT (Missing arguments!): $ARGS" exit
fi

# validate the arguments
#

if [ $LEVEL -gt 9 -o $LEVEL -lt 0 ] ; then
 Log_err 1 "Invalid level for $DUMP (Should be 0-9): $LEVEL" exit
fi

TAPE=Y #Set default value of TAPE to Y, unless the DEVICE changes it

if [ ! -c $DEVICE ] ; then
 #If it's not a character device, then it must be a directory
 if [ -d $DEVICE ] ; then
  #If the backup device that you've specified is a directory, then backup to disk
  TAPE=N
  DEVICE_BASE=$DEVICE/hostdumps
  [ -d $DEVICE_BASE ] || mkdir $DEVICE_BASE
 else
  #If it's not a directory, and it's not a character device, it's not right!
  Log_err 1 "Invalid device (Not a character device or a directory): $DEVICE" exit
 fi
fi

cp /dev/null $LOG
Log_err $? "Could not create output file: $LOG" exit

echo "==========================================================" |tee -a $LOG
echo "Beginning level $LEVEL backup of the following"             |tee -a $LOG
echo "clients: $CLIENTS"                                          |tee -a $LOG
echo "This backup is going to $SERVER:$DEVICE"                    |tee -a $LOG
echo "and is being logged to $SERVER:$LOG"                        |tee -a $LOG
echo "==========================================================" |tee -a $LOG

#LOGDIR will get lots of logs during this backup that you can use to check
#status.  Each file system gets a separate log, and each host gets two logs,
#the one for this backup, and a running log for history purposes

BACKUPHOME=/var/log
[ -d $BACKUPHOME ] || mkdir $BACKUPHOME
Log_err $? "Could not verify or create $BACKUPHOME: $LOG" exit
LOGDIR=${BACKUPHOME}/backuplogs
[ -d $LOGDIR ] || mkdir $LOGDIR 
Log_err $? "Could not verify or create $LOGDIR: $LOG" exit

#The script will now take the list of servers to back up, and check their
#"fstab" files, and create its own list of file systems to back up.
#It can also support being given a special list to use from the command
#line.

echo | tee -a $LOG
echo "Querying clients to determine which file systems to back up..." \
 |tee -a $LOG
echo | tee -a $LOG

for INCLUDE_HOST in $CLIENTS
do

 #Zero out these values, because we check them for that
 CLIENT= ; FILE_SYS=

 #Allow for "Partial" feature.
 #User can list hostname:/file_system on the command line, instead of
 #just the hostname.  If that is done, only that file system will be
 #backed up on that host

 if [ -n "`echo  $INCLUDE_HOST|grep ':' `" ] ; then
  CLIENT=`echo $INCLUDE_HOST|awk -F: '{print $1}'`
  FILE_SYS=`echo $INCLUDE_HOST|awk -F: '{print $2}'`
 else
  CLIENT=$INCLUDE_HOST
 fi
  export CLIENT FILE_SYS

 Check_if_client_is_remote

 # Get name of client operating system and version
 if [ -n "$RSH_IF_REMOTE" ] ; then
  rcp ${BINDIR}/config.guess $CLIENT:$TMP
 else
  cp ${BINDIR}/config.guess $TMP
 fi

 RSH_TO_CLIENT1=$?

 REMOTE_OSnR=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $TMP/config.guess`
 RSH_TO_CLIENT2=$?
 export REMOTE_OSnR

 #If either of these fail, this will be non-zero
 RSH_TO_CLIENT=`expr $RSH_TO_CLIENT1 + $RSH_TO_CLIENT2`

 #This section is designed to see if this client can rsh back to this
 #Host.  If it cannot, then it cannot be backed up
 #Also, this is a good time to rsh over and touch the dumpdates file
 #This is because many versions of dump will not create this file if it
 #isn't already there.

 . ${BINDIR}/rempath.sh

 case $REMOTE_OSnR in
 *aix* )     $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *bsdi* )    $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *dgux* )    $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *freebsd* ) $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *hpux9* )   $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *hpux10* )  $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /var/adm/dumpdates ;;
 *irix* )    $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *sysv4* )   $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *next* )    $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *osf* )    $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates 
            $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/vdumpdates    ;;
 *sco* )     $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/ddates        ;;
 *sunos* )   $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *solaris* ) $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 *ultrix* )  $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_TOUCH /etc/dumpdates     ;;
 esac

 #Remove the file if it is there, then tell the client to create it
 rm -f $TMP/$X.$CLIENT.touchfile 2>/dev/null 

 if [ $SERVER = $CLIENT ] ; then
  touch $TMP/$X.$CLIENT.touchfile
 else
  $L_RSH $CLIENT "$R_RSH $SERVER $L_TOUCH $TMP/$X.$CLIENT.touchfile"
 fi

 #If it's there, then the rsh worked, if not, it failed
 [ -f $TMP/$X.$CLIENT.touchfile ] && RSH_FROM_CLIENT=0 || RSH_FROM_CLIENT=1

 case $REMOTE_OSnR in 
 *aix* )
  FSTAB=/etc/filesystems
 ;;
 *bsdi*|*dgux*|*freebsd*|*next*|*osf*|*irix*|*ultrix*|*sunos*|*convex*|*linux*)
  FSTAB=/etc/fstab
 ;;
 *hpux9* )
  FSTAB=/etc/checklist
 ;;
 *hpux10* )
  FSTAB=/etc/fstab
 ;;
 *sysv4*)
  FSTAB=/etc/vfstab
 ;;
 *sco* )
  FSTAB=/etc/default/filesys
 ;;
 *solaris* )
  FSTAB=/etc/vfstab
 ;;
 esac
 export FSTAB


 if [ $RSH_TO_CLIENT -eq 0 -a $RSH_FROM_CLIENT -eq 0 ] ; then
  if [ -z "$FILE_SYS" ] ; then

   #Then this is supposed to be a full system backup
   #So parse the "fstab" file for a list of all filesystems

   INCLUDE_EXCLUDE_SH=$X.FSTAB.exclude.include.sh

   echo "#!/bin/sh" > $TMP/$INCLUDE_EXCLUDE_SH
    Log_err $? "Could not create $TMP/$INCLUDE_EXCLUDE_SH" exit

   echo "[ -f $FSTAB.\$1 ] && $R_LS $FSTAB.\$1" >> $TMP/$INCLUDE_EXCLUDE_SH
    Log_err $? "Could not create $TMP/$INCLUDE_EXCLUDE_SH" exit

   chmod 755 $TMP/$INCLUDE_EXCLUDE_SH
    Log_err $? "Could not chmod $TMP/$INCLUDE_EXCLUDE_SH" exit

   if [ $SERVER != $CLIENT ] ; then
    rcp $TMP/$INCLUDE_EXCLUDE_SH $CLIENT:$TMP
   fi

   INCLUDE_ONLY=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $TMP/$INCLUDE_EXCLUDE_SH \
   only`

   if [ -z "$INCLUDE_ONLY" ] ; then

    #If there is an "$VFSTAB.only" file, that means to back up only the
    #file systems listed in it.  If there is NO such file, go ahead and
    #parse the fstab file.

    case $REMOTE_OSnR in 
    *aix* )
     #This awk line is required to turn the multi-line, stanza format
     #of aix's /etc/filesystems into a single-line variable
     $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB |grep -v '^\*' \
      |awk '$0 ~ /^\/.*:/ { printf $0 } $0 ~ /vfs.*=/ { print $0 }' \
      |sed 's/	 //g' \
      |sed 's/[	 ][	 ]*vfs[	 ][	 ]*=[	 ][	 ]*//' \
      |grep "^/" |egrep -v ':cdrfs|:nfs|/tmp:' >$TMPDF
    ;;
    *bsdi*|*dgux*|*freebsd*|*next*|*osf*|*irix*|*ultrix*|*sunos*|*convex*|*linux*)
     $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -v '^#|:' \
      | egrep "^/|#.*advfs" |grep -v '#.*#.*advfs' |awk '{ print $2":"$3 }' \
      | egrep -v ':swap|:nfs|:proc|:iso9660|:nucfs|:dos|:cd*fs' \
      | egrep -v ':rfs|:tmp|:hsfs|:swapfs|:ignore|:procf*s*' \
      | egrep -v ':pcfs|:dos|:msdos|/tmp:|^\(.*\):' >$TMPDF
    ;;
    *hpux9* )
     $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -v '^#|:' \
      | grep "^/" |awk '{ print $2":"$3 }' \
      | egrep -v ':swapf*s*|:nfs|:proc|:cdfs|:ignore' \
      | egrep -v '/tmp:|^\(.*\):' >$TMPDF
    ;;
    *hpux10* )
     $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -v '^#|:' \
      | grep "^/" |awk '{ print $2":"$3 }' \
      | egrep -vi ':swapf*s*|:nfs|:ignore|:cdfs|:nfs' \
      | egrep -v '/tmp:|^\(.*\):' \
      >$TMPDF
    ;;
    *sysv4*)
     $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -v '^#|:' \
      | grep "^/" | awk '{ print $3":"$4 }' \
      | egrep -v ':swap|:nfs|:procf*s*' \
      | egrep -v '/tmp:|/dev/fd:|/dev/dsk/f' >$TMPDF
    ;;
    *sco* )
     #This awk line is required because sco's fstab can go over multiple lines
     #each ending with a '\' until the last line.  This turns them into
     #one line, then chops out the extraneous data
     $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB |egrep -v '^#|:' \
      |awk '$NF ~ /\\/ { printf $0 } $NF !~ /\\/ { print $0 }' \
      |sed 's/.*mountdir=//'|sed 's/[	 ].*fstyp=/:/' \
      |sed 's/[	 ].*//'egrep -vi ':HS|:DOS'  >$TMPDF
    ;;
    *solaris* )
     $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB | egrep -vi ':|^#' \
      |grep '^/' |awk '{ print $3":"$4 }' \
      |egrep -v ':swap|:nfs|:hsfs|:proc|-:|/tmp:|/dev/fd:' >$TMPDF
    ;;
    *)
     #have to touch the file, or the rest would barf
     touch $TMPDF
     Log_err 1 "WARNING, $CLIENT_OS NOT supported, $HOST will not be backed up!"
    ;;
    esac
   else
     echo '*****************************************************'|tee -a $LOG
     echo "WARNING! This client has a $FSTAB.only file!"         |tee -a $LOG
     echo "ONLY file systems specified in that file will be backed up!" \
                                                                 |tee -a $LOG
     echo '*****************************************************'|tee -a $LOG
     #have to touch the file, or the rest would barf
     touch $TMPDF
   fi
 
   #Include and Exclude Section
   #Checks to see if there are any extra file systems to be included, or
   #If there are any ones that should be excluded

   EXCLUDEFILE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $TMP/$INCLUDE_EXCLUDE_SH \
    exclude`
   INCLUDEFILE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $TMP/$INCLUDE_EXCLUDE_SH \
    include`

   [ $SERVER != $CLIENT ] && $L_RSH $CLIENT $R_RM -f $TMP/$INCLUDE_EXCLUDE_SH
   
   for LINE in `cat $TMPDF`      #For each file system that was in the "fstab"
   do

    FILE_SYS=`echo $LINE|awk -F: '{print $1}'`

    #If there is an exclude file on the client, check to see if this
    #File system is in it

    if [ -n "$EXCLUDEFILE" ] ; then
     EXCLUDE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB.exclude \
      | grep "^${FILE_SYS}$"`
    else
     EXCLUDE=''
    fi

    #If it's not in the exclude file, then back it up, if so, then skip it

    if [ -z "$EXCLUDE" ] ; then
     echo $N "Including \"$CLIENT:$FILE_SYS:$REMOTE_OSnR\" $C" \
      |tee -a $LOG
     echo "in backup include list." |tee -a $LOG
     echo $CLIENT:$LINE:$REMOTE_OSnR >> $TMPLIST
    else
     echo "Excluding \"$CLIENT:$FILE_SYS\" from backup include list." \
      |tee -a $LOG
     echo "	(\"$FILE_SYS\" is in $CLIENT:$FSTAB.exclude.)" |tee -a $LOG
    fi

   done

   if [ -n "$INCLUDEFILE" -o -n "$INCLUDE_ONLY" ] ; then
    #There is an extra includefile. Use it.

    if [ -n "$INCLUDE_ONLY" ] ; then
     INCLUDE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB.only \
      | grep -v '^#'`
    else
     INCLUDE=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_CAT $FSTAB.include \
      | grep -v '^#'`
    fi

    if [ -n "$INCLUDE" ] ; then
     for FILE_SYS in $INCLUDE               #For each file system listed
     do
      Check_fs_type                         #Get the type of file system it is
                                            #And add it to the list w/ the type
      echo "$CLIENT:$FILE_SYS:$FSTYPE:$REMOTE_OSnR" >> $TMPLIST
      echo $N "Adding \"$CLIENT:$FILE_SYS:$FSTYPE:$REMOTE_OSnR\" $C"\
       |tee -a $LOG
      echo "to backup include list" |tee -a $LOG
      if [ -n "$INCLUDE_ONLY" ] ; then
       echo "	(\"$CLIENT:$FILE_SYS\" is in $CLIENT:$FSTAB.only.)" \
        |tee -a $LOG
      else
       echo "	(\"$CLIENT:$FILE_SYS\" is in $CLIENT:$FSTAB.include.)" \
        |tee -a $LOG
      fi
     done
    fi
   fi

  else #Else this is not a full system backup.  It has a special include list
 
   Check_fs_type
   echo $N "Including \"$CLIENT:$FILE_SYS:$FSTYPE:$REMOTE_OSnR\" $C" |tee -a $LOG
   echo "in backup include list." |tee -a $LOG
   echo "$CLIENT:$FILE_SYS:$FSTYPE:$REMOTE_OSnR" >> $TMPLIST
  fi

 else #Else there were problems rsh'ing to this client
  if [ $RSH_TO_CLIENT -eq 1 ] ; then
   Log_err 1 "WARNING, Could not $L_RSH to $CLIENT. It will not be backed up!" 
  else
   Log_err 1 "WARNING! Could not $R_RSH from $CLIENT to $SERVER. $C"
   Log_err 1 "It will not be backed up!"
  fi
 fi
done #done determining the file systems to backup

#Sometimes, fstab's can be out of date, or incorrect.  This sometimes results
#in filesystems being included in the backup which no longer exist 
#This section will check to make sure that they exist, and that something is
#in them.  (That way, if it's just a mount point left, it won't get backed up.)

echo |tee -a $LOG
echo "Now checking that each file system is a valid directory..."|tee -a $LOG
echo |tee -a $LOG

cp /dev/null $TMPLIST.tmp
Log_err $? "Could not create $TMPLIST.tmp" exit

for LINE in `cat $TMPLIST`  #For each filesystem listed in the temporary list
do

 #This sets the path for the remote cat,grep,egrep,touch, etc. commands
 . ${BINDIR}/rempath.sh

 CLIENT=`echo $LINE|awk -F: '{print $1}'`
 FILE_SYS=`echo $LINE|awk -F: '{print $2}'`

cat >$TMP/$X.DIR.TEST <<EOF_DIR
#!/bin/sh

if [ -d $FILE_SYS ] ; then
 df $FILE_SYS >/dev/null
 if [ \$? -gt 0  ] ; then
  $R_ECHO "NOTVAL" ; exit
 fi
else
 $R_ECHO "NODIR" ; exit
fi
[ -z "\`ls $FILE_SYS/\* 2>/dev/null\`" ] || $R_ECHO "NOFILES"
EOF_DIR

 Check_if_client_is_remote

 # Get name of client operating system and version

 chmod 755 $TMP/$X.DIR.TEST
  Log_err $? "Could not chmod $TMP/$X.DIR.TEST" exit

 [ -n "$RSH_IF_REMOTE" ] && rcp $TMP/$X.DIR.TEST $CLIENT:$TMP

 #Run the directory test script on the client
 DIRTEST=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $TMP/$X.DIR.TEST`
 $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_RM -f $TMP/$X.DIR.TEST

 if [ -z "$DIRTEST" ] ; then
  echo "$LINE" >>$TMPLIST.tmp
 else
   case $DIRTEST in
   NOTVAL )
   echo $N "Directory $FILE_SYS is not a valid file system on $CLIENT! $C" \
    |tee -a $LOG
   echo "It will not be backed up!" |tee -a $LOG
   ;;
   NODIR )
   echo $N "Directory $FILE_SYS does not exist on $CLIENT! $C" |tee -a $LOG
   echo "It will not be backed up!" |tee -a $LOG
   ;;
   NOFILES )
   echo $N "Directory $FILE_SYS on $CLIENT is empty! $C" |tee -a $LOG
   echo "It will not be backed up!" |tee -a $LOG
   ;;
   esac
 fi
done #done making sure that all file systems exist on the client

mv $TMPLIST.tmp $TMPLIST

#Now take each of the file systems and systems listed, and see which backup
#command should be used.  If dump is available for that type of file system
#then use it, otherwise, use cpio.  (BTW, the reasons to use cpio vs. tar
#were that cpio will preserve the access times of your files, like dump, and it
#will also support an include list from STDIN, so we can still perform
#full an incremental dumps through the use of a touch file.

echo |tee -a $LOG
echo "Determining the appropriate backup commands..." |tee -a $LOG
echo |tee -a $LOG

for LINE in `cat $TMPLIST`  #For each filesystem listed in the temporary list
do

 #Default values before heading into this case statement

 #These two values are hard-coded to make dump think the tape is HUGE.  
 #I don't use them the way they are written for a lot of reasons.
 #But you have to use them on some dumps, or dump will think the tape
 #is smaller than it actually is.  (Some versions have removed these.)
 #THEY DO NOT affect how the data is actually written on the tape

 DENSITY='80000'
 SIZE='150000'

 DUMP=/etc/dump        ; RDUMP=/etc/rdump
 RESTORE=/etc/restore  ; RRESTORE=/etc/rrestore
 D_OPTS="${LEVEL}bdsfnu~$B_FACTOR~$DENSITY~$SIZE"
 R_OPTS="tbfy~$B_FACTOR"

 #Get the Client's OS and file system type from the list
 CLIENT=`echo $LINE|awk -F: '{print $1}'`
 REMOTE_OSnR=`echo $LINE|awk -F: '{print $4}'`
 export REMOTE_OSnR
 FSTYPE=`echo $LINE|awk -F: '{print $3}'`

 # Get name of client operating system and version

 case $REMOTE_OSnR in
 *aix* )
  case $FSTYPE in
  jfs )
   DUMP=/usr/sbin/backup                        ; RDUMP=/usr/sbin/rdump
   RESTORE=/usr/sbin/restore                    ; RRESTORE=/usr/sbin/rrestore

   #AIX's restore asks for a -q option to keep from prompting for a tape,
   #But it only wants it on restore, not rrestore
   #Also backup wants -c, where rdump wants old -d and -s

   if [ $SERVER = $CLIENT ] ; then
    R_OPTS="-tvy~-q~-b~$B_FACTOR~-f"
    D_OPTS="-${LEVEL}~-b~${B_FACTOR}~-c~-u~-f"
   else
    R_OPTS="-tvy~-b~$B_FACTOR~-f"
    D_OPTS="-${LEVEL}~-b~${B_FACTOR}~-d~${DENSITY}~-s~${SIZE}~-c~-u~-f"
   fi

  ;;
  * )
   DUMP=/usr/bin/cpio
  ;;
  esac
 ;; #end of aix
 *bsdi* )
  case $FSTYPE  in
  ufs )
  ;;
  * )
   DUMP=/usr/bin/pax
  ;;
  esac
 ;; #enc of bsdi
 *convex* )
  case $FSTYPE in
  4.2 )
  ;;
  * )
   DUMP=/bin/cpio
  ;;
  esac
 ;; #end of convex
 *dgux* )
  case $FSTYPE  in
  dg/ux )
  ;;
  * )
   DUMP=/usr/bin/cpio
  ;;
  esac
 ;; #end of dgux
 *freebsd* )
  case $FSTYPE  in
  ufs )
  ;;
  * )
   DUMP=/usr/bin/cpio
  ;;
  esac
 ;; #end of freebsd
 *hpux9* )
  case $FSTYPE in
  hfs )
   DUMP=/etc/dump                               ; RDUMP=/etc/rdump
   RESTORE=/etc/restore                         ; RRESTORE=/etc/rrestore
  ;;
  vxfs )
   DUMP=/etc/vxdump                             ; RDUMP=/etc/vxdump
   RESTORE=/etc/vxrestore                       ; RRESTORE=/etc/vxrestore
  ;;
  * )
   DUMP=/bin/cpio
  ;;
  esac
 ;; #end of hp9
 *hpux10* )
  case $FSTYPE in
  hfs )
   DUMP=/usr/sbin/dump                          ; RDUMP=/usr/sbin/rdump
   RESTORE=/usr/sbin/restore                    ; RRESTORE=/usr/sbin/rrestore
  ;;
  vxfs )
   DUMP=/usr/sbin/vxdump                        ; RDUMP=/usr/sbin/rvxdump
   RESTORE=/usr/sbin/vxrestore                  ; RRESTORE=/usr/sbin/rvxrestore
  ;;
  * )
   DUMP=/usr/bin/cpio
  ;;
  esac
 ;; #end of hp10
 *irix* )
  case $FSTYPE in
  efs )
  ;;

  xfs )

  B_SIZE=`expr $B_FACTOR \* 1024`
  if [ "$XFSDUMP" = YES ] ; then
   DUMP=/usr/sbin/xfsdump       ; RDUMP=/usr/sbin/xfsdump
   RESTORE=/sbin/xfsrestore ; RRESTORE=/sbin/xfsrestore
   D_OPTS="-m~-b~$B_SIZE~-o~-l~$LEVEL~-F~-f"
   R_OPTS="-t~-b~$B_SIZE~-v~silent~-m~-J~-F~-f"
  else
   DUMP=/sbin/cpio
  fi

  ;;
  * )
   DUMP=/sbin/cpio
  ;;
  esac
 ;; #end of irix
 *linux* )
 #The dump/restore package is an optional install under Linux, and it could also be in
 #multiple locations, so we have this elaborate test to see if it is there and where it is.

cat >$TMP/$X.DUMP.TEST <<EOF_DUMP
#!/bin/sh

for CMD in dump restore rdump rrestore cpio
do
  if [ -f /sbin/\$CMD ] ; then
   echo "\$CMD=/sbin/\$CMD"
  else
   if [ -f /usr/sbin/\$CMD ] ; then
    echo "\$CMD=/usr/sbin/\$CMD"
   else
    if [ -f /bin/\$CMD ] ; then
     echo "\$CMD=/bin/\$CMD"
    else
     if [ -f /usr/bin/\$CMD ] ; then
      echo "\$CMD=/usr/bin/\$CMD"
     fi
    fi
   fi
  fi
done
EOF_DUMP

 Check_if_client_is_remote

 chmod 755 $TMP/$X.DUMP.TEST
 Log_err $? "Could not chmod $TMP/$X.DUMP.TEST" exit

 [ -n "$RSH_IF_REMOTE" ] && rcp $TMP/$X.DUMP.TEST $CLIENT:$TMP

 #Run the dump test script on the client
 $RSH_IF_REMOTE $CLIENT_IF_REMOTE $TMP/$X.DUMP.TEST >$TMP/$X.DUMP.TEST.OUT
 $RSH_IF_REMOTE $CLIENT_IF_REMOTE $R_RM -f $TMP/$X.DUMP.TEST

 #Look for the commands, and make some variables called LIN_ for Linux dump/restore, etc.

 LIN_DUMP=`grep '^dump=' $TMP/$X.DUMP.TEST.OUT         |awk -F= '{print $2}'`
 LIN_RESTORE=`grep '^restore=' $TMP/$X.DUMP.TEST.OUT   |awk -F= '{print $2}'`
 LIN_RDUMP=`grep '^rdump=' $TMP/$X.DUMP.TEST.OUT       |awk -F= '{print $2}'`
 LIN_RRESTORE=`grep '^rrestore=' $TMP/$X.DUMP.TEST.OUT |awk -F= '{print $2}'`
 LIN_CPIO=`grep '^cpio=' $TMP/$X.DUMP.TEST.OUT         |awk -F= '{print $2}'`

 #If any of the dump/restore commands weren't found, use cpio instead

 if [ -z "$LIN_DUMP" -o -z "$LIN_RDUMP" -o -z "$LIN_RESTORE" -o -z "$LIN_RRESTORE" ] ; then
  LIN_DUMP=$LIN_CPIO ; LIN_RDUMP=$LIN_CPIO ; LIN_RESTORE=$LIN_CPIO ; LIN_RRESTORE=$LIN_CPIO
 fi

  case $FSTYPE in 
  ext*|ufs|sysv )
   DUMP=$LIN_DUMP                          ; RDUMP=$LIN_RDUMP
   RESTORE=$LIN_RESTORE                    ; RRESTORE=$LIN_RRESTORE
  ;;
  * )
   DUMP=$LIN_CPIO
  ;;
  esac
 ;; #end of linux
 *sysv4* )
  case $FSTYPE in 
  ufs )
   DUMP=/usr/sbin/ufsdump                       ; RDUMP=$DUMP
   RESTORE=/usr/sbin/ufsrestore                 ; RRESTORE=$RESTORE
  ;;
  vxfs )
   DUMP=/sbin/vdump                             ; RDUMP=/sbin/vdump
   RESTORE=/sbin/vrestore                       ; RRESTORE=/sbin/vrestore
  ;;
  * )
   DUMP=cpio
  ;;
  esac
 ;; #end of sysv4
 *osf* )
  case $FSTYPE in 
  ufs )
   DUMP=/usr/sbin/dump                          ; RDUMP=/usr/sbin/rdump
   RESTORE=/usr/sbin/restore                    ; RRESTORE=/usr/sbin/rrestore
   D_OPTS="-$LEVEL~-b~$B_FACTOR~-d~$DENSITY~-s~$SIZE~-c~-u~-f"
   R_OPTS="-t~-b~$B_FACTOR~-y~-f"
  ;;
  advfs )
   DUMP=/sbin/vdump                             ; RDUMP=/sbin/vdump
   RESTORE=/sbin/vrestore                       ; RRESTORE=/sbin/vrestore
   D_OPTS="-$LEVEL~-b~$B_FACTOR~-N~-x~8~-u~-f"
   R_OPTS="-t~-f"
  ;;
  * )
   DUMP=cpio
  ;;
  esac
 ;; #end of osf
 *sco* )
  case $FSTYPE in
  XENIX )
  ;;
  * )
   DUMP=cpio
  ;;
  esac
 ;; #end of sco
 #The lfs is the 'local file system' found on Auspex servers, which
 #report as sunos4 systems when you do a uname -sr
 *sunos* )
  case $FSTYPE in
  4.2|lfs )
  ;;
  * )
   DUMP=/usr/bin/cpio
  ;;
  esac
 ;; #end of sunos
 *solaris* )
  case $FSTYPE in 
  ufs )
   DUMP=/usr/sbin/ufsdump                       ; RDUMP=/usr/sbin/ufsdump
   RESTORE=/usr/sbin/ufsrestore                 ; RRESTORE=/usr/sbin/ufsrestore
  ;;
vxfs )
   DUMP=/usr/sbin/vxdump                        ; RDUMP=/usr/sbin/vxdump
   RESTORE=/usr/sbin/vxrestore                  ; RRESTORE=/usr/sbin/vxrestore
   D_OPTS="-nu~-$LEVEL~-b~$B_FACTOR~-B~1000000000~-f"
   R_OPTS="-ty~-b~$B_FACTOR~-f"
  ;;

  * )
   DUMP=/usr/bin/cpio
  ;;
  esac
 ;; #end of solaris
 *ultrix* )
  case $FSTYPE in
  ufs )
  ;;
  * )
   DUMP=cpio
  ;;
  esac
 ;; #end of ultrix
 esac

 #If the filesystem type was not found, use cpio
 if [ "`basename $DUMP`" = cpio ] ; then
  RDUMP=$DUMP    ; RESTORE=$DUMP  ; RRESTORE=$DUMP
  D_OPTS='-oacB' ; R_OPTS='-ictB'
 fi

 echo "$LINE:$DUMP:$RDUMP:$D_OPTS:$RESTORE:$RRESTORE:$R_OPTS:$LEVEL:$R_RSH:$B_FACTOR" >>$INCLIST

done #done determining the dump commands and options to use with each file sys

if [ "$TAPE" = Y ] ; then
 $L_MT $L_F $DEVICE $L_REWIND
 Log_err $? "Tape would not rewind with command: $L_MT $L_F $DEVICE $L_REWIND" exit
else
 DEVICE="${DEVICE_BASE}/label.level.$LEVEL"
 touch $DEVICE
 Log_err $? "Could not create backup file: $DEVICE" exit
fi

#sleep 20

LABEL="BACKUP.LABEL"
NUMFILES=`cat $INCLIST|wc -l|sed 's/ //g'`
NUMFILES=`expr $NUMFILES + 1`
cd $TMP

echo |tee -a $LOG
echo "---------------------------------------------------------" |tee -a $LOG
echo "Placing label of $LABEL as first file on $DEVICE" |tee -a $LOG
echo "(and verifying that $DEVICE is set to NO-REW...)" |tee -a $LOG
echo |tee -a $LOG
echo "Displaying contents of the label..." |tee -a $LOG
echo |tee -a $LOG

#Start making $LABEL that will go on the tape

cat >$LABEL <<EOF_HEAD

----------------------------------------------------------------------
This tape is a level $LEVEL backup made `date`
The following is a table of contents of this tape.
It is in the following format:
host:fs name:fs type:OS Version:dump cmmd:rdump cmmd:dump options \\
:restore cmmd: rrestore cmmd:restore options:LEVEL \\
:Client rsh command:Blocking factor
----------------------------------------------------------------------

EOF_HEAD

cat $INCLIST >>$LABEL

#Create one variable with list of hosts
for FSNAME in `awk -F: '{print $1}' $INCLIST|sort -u`
do
  echo $N "${FSNAME}_&_$C"
done >$TMP/$X.LIST.OF.SYSTEMS.BEING.BACKED.UP

echo >> $TMP/$X.LIST.OF.SYSTEMS.BEING.BACKED.UP

SAVESET="`cat $TMP/$X.LIST.OF.SYSTEMS.BEING.BACKED.UP|sed 's/_&_$//'`"
SAVESETLOGDIR=${LOGDIR}/$SAVESET
[ -d $SAVESETLOGDIR ] || mkdir $SAVESETLOGDIR 

cat >>$LABEL <<EOF_LABEL

---------------------------------------------------------------------- 
Also, the last file on this tape is a tar file containing a complete
flat file index of the tape.  To read it, issue the following commands:
cd $TMP
$L_MT $L_F $DEVICE fsf $NUMFILES
tar xvf $DEVICE

EOF_LABEL

#Add label to the log
cat $LABEL|tee -a $LOG

tar cf $DEVICE $LABEL >/dev/null
Log_err $? "Could not tar to tape $DEVICE!" exit

rm -f $LABEL 

if [ "$TAPE" = Y ] ; then
 TAPE_DID_REWIND=`tar tvf $DEVICE $LABEL 2>/dev/null|grep "$LABEL"`
 [ -z "$TAPE_DID_REWIND" ] && STAT=0 || STAT=1
 Log_err $STAT "$DEVICE is NOT a NO-REWIND device! (Try ${DEVICE}n)" exit

 $L_MT $L_F $DEVICE $L_REWIND
 Log_err $? "Tape would not rewind with command: $L_MT $L_F $DEVICE $L_REWIND" exit
fi

sleep 2

if [ "$TAPE" = Y ] ; then
 $L_MT $L_F $DEVICE fsf 1
 Log_err $? "Tape would not fsf with command: $L_MT $L_F $DEVICE fsf 1" exit
fi

sleep 2

#Initialize the file system counter
COUNT=1

echo |tee -a $LOG
echo "============================================================"|tee -a $LOG
echo "Now beginning the backups of all the systems listed above..."|tee -a $LOG
echo "============================================================"|tee -a $LOG
echo |tee -a $LOG

for LINE in `cat $INCLIST`
do

 #Parse out values from the line
 CLIENT=`echo $LINE|awk -F: '{print $1}'`
 FILE_SYS=`echo $LINE|awk -F: '{print $2}'`
 FSTYPE=`echo $LINE|awk -F: '{print $3}'`
 REMOTE_OSnR=`echo $LINE|awk -F: '{print $4}'`
 export REMOTE_OSnR
 DUMP=`echo $LINE|awk -F: '{print $5}'`
 RDUMP=`echo $LINE|awk -F: '{print $6}'`
 D_OPTS=`echo $LINE|awk -F: '{print $7}'|sed 's/~/ /g'`
 DOPTS=`echo $LINE|awk -F: '{print $7}'` #Used to create a unique log file
 RESTORE=`echo $LINE|awk -F: '{print $8}'`
 RRESTORE=`echo $LINE|awk -F: '{print $9}'`
 R_OPTS=`echo $LINE|awk -F: '{print $10}'|sed 's/~/ /g'`
 LEVEL=`echo $LINE|awk -F: '{print $11}'`
 R_RSH=`echo $LINE|awk -F: '{print $12}'`
 B_FACTOR=`echo $LINE|awk -F: '{print $13}'`
 FSNAME=`echo ${FILE_SYS}|sed 's-/-_-g'`

 [ "$FSNAME" = "_" ] && FSNAME='_root'
 DUMPBASE=`basename $DUMP`

 if [ "$TAPE" != Y ] ; then
  DEVICE="$DEVICE_BASE/${CLIENT}$FSNAME.$DUMPBASE.level.$LEVEL"
  touch $DEVICE
 fi

 . ${BINDIR}/rempath.sh
 Check_if_client_is_remote

 PRE_n_POST_SH="$X.PRE_n_POST_BACKUP.sh"

 cat >$TMP/$PRE_n_POST_SH <<EOF_PRE_POST
#!/bin/sh
[ -f /usr/local/bin/\$1 ] && $R_LS /usr/local/bin/\$1
EOF_PRE_POST

 chmod 755 $TMP/$PRE_n_POST_SH
 [ -n "$RSH_IF_REMOTE" ] && rcp $TMP/$PRE_n_POST_SH $CLIENT:$TMP

 PREBACKUP=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $TMP/$PRE_n_POST_SH \
  prebackup.sh`
 POSTBACKUP=`$RSH_IF_REMOTE $CLIENT_IF_REMOTE $TMP/$PRE_n_POST_SH \
  postbackup.sh`

 rm -f $TMP/$PRE_n_POST_SH
 [ -n "$RSH_IF_REMOTE" ] && $RSH_IF_REMOTE $CLIENT_IF_REMOTE \
  $R_RM -f $TMP/$PRE_n_POST_SH

 CURRENT_HOST_LOG=${LOGDIR}/${CLIENT}.current.log
 RUNNING_HOST_LOG=${LOGDIR}/${CLIENT}.running.log

 FSLOG=${SAVESETLOGDIR}/${CLIENT}${FSNAME}
 cp /dev/null $FSLOG
 Log_err $? "Could not create $FSLOG"

 #Check to see if this is the first file system being backed up 
 #For this client.  If so, run the prebackup script if there is one.

 FIRST_FILE_SYS=`grep $CLIENT $INCLIST \
  | awk -F: '{print $2}' | head -1 | grep -c "^${FILE_SYS}$"`

 if [ $FIRST_FILE_SYS -eq 1 ] ; then

 cp /dev/null $CURRENT_HOST_LOG
 Log_err $? "Could not create $CURRENT_HOST_LOG"

 echo "\n================================" |tee -a $CURRENT_HOST_LOG
 echo "Beginning $DUMP of $CLIENT: `date`" |tee -a $CURRENT_HOST_LOG

  if [ -n "$PREBACKUP" ] ; then
   $RSH_IF_REMOTE $CLIENT_IF_REMOTE /usr/local/bin/prebackup.sh |tee -a $CURRENT_HOST_LOG
  fi
 fi

 echo "\n-------------------------------------------------" |tee -a $FSLOG

 if  [ "$CLIENT" = "$SERVER" ] ; then

  if [ $DUMPBASE != cpio ] ; then

   echo $N "Backing up ${CLIENT}:${FILE_SYS} level $LEVEL $C" |tee -a $FSLOG
   echo "(File system ${COUNT})" |tee -a $FSLOG
 
   #sleep 5
   echo "Using Command: $DUMP $D_OPTS $DEVICE $FILE_SYS" |tee -a $FSLOG
   $DUMP $D_OPTS $DEVICE $FILE_SYS 2>&1 |tee -a $FSLOG
  else

   if [ $LEVEL -eq 0 ] ; then 
    NEWER=''
   else

    #This strange section of code is to ensure that if a user does an
    #incremental backup before they do a full backup, it will cause a
    #full backup, and record that a full was done

    cd $FILE_SYS

    #Start the record that we are doing a level $LEVEL backup
    touch DO_NOT_REMOVE.level.$LEVEL.cpio.touchfile 

    #Get the "number" of this level's log file.  If the number is one,
    #then that means that there are no DO_NOT_REMOVE file from any backups
    #that had a lower level than this one.  That means that it needs to
    #be a full backup

    FILENUM=`ls DO_NOT_REMOVE.level*|grep -n "DO_NOT_REMOVE.level\.$LEVEL\." \
     |awk -F: '{print $1}'`

    #This shouldn't ever happen, since I just made one, but you never know...
    [ -n "$FILENUM" ] || FILENUM=1

    #Get the number of the DO_NOT_REMOVE file that is one level less
    #than this one
    FILENUM=`expr $FILENUM - 1`

    if [ $FILENUM -eq 0 ] ; then

     #If the number is zero, then that means this is the first backup on
     #this machine, so we have to do a full.  Record that we did a full.
     NEWER=''
     touch DO_NOT_REMOVE.level.0.cpio.touchfile 

    else
     #If there is a file that is one level lower, use it for the -newer value
     NEWER="-newer `ls  DO_NOT_REMOVE.level.*|head -$FILENUM|tail -1`"
    fi
   fi

   [ -n "`echo $LOCAL_OSnR|grep irix`" ] && XDEV=mount || XDEV=xdev

   echo "Using Command: find . $NEWER -$XDEV -print|$DUMP $D_OPTS > $DEVICE"\
    |tee -a $FSLOG

   cd $FILE_SYS
   find . $NEWER -$XDEV -print | $DUMP $D_OPTS > $DEVICE 2>>$FSLOG

  fi
 
  if [ $? -eq 0 ] ; then

   DATE=`date +"%a %D %T"`
 
   echo $N "$DUMP $LEVEL Done $DATE from $CLIENT $C" |tee -a $FSLOG
   echo "$FILE_SYS on ${SERVER}:${DEVICE} $COUNT " |tee -a $FSLOG
  
  else

   DATE=`date +"%a %D %T"`
  
   echo "$DUMP $LEVEL NOT Done $DATE from $CLIENT $FILE_SYS on " \
    |tee -a $FSLOG
   echo "${SERVER}:${DEVICE} $COUNT" |tee -a $FSLOG

  fi

  #This next section is for the xfsdump command, which makes multiple
  #tape files per dump!

  FILECOUNT=`grep ' media file [0-9]' $FSLOG |tail -1 \
   |sed 's/.* media file //' |sed 's/ .*//g'`
  [ -n "$FILECOUNT" ] || FILECOUNT=0
  FILECOUNT=`expr $FILECOUNT + 1`
  sed "s+$LINE+$LINE:$FILECOUNT+" $INCLIST >$TMP/$$.inclist.tmp
  mv $TMP/$$.inclist.tmp $INCLIST

  COUNT=`expr $COUNT + $FILECOUNT`

  cat $FSLOG >> $CURRENT_HOST_LOG

 else #Else, it's a remote dump

  echo $N "Backing up ${CLIENT}:${FILE_SYS} level $LEVEL $C" |tee -a $FSLOG
  echo "(File system ${COUNT})" |tee -a $FSLOG

  TMP_DUMP_SH="$X.tmp.dump.script.sh"

  if [ $DUMPBASE != cpio ] ; then
   #sleep 5
   echo $N "Using Command: $L_RSH $CLIENT $RDUMP $D_OPTS $SERVER:$DEVICE $FILE_SYS" |tee -a $FSLOG
   
   #First, we make a little dump shell script that will run on the client

   cat >$TMP/$TMP_DUMP_SH <<EOF_TMP_DUMP
#!/bin/sh

 $R_CD $FILE_SYS
 $R_RM -f $TMP/$X.$FSNAME.$DOPTS.stat 2>/dev/null
 $RDUMP $D_OPTS $SERVER:$DEVICE $FILE_SYS 2>&1
 $R_ECHO \$? >$TMP/$X.$FSNAME.$DOPTS.stat
EOF_TMP_DUMP

  else

   echo $N "Using Command: $L_RSH $CLIENT \" $R_CD $FILE_SYS ; $R_TOUCH DO_NOT_REMOVE.level.$LEVEL.cpio.touchfile ; find . -newer DO_NOT_REMOVE.level.`expr $LEVEL - 1`.cpio.touchfile -xdev -print | $DUMP $D_OPTS | ($R_RSH $SERVER $L_DD of=$DEVICE bs=5120 \" )" |tee -a $FSLOG

   #First, we make a little cpio shell script that will run on the client

   cat >$TMP/$TMP_DUMP_SH <<EOF_R_CPIO.SH
#!/bin/sh

 $R_RM -f $TMP/$X.$FSNAME.$DOPTS.stat 2>/dev/null

 $R_CD $FILE_SYS
 $R_TOUCH DO_NOT_REMOVE.level.$LEVEL.cpio.touchfile
 $R_ECHO \$? >> $TMP/$X.$FSNAME.$DOPTS.stat

#To understand how this section works, see the comments in the 
#local backup section for the cpio section

 if [ $LEVEL -eq 0 ] ; then 
  NEWER=''
 else
  $R_TOUCH DO_NOT_REMOVE.level.$LEVEL.cpio.touchfile 
  FILENUM=\`$R_LS DO_NOT_REMOVE.level* \
   |$R_GREP -n "DO_NOT_REMOVE.level\.$LEVEL\." \
   |$R_AWK -F: '{print \$1}'\`

  [ -n "\$FILENUM" ] || FILENUM=1

  FILENUM=\`$R_EXPR \$FILENUM - 1\`

  if [ \$FILENUM -eq 0 ] ; then
   NEWER=''
   $R_TOUCH DO_NOT_REMOVE.level.0.cpio.touchfile
  else
   NEWER="-newer \`ls  DO_NOT_REMOVE.level.*|head -\$FILENUM|tail -1\`"
  fi
 fi

 $R_ECHO \$? >> $TMP/$X.$FSNAME.$DOPTS.stat

 [ -n "\`$TMP/config.guess|grep irix\`" ] && XDEV=mount || XDEV=xdev

 $R_FIND . \$NEWER -\$XDEV -print | $DUMP $D_OPTS \
  |($R_RSH $SERVER $L_DD of=$DEVICE bs=5120 )
 $R_ECHO \$? >> $TMP/$X.$FSNAME.$DOPTS.stat

EOF_R_CPIO.SH

   Log_err $? "Could not create $TMP/$TMP_DUMP_SH"

  fi

  #Then we rcp it over and run it
  chmod 755 $TMP/$TMP_DUMP_SH
  Log_err $? "Could not chmod $TMP/$TMP_DUMP_SH" exit

  rcp $TMP/$TMP_DUMP_SH $CLIENT:$TMP/$TMP_DUMP_SH
  Log_err $? "Could not rcp $TMP/$TMP_DUMP_SH to $CLIENT" exit

  $L_RSH $CLIENT $TMP/$TMP_DUMP_SH |tee -a $FSLOG
   
  RESULT=`$L_RSH $CLIENT $R_SORT -u $TMP/$X.$FSNAME.$DOPTS.stat|tail -1`
  #$L_RSH $CLIENT $R_RM -f $TMP/$TMP_DUMP_SH

  if  [ "$RESULT" = 0 ] ; then
    
   DATE=`date +"%a %D %T"`

   echo $N "$DUMP $LEVEL Done $DATE from $CLIENT: $C" |tee -a  $FSLOG
   echo "$FILE_SYS on ${SERVER}:${DEVICE} $COUNT" |tee -a  $FSLOG
 
  else

   DATE=`date +"%a %D %T"`

   echo $N "$DUMP $LEVEL NOT Done $DATE from $CLIENT $C" |tee -a  $FSLOG
   echo "$FILE_SYS on ${SERVER}:${DEVICE} $COUNT" |tee -a $FSLOG fi

  fi

  #This next section is for the xfsdump command, which makes multiple
  #tape files per dump!

  FILECOUNT=`grep ' media file [0-9]' $FSLOG |tail -1 \
   |sed 's/.* media file //' |sed 's/ .*//g'`
  [ -n "$FILECOUNT" ] || FILECOUNT=0
  FILECOUNT=`expr $FILECOUNT + 1`
  sed "s+$LINE+$LINE:$FILECOUNT+" $INCLIST >$TMP/$$.inclist.tmp
  mv $TMP/$$.inclist.tmp $INCLIST

  COUNT=`expr $COUNT + $FILECOUNT`

  $L_RSH $CLIENT $R_RM -f $TMP/$X.$FSNAME.$DOPTS.stat

  cat $FSLOG >>$CURRENT_HOST_LOG
  Log_err $? "Could not append $FSLOG to $CURRENT_HOST_LOG"

 fi

 LAST_FILE_SYS=`grep $CLIENT $INCLIST \
  | awk -F: '{print $2}' | tail -1 | grep -c "^${FILE_SYS}$"`

 if [ $LAST_FILE_SYS -eq 1 ] ; then

  if [ -n "$POSTBACKUP" ] ; then
   $RSH_IF_REMOTE $CLIENT_IF_REMOTE /usr/local/bin/postbackup.sh |tee -a $CURRENT_HOST_LOG
  fi

  #Append this file sys's backup log to the current log of this backup
  cat $CURRENT_HOST_LOG >> $LOG
  Log_err $? "Could not append $CURRENT_HOST_LOG to $LOG"

  #Append this backup's log to the running master backup log for this host
  cat $CURRENT_HOST_LOG >> $RUNNING_HOST_LOG
  Log_err $? "Could not append $CURRENT_HOST_LOG to $RUNNING_HOST_LOG"
  
  #Keep only 10000 lines in the running log
  tail -10000 $RUNNING_HOST_LOG >$TMP/$X.running.tmp.log
  Log_err $? "Could not create $TMP/$X.running.tmp.log"

  cp  $TMP/$X.running.tmp.log $RUNNING_HOST_LOG
  Log_err $? "Could not cp $TMP/$X.master.tmp.log to $LOG"

 fi

done
 

if [ $COUNT -gt 1 ] ; then
 echo "Backups complete... Beginning reading of tape...\n" |tee -a $LOG
 #sleep 60

 if [ "$TAPE" = Y ] ; then
  $L_MT $L_F $DEVICE $L_REWIND
  Log_err $? "Tape would not rewind with command: $L_MT $L_F $DEVICE $L_REWIND" exit
 fi

 echo "Rewind Complete" |tee -a  $LOG

 #sleep 20

 #This must start at '2' because the "label" that is put on the tape is
 #Actually the first partition on the tape.

 READCOUNT=2

 for LINE in `cat $INCLIST`
 do

  sleep 2

  if [ "$TAPE" = Y ] ; then
   $L_MT $L_F $DEVICE $L_REWIND
   Log_err $? "$L_MT $L_F: error ${L_REWIND}'ing tape." exit
  fi

  if [ "$TAPE" = Y ] ; then
   $L_MT $L_F $DEVICE fsf `expr $READCOUNT - 1`
   Log_err $? "$L_MT $L_F: error fsf'ing tape." exit
  fi

  sleep 2

  #Parse out values from the line
  CLIENT=`echo $LINE|awk -F: '{print $1}'`
  FILE_SYS=`echo $LINE|awk -F: '{print $2}'`
  FSTYPE=`echo $LINE|awk -F: '{print $3}'`
  REMOTE_OSnR=`echo $LINE|awk -F: '{print $4}'`
  export REMOTE_OSnR
  DUMP=`echo $LINE|awk -F: '{print $5}'`
  RDUMP=`echo $LINE|awk -F: '{print $6}'`
  D_OPTS=`echo $LINE|awk -F: '{print $7}'|sed 's/~/ /g'`
  DOPTS=`echo $LINE|awk -F: '{print $7}'` #Used to create a unique log file
  RESTORE=`echo $LINE|awk -F: '{print $8}'`
  RRESTORE=`echo $LINE|awk -F: '{print $9}'`
  R_OPTS=`echo $LINE|awk -F: '{print $10}'|sed 's/~/ /g'`
  LEVEL=`echo $LINE|awk -F: '{print $11}'`
  R_RSH=`echo $LINE|awk -F: '{print $12}'`
  B_FACTOR=`echo $LINE|awk -F: '{print $13}'`
  FILECOUNT=`echo $LINE|awk -F: '{print $14}'`
  FSNAME=`echo ${FILE_SYS}|sed 's-/-_-g'`

  [ "$FSNAME" = "_" ] && FSNAME='_root'

  if [ "$TAPE" != Y ] ; then
   DEVICE="$DEVICE_BASE/${CLIENT}$FSNAME.$DUMPBASE.level.$LEVEL"
   touch $DEVICE
  fi

  DUMPBASE=`basename $DUMP`

  echo |tee -a $LOG
  echo "=======================================================" |tee -a $LOG
  echo $N " Positioning to Pt# $READCOUNT w/cmd: $C" |tee -a $LOG
  echo "$L_MT $L_F $DEVICE fsf `expr $READCOUNT - 1`"  |tee -a $LOG

  echo " Reading File system $CLIENT:$FILE_SYS" |tee -a $LOG
  echo " This was a $FSTYPE file system on a $REMOTE_OSnR system."|tee -a $LOG
  echo " (It was backed up with $DUMPBASE.)" |tee -a $LOG

  if [ $REMOTE_OSnR = $LOCAL_OSnR -a $DUMPBASE != cpio ] ; then
   
   echo "  Using Command: $RESTORE $R_OPTS $DEVICE" |tee -a $LOG

   $RESTORE $R_OPTS $DEVICE \
    |sed "s/^/$DUMPBASE Pt# $READCOUNT: > /" |tee -a $LOG

  else

   if [ $DUMPBASE = cpio ] ; then
    #Read the file w/ cpio

    echo $N " Using Command: $L_DD if=$DEVICE bs=5120 $C" |tee -a $LOG
    echo "|($L_RSH $CLIENT $RESTORE -ictv )" |tee -a $LOG
    echo |tee -a $LOG

    $L_DD if=$DEVICE bs=5120|($L_RSH $CLIENT $RESTORE -ictv )\
     |sed "s/^/$DUMPBASE Pt# $READCOUNT: > /" |tee -a $LOG

   else

    echo " Using Command: $L_RSH $CLIENT $RRESTORE $R_OPTS $SERVER:$DEVICE "
    echo |tee -a $LOG

    $L_RSH $CLIENT $RRESTORE $R_OPTS $SERVER:$DEVICE \
     |sed "s/^/$DUMPBASE Pt# $READCOUNT: > /"|tee -a $LOG
   fi

  fi

  Log_err $? "Could not read filesystem $READCOUNT!"

  READCOUNT=`expr $READCOUNT + $FILECOUNT`

  if [ "$TAPE" = Y ] ; then
   $L_MT $L_F $DEVICE $L_REWIND
   Log_err $? "$L_MT $L_F: error ${L_REWIND}'ing tape." exit
  fi
 done

 #Append the output log to the tape for disaster purposes
 if [ "$TAPE" = Y ] ; then
  $L_MT $L_F $DEVICE $L_REWIND
  Log_err $? "$L_MT $L_F: error ${L_REWIND}'ing tape." exit
 
  $L_MT $L_F $DEVICE fsf `expr $READCOUNT - 1`
  Log_err $? "$L_MT $L_F: error fsf'ing tape." exit
 else
  DEVICE="$DEVICE_BASE/index.level.$LEVEL"
  touch $DEVICE
 fi

 tar cvf $DEVICE $LOG

 echo "Tape read successful..." |tee -a $LOG

 if [ -f /usr/local/bin/afterread.sh ] ; then
  echo "Running the commands found in /usr/local/bin/afterread.sh" | tee -a $LOG
  /usr/local/bin/afterread.sh
 fi

 if [ "$TAPE" = Y ] ; then
  $L_MT $L_F $DEVICE $L_OFFLINE
  Log_err $? "$L_MT $L_F: error ${L_OFFLINE}'ing tape." exit
 fi

 echo "Tape ejected" |tee -a $LOG

fi

Mail_logs

#EOF
