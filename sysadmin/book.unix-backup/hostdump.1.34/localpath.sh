#!/bin/sh

# Rcs_ID="$RCSfile: localpath.sh,v $"
# Rcs_ID="$Revision: 1.23 $ $Date: 2000/01/30 01:37:42 $"

L_DD=/usr/bin/dd ; L_TOUCH=/usr/bin/touch

XX=$$

mkfifo /tmp/$XX.mkfifo 2>/dev/null
if [ -p /tmp/$XX.mkfifo ] ; then
  L_MKNOD=mkfifo ; L_P=''
else
  mknod /tmp/$XX.mknod p 2>/dev/null
  if [ -p /tmp/$XX.mknod ] ; then
   L_MKNOD=mknod ; L_P='p'
  else
   echo "COULD NOT FIGURE OUT HOW TO MAKE A NAMED PIPE!"
   exit 1
  fi
fi

rm -f /tmp/$XX.mkfifo /tmp/$XX.mknod 2>/dev/null 

#Different rsh and mail commands
case $LOCAL_OSnR in
*aix* )    L_DF='df -k'
           L_RSH=/usr/bin/rsh   ; L_MAIL=/usr/bin/mailx  ; L_DD=/usr/bin/dd ;;
*bsdi* )   L_DF='df'
           L_RSH=/usr/bin/rsh   ; L_MAIL=/usr/bin/mail   ; L_DD=/bin/dd     ;;
*dgux* )   L_DF='df -k'
           L_RSH=/usr/bin/rsh   ; L_MAIL=/usr/bin/mailx  ; L_DD=/usr/bin/dd ;;
*freebsd*) L_DF='df'
           L_RSH=/usr/bin/rsh   ; L_MAIL=/usr/bin/mail   ; L_DD=/bin/dd     ;;
*hpux9* )  L_DF='bdf' ; L_TOUCH=/bin/touch
           L_RSH=/usr/bin/remsh ; L_MAIL=/usr/bin/mailx  ; L_DD=/bin/dd     ;;
*hpux10* ) L_DF='bdf'
           L_RSH=/usr/bin/remsh ; L_MAIL=/usr/bin/mailx  ; L_DD=/usr/bin/dd ;;
*irix* )   L_DF='df -k' ; L_TOUCH=/usr/bin/touch
           L_RSH=/usr/bsd/rsh   ; L_MAIL=/usr/sbin/mailx ; L_DD=/usr/bin/dd ;;
*next* )   L_DF='df -k'
           L_RSH=/usr/ucb/rsh   ; L_MAIL=/usr/ucb/Mail   ; L_DD=/bin/dd     ;;
*osf* )    L_DF='df -k'
           L_RSH=/usr/bin/rsh   ; L_MAIL=/usr/bin/mailx  ; L_DD=/usr/bin/dd ;;
*sco* )    L_DF='df -k'
           L_RSH=rsh            ; L_MAIL=/usr/bin/mail   ; L_DD=dd          ;;
*sunos* )  L_DF='df' ; L_TOUCH=/bin/touch
           L_RSH=/usr/ucb/rsh   ; L_MAIL=/usr/ucb/mail   ; L_DD=/bin/dd     ;;
*solaris*) L_DF='df -k'
           L_RSH=/usr/bin/rsh   ; L_MAIL=/usr/bin/mailx  ; L_DD=/usr/bin/dd ;;
*sni*sysv4* )
           L_DF='df -k'
           L_MAIL=/usr/bin/mailx  ; L_DD=/sbin/dd ; L_RSH=/usr/bin/rsh      ;;
*sysv4* )  L_DF='df -k'
           L_RSH=remsh          ; L_MAIL=/usr/bin/mailx  ; L_DD=dd          ;;
*ultrix* ) L_DF='df'
           L_RSH=/usr/ucb/rsh   ; L_MAIL=/usr/ucb/mail   ; L_DD=dd          ;;
* )  

#Different distributions may put these in different places, so...

cat >$TMP/$X.COMMANDS.TEST <<EOF_DUMP
#!/bin/sh

for CMD in df rsh mailx Mail dd touch
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
     else
      for CCMD in mailx Mail mail
      do
       if [ -f /usr/ucb/\$CCMD ] ; then
        echo "mail=/usr/ucb/\$CCMD"
       fi
      done  
     fi
    fi
   fi
  fi
done
EOF_DUMP

 chmod 755 $TMP/$X.COMMANDS.TEST

 $TMP/$X.COMMANDS.TEST >$TMP/$X.COMMANDS.OUT

 #Look for the commands, and make some variables called LIN_ for Linux dump/restore, etc.

 L_DD=`grep 'dd=' $TMP/$X.COMMANDS.OUT|cut -d'=' -f2`
 L_MAIL=`grep -i 'mail.*=' $TMP/$X.COMMANDS.OUT|cut -d'=' -f2`
 L_DF=`grep 'df=' $TMP/$X.COMMANDS.OUT|cut -d'=' -f2`
 L_RSH=`grep 'rsh=' $TMP/$X.COMMANDS.OUT|cut -d'=' -f2`
 L_TOUCH=`grep 'touch=' $TMP/$X.COMMANDS.OUT|cut -d'=' -f2`
;;
esac

#Check for Berkeley or SysV style echo

if echo "hello\c"|grep c >/dev/null ; then
 C='' ; N='-n'
else
  C='\c' ; N=''
fi

L_S='-s'

export L_RSH L_MAIL L_DD L_TOUCH L_DF C N L_S

L_MT='/bin/mt' ; L_REWIND=rewind ; L_OFFLINE=rewoffl ; L_F='-f'

case $LOCAL_OSnR in
*aix*)                                                                    ;;
*freebsd*)                L_MT=/usr/bin/mt                                ;;
*convex* )                                   L_F='-t'                     ;;
*sunos* )                 L_MT=/usr/bin/mt                                ;;
*bsdi* )                                                                  ;;
*dgux* )                  L_MT=/usr/bin/mt                                ;;
*hpux* )  L_REWIND=rew  ;                    L_F='-t' ; L_OFFLINE=offl    ;;
*next* )  L_REWIND=rewind                                                 ;;
*osf* )                   L_MT=/usr/bin/mt ; L_F='-f'                     ;;
*sco* )   UNKNOWN                                                         ;;
*solar* )                                               L_OFFLINE=offline ;;
*sni*sysv4* )             L_MT='/sbin/mt'  ; L_F='-f'                     ;;
*sysv4* )                 L_MT='/bin/tctl' ; L_F='-t' ; L_OFFLINE=offline ;;
*irix* )                  L_MT=/usr/bin/mt ; L_F='-t' ; L_OFFLINE=offline ;;
*ultrix* )                                   L_F='-t'                     ;;
* )                       L_MT=mt                                                         ;;
esac

export L_MT L_F L_REWIND L_OFFLINE
