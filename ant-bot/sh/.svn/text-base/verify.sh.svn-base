#!/bin/bash
#
# $Id: verify.sh 6 2006-09-10 15:35:16Z marcus $
#

usage() {

cat <<USAGE >&1

    Usage: $0 <list_name> <site_name>

        Verifies parameters on <list_name> for <site_name>

        <site_name> can be:     ip
                                hostname
                                instance
                                schema name
        <list_name> : tab formatted instances (example = ../mun.txt)

USAGE

exit 99

}

dt(){

  /bin/date "+%Y-%m-%d_%H%M"

}

# $1: source list name
# LIST=/work/bot/mun.txt
# [ "$1" = "" ] || LIST="$1"
  [ "$1" = "" ] && usage

LIST="$1"

IFS="
;"

if [ "$2" = "" ]
then
    usage
else
    STRING=$2
    LBL="( $STRING )"
    FILTER="` awk '{print $LINE, ";" }' $LIST | grep -v "^#" | grep $STRING `"
fi

echo ""
echo "____________________________________________________________________________________"
echo ""
echo "     Ver : ${0##*/} "
echo "    List : $LIST $LBL"
echo "    Task : `pwd`/run.sql"
echo "____________________________________________________________________________________"
echo ""
echo ""


for LINE in $FILTER
do
    [ "$LINE" = " " ] && continue

 LABEL_1=`echo $LINE | awk '{print $1}'`
 LABEL_2=`echo $LINE | awk '{print $2}'`
    HOST=`echo $LINE | awk '{print $3}'`
      IP=`echo $LINE | awk '{print $4}'`
     TNS=`echo $LINE | awk '{print $5}'`
 SERVICE=`echo $LINE | awk '{print $6}'`
  SCHEMA=`echo $LINE | awk '{print $7}'`
  CD_MUN=`echo $LINE | awk '{print $8}'`
   CD_UF=`echo $LINE | awk '{print $9}'`
     CNC=`echo $LINE | awk '{print $10}'`
     EST=`echo $LINE | awk '{print $11}'`
    ROOT=`echo $LINE | awk '{print $12}'`
  ORACLE=`echo $LINE | awk '{print $13}'`

    echo "    LABEL_1 = $LABEL_1 "
    echo "    LABEL_2 = $LABEL_2 "
    echo "       HOST = $HOST "
    echo "         IP = $IP "
    echo "        TNS = $TNS "
    echo "    SERVICE = $SERVICE "
    echo "     SCHEMA = $SCHEMA "
    echo "     CD_MUN = $CD_MUN "
    echo "      CD_UF = $CD_UF "
    echo "        CNC = $CNC "
    echo "        EST = $EST "
    echo "       ROOT = $ROOT "
    echo "     ORACLE = $ORACLE "

    echo ""

done

echo ""
echo "____________________________________________________________________________________"
echo ""
