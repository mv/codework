#!/bin/sh

# Rcs_ID="$RCSfile: rempath.sh,v $"
# Rcs_ID="$Revision: 1.14 $ $Date: 1999/02/04 18:49:39 $"

XREM=$$

R_AWK=/usr/bin/awk
R_CAT=/usr/bin/cat
R_CD=/usr/bin/cd
R_CUT=/usr/bin/cut
R_DD=/usr/bin/dd
R_ECHO=/usr/bin/echo
R_EGREP=/usr/bin/egrep
R_EXPR=/usr/bin/expr
R_GREP=/usr/bin/grep
R_FIND=/usr/bin/find
R_LS=/usr/bin/ls
R_RM=/usr/bin/rm
R_RSH=/usr/bin/rsh
R_SORT=/usr/bin/sort
R_TOUCH=/usr/bin/touch

case $REMOTE_OSnR in
*aix* )     ;;            #Everything is in /usr/bin/
*bsdi* )    R_CAT=/bin/cat ; R_EXPR=/bin/expr ; R_RM=/bin/rm ; R_DD=/bin/dd 
           R_CD=cd ; R_ECHO=/bin/echo ; R_LS=/bin/ls ;;
*dgux* )    ;;            #Everything is /usr/bin/
*freebsd* ) R_CAT=/bin/cat ; R_EXPR=/bin/expr ; R_RM=/bin/rm ; R_DD=/bin/dd
           R_RSH=rsh ; R_CD=cd R_RM=/bin/rm ; R_LS=/bin/ls ; R_ECHO=/bin/echo ;;
*hpux9* )   R_CAT=/bin/cat ; R_CD=/bin/cd ; R_DD=/bin/dd ; R_ECHO=/bin/echo
           R_EGREP=/bin/egrep ; R_EXPR=/bin/expr ; R_GREP=/bin/grep 
           R_FIND=/bin/find ; R_LS=/bin/ls ; R_RM=/bin/rm
           R_RSH=/usr/bin/remsh ; R_SORT=/bin/sort
           R_TOUCH=/bin/touch ;;
*hpux10* )  R_RSH=/usr/bin/remsh ;;
*irix6.4 )  R_LS=ls R_CD=/sbin/cd ; R_RSH=/usr/bsd/rsh ;;
*irix6.2 )  R_LS=ls ; R_CD=cd ; R_RSH=/usr/bsd/rsh ;;
*next* )    R_CAT=/bin/cat ; R_CD=cd ; R_CUT=cut ; R_DD=/bin/dd
           R_ECHO=/bin/echo ; R_EXPR=/bin/expr ; R_GREP = /bin/grep
           R_LS=ls ; R_RM=/bin/rm ; R_RSH=/usr/ucb/rsh  ;;
*osf* )    ;;                #Everything is in /usr/bin/
*sco* )     R_CAT=/bin/cat ; R_GREP=/bin/grep ; R_EXPR=/bin/expr
           R_TOUCH=/bin/touch ; R_EGREP=/usr/bin/egrep ; R_RM=/bin/rm
           R_SORT=/bin/sort ; R_DD=/bin/dd ; R_RSH=/usr/bin/remsh ; R_CD=cd
           R_FIND=/bin/find ; R_LS=/bin/ls ; R_ECHO=echo
           R_CUT=/usr/bin/cut ; ;;
*sunos* )   R_CAT=/bin/cat ; R_GREP=/bin/grep ; R_EXPR=/bin/expr
           R_TOUCH=/bin/touch ; R_EGREP=/bin/egrep ; R_RM=/bin/rm
           R_SORT=/bin/sort ; R_DD=/bin/dd ; R_RSH=/usr/ucb/rsh
           R_CUT=/bin/cut ; R_FIND=/bin/find ; R_ECHO=/bin/echo
           R_LS=/bin/ls ; R_CD=cd ;AWK=/bin/awk ;;
*solaris* ) ;;                #Everything is in /usr/bin/
*sni*sysv4* ) R_AWK=/sbin/awk ; R_CAT=/sbin/cat ; R_DD= /sbin/dd
              R_EXPR=/sbin/expr ; R_FIND=/sbin/find ; R_GREP=/sbin/grep
              R_RM=/sbin/rm ; R_SORT=/sbin/sort ;;
*sysv4* )   ;;
*ultrix* )  R_RSH=/usr/ucb/rsh ;; #Need others

* ) 

#This is as secure a way as I could find to "guess" at full path names

#We'll create a script that will first find ls, then use that ls
#to find the other commands
#The only way it could be hacked is if /bin/sh is hacked.  And, if that's
#been hacked, well....

echo "
for i in /bin /usr/bin /sbin /usr/sbin /etc
do
 \$i/ls $TMP/$XREM.commands.sh >/dev/null 2>&1
 if [ \$? -eq 0 ] ; then
   R_LS=\$i/ls
   break
 fi
done

