#!/bin/bash
# $Id: ftp.sh 6 2006-09-10 15:35:16Z marcus $
#

SOURCE=/work/bot/mun.txt
DIRFTP="/tmp"
USERFTP=appeis
PASSFTP="appeis"
USERFTP=oracle
PASSFTP="Delphi!1"

myftp()
{
    # $1: IP
    # $2: file name

# Arquivo nulo: nao transfere
[ "$2" = ""         ] && return

# Spool local: nao transfere
[ "$2" = "ping.txt" ] && return

echo "    Transfer: $2"

ftp -ni $1 <<FTP

user $USERFTP $PASSFTP
cd $DIRFTP
bin
put $2

FTP

}

usage() {

cat <<USAGE

    Usage: $0 <source_list> [<remote_dir> <file>]

        transfer all files in the current dir to all
        hosts in a specified list

        source_list:    list of remote hosts in the format
                        hostname:ip:tns

        remote_dir:     dir at remote host to transfer
                        file into. Default: /tmp

        file:           file to transfer. If null, all
                        files in current directory will
                        be used.
USAGE

exit 0

}

# IFS: any value not in $SOURCE
export IFS="
"

# $1: source list name
[ "$1" = "" ] && usage

SOURCE="$1"
cat <<LIST

    Source list: $SOURCE

LIST

# $2: destiny
[ "$2" = "" ] || DIRFTP="$2"


# Spool file
echo /dev/null > ping.txt

for LINE in `grep -v "#" $SOURCE`
do

    HOST=`echo $LINE | awk -F":" '{print $1}'`
      IP=`echo $LINE | awk -F":" '{print $2}'`
     TNS=`echo $LINE | awk -F":" '{print $3}'`

    echo ""
    echo "---------------------------------------------------------"
    echo "---  Processando |$HOST|  |$IP|  |$TNS| "
    echo "---------------------------------------------------------"
    echo ""

    # Windows ping:
    #   -n 50:  send 50 requests
    #   -w 1000: timeout 10 seconds (in miliseconds)
    ping -n 50 $IP >> ping.txt
    RESULT="$?"

    #echo " (ping result = $RESULT ) "
    #tnsping $TNS 10

    # $3: file to be transfered
    if [ ! "$3" = "" ]
    then
        myftp $IP $3
    else
        for FILE in *.*
        do
            myftp $IP $FILE
        done
    fi

    echo "___________________________________________________________________"
    echo ""

done