cp /dev/null $TMP/$XREM.commands
for command in awk cat cd cut dd echo egrep expr grep find ls rm rsh sort touch
do
 COMM=\`echo \$command|tr '[a-z]' '[A-Z]'\`
 COMMAND=\"R_\$COMM\"
 for directory in /usr/bin /bin /sbin /usr/sbin /etc
 do
  \$R_LS \$directory/\$command >/dev/null 2>&1
  if [ \$? -eq 0 ] ; then
   echo \"\$COMMAND=\$directory/\$command
   export \$COMMAND\" >>$TMP/$XREM.commands
   break
  fi
 done
 THERE=\`grep \"^\${COMMAND}=\" $TMP/$XREM.commands\`
 if [ -z \"\$THERE\" ] ; then
  echo \"\$COMMAND=\$command
  export \$COMMAND\" >>$TMP/$XREM.commands
 fi
done ">$TMP/$XREM.commands.sh

chmod 755 $TMP/$XREM.commands.sh

if [ -n "$CLIENT_IF_REMOTE" ] ; then
 rcp $TMP/$XREM.commands.sh $CLIENT_IF_REMOTE:$TMP/$XREM.commands.sh
fi

$RSH_IF_REMOTE $CLIENT_IF_REMOTE /bin/sh $TMP/$XREM.commands.sh

if [ -n "$CLIENT_IF_REMOTE" ] ; then
 rcp $CLIENT_IF_REMOTE:$TMP/$XREM.commands $TMP/$XREM.commands
fi

chmod 755 $TMP/$XREM.commands
. $TMP/$XREM.commands
rm $TMP/$XREM.commands

;;
esac

export R_AWK R_CAT R_CD R_CUT R_DD R_ECHO R_EGREP R_EXPR R_GREP R_FIND
export R_LS R_RM R_RSH R_SORT R_TOUCH

echo "
for dir in /usr/bin /bin /usr/sbin /sbin /etc
do
  $R_LS \$dir/mkfifo >/dev/null 2>&1
  if [ \$? -eq 0 ] ; then
   MKFIFO=\$dir/mkfifo 
   break
  fi
done

for dir in /usr/bin /bin /usr/sbin /sbin /etc
do
  $R_LS \$dir/mknod  >/dev/null 2>&1
  if [ \$? -eq 0 ] ; then
   MKNOD=\$dir/mknod
   break
  fi
done

if [ -n "\${MKFIFO}\${MKNOD}" ] ; then

 \$MKFIFO /tmp/$XREM.mkfifo 2>/dev/null
 if [ -p /tmp/$XREM.mkfifo ] ; then
   R_MKNOD=mkfifo ; R_P=''
 else
  \$MKNOD /tmp/$XREM.mknod p 2>/dev/null
  if [ -p /tmp/$XREM.mknod ] ; then
   R_MKNOD=mknod ; R_P='p'
  else
   echo "COULD NOT FIGURE OUT HOW TO MAKE A NAMED PIPE!"
   exit 1
  fi
 fi
else
 echo "COULD NOT FIGURE OUT HOW TO MAKE A NAMED PIPE!"
 exit 1
fi

echo "R_MKNOD=\$R_MKNOD"
echo "R_P=\$R_P"
echo "export R_MKNOD R_P"

rm /tmp/$XREM.mkfifo /tmp/$XREM.mknod 2>/dev/null
" >$TMP/$XREM.mkfifo.sh

chmod 755 $TMP/$XREM.mkfifo.sh
if [ -n "$CLIENT_IF_REMOTE" ] ; then
 rcp $TMP/$XREM.mkfifo.sh $CLIENT_IF_REMOTE:$TMP/$XREM.mkfifo.sh
fi

$RSH_IF_REMOTE $CLIENT_IF_REMOTE $TMP/$XREM.mkfifo.sh >$TMP/$XREM.mkfifo.out

chmod 755 $TMP/$XREM.mkfifo.out
. $TMP/$XREM.mkfifo.out
rm $TMP/$XREM.mkfifo.out

R_MT='/bin/mt' ; R_REWIND=rewind ; R_OFFLINE=rewoffl ; R_F='-f'

case $REMOTE_OSnR in
*aix*)                                                                    ;;
*bsdi* )                                                                  ;;
*convex* )                                   R_F='-t'                     ;;
*dgux* )                  R_MT=/usr/bin/mt                                ;;
*freebsd*)                R_MT=/usr/bin/mt                                ;;
*hpux* )  R_REWIND=rew  ;                    R_F='-t' ; R_OFFLINE=offl    ;;
*irix* )                  R_MT=/usr/bin/mt ; R_F='-t' ; R_OFFLINE=offline ;;
*next* )  R_REWIND=rewind                                                 ;;
*osf* )                   R_MT=/usr/bin/mt                                ;;
*sco* )   UNKNOWN                                                         ;;
*sni*sysv4* )             R_MT='/sbin/mt'                                 ;;
*solari* )                                              R_OFFLINE=offline ;;
*sunos* )                 R_MT=/usr/bin/mt                                ;;
*sysv4* )                 R_MT='/bin/tctl' ; R_F='-t' ; R_OFFLINE=offline ;;
*ultrix* )                                   R_F='-t'                     ;;
* )                       R_MT=mt                                         ;;
esac                                                                          

export R_MT R_F R_REWIND R_OFFLINE
