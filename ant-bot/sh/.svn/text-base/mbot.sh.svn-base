#!/bin/bash
# $Id: mbot.sh 6 2006-09-10 15:35:16Z marcus $
#
# mbot: Marcus' bot
#       uses list_mun parameters with ant and SQL*Plus
#
# Created:
#       Marcus Vinicius Ferreira    Set/2003
#

TASK_NOT_FOUND=1
UNREACHEABLE=2
INVALID_MODE=3
INVALID_LIST=4
INVALID_TASK=5
INVALID_LOGDIR=6
WRONG_USAGE=99

usage()
{

cat <<USAGE >&1

    Usage: $0 -mode <MODE> -list <LISTNAME> [ -task <TASKFILE> ]
               [ -grep <"string"> ] [ -ping <TIMEOUT> ] [ -log <DIRNAME> ]
               [ -force | -noping ]

           $0 --help

USAGE

exit $WRONG_USAGE
}

help()
{
cat <<HELP >&1

    Usage: $0 -mode <MODE> -list <LISTNAME> [ -task <TASKFILE> ]
               [ -grep <"string"> ] [ -ping <TIMEOUT> ] [ -log <DIRNAME> ]
               [ -force | -noping ] [ -parallel ]

           $0 --help

        -mode:  runtime mode (ant or sql)
                ant: calls ant, in this case -task must be a valid XML ant script.
                sql: calls sqlplus command line, -task must be a SQL script built
                with "exit" as the last command to be executed

        -task:  script file to execute
                ant: default task is "build.xml"
                sql: default task is "run.sql"

        -list:  path to a list to be processed. The list must be a txt file with
                parameters to be passed to the task. The current parameters are:

                            used with ant       used with sqlplus
                LABEL_1         X                   X
                LABEL_2         X                   X
                   HOST         X                   X
                     IP         X                   X
                    TNS         X                   X
                SERVICE         X                   X
                 SCHEMA         X                   X
                 CD_MUN         X                   X
                  CD_UF         X                   X
                    CNC                             X
                    EST                             X
                   ROOT         X
                 ORACLE         X

        -grep:  applies <string> to the list. Only the matching lines will be
                processed.

        -ping:  timeout for ping. Default: 20s.

        -log:   Uses DIRNAME as destination for the log files. Defaults to "./log"
                which is created in the current location.
                For each line processed is created a file named as
                "label2".log_"date". There is also a "$MODE"_full.log with
                all the output of all lines processed.

                In the current location will be made a third "log" file. It is a
                composition of the parameters used to execute $0.

                    <mode>_<list>_filter-<filter>_<date>.log

                It recreates all the input list with a status execution. To
                re-process just the lines with an error, try:

                    $ grep st_err <file> > new_list.txt

                and then you can use "-list new_list.txt" to run just the error lines.

        -force: Bypass connection check, i.e., does not use ping and assume the
       -noping  network is already online.

     -parallel: Call each task in background. Experimental.

    EXAMPLE:

        1) Executing an ant task:

            $ $0 -mode ant -list mun.txt

        2) Executing a customized ant task with a filtered list

            $ $0 -mode ant -task install_tip.xml -list mun.txt -grep "SP1"

        3) Executing an Oracle SQL task

            $ $0 -mode sql -task run.sql -list ../mun.txt -log mylog

        4) Reprocessing a task:

            $ $0 -mode sql -task run.sql -list new_list.txt -ping 180


    ERROR CODES:

        TASK_NOT_FOUND  1
        UNREACHEABLE    2
        INVALID_MODE    3
        INVALID_LIST    4
        INVALID_TASK    5
        INVALID_LOGDIR  6
        WRONG_USAGE    99

    AUTHOR:

        Written by Marcus Vinicius Ferreira in Apr/2004.

    BUG:

        Report your bugs to <marcus@mvway.com>

HELP
exit 0
}

dt()
{
  /bin/date "+%Y-%m-%d_%H%M"
}

cmd_params()
{

[ "$1" = "-help" ]  && help
[ "$1" = "--help" ] && help

for PARAM in $@
do

    case $PARAM in
           -mode | --mode)  shift
                            MODE=$1
                            shift
                            ;;
           -list | --list)  shift
                            LIST=$1
                            shift
                            ;;
           -task | --task)  shift
                            TASK=$1
                            shift
                            ;;
           -grep | --grep)  shift
                            GR_STRING=$1
                            shift
                            ;;
           -ping | --ping)  shift
                            TIMEOUT=$1
                            shift
                            ;;
             -log | --log)  shift
                            LOGDIR=$1
                            shift
                            ;;
          -force| --force)  shift
                            FORCE="YES"
                            ;;
        -noping| --noping)  shift
                            FORCE="YES"
                            ;;
  -parallel|--parallel|-p)  shift
                            PARALLEL="YES"
                            ;;
    esac
done

##
if [ "$MODE" != "ant" ] \
&& [ "$MODE" != "sql" ]
then
    exit $INVALID_MODE
fi

##
[ "$LIST" = "" ] && exit $INVALID_LIST
[ ! -f "$LIST" ] && exit $INVALID_LIST

##
if [ "$TASK" = "" ]
then
    [ "$MODE" = "ant" ] && TASK="build.xml"
    [ "$MODE" = "sql" ] && TASK="run.sql"
fi
[ ! -f $TASK   ] && exit $INVALID_TASK

##
[ "$TIMEOUT" = "" ] && TIMEOUT=20

##
   [ "$LOGDIR" = "" ] && LOGDIR="./log"
if [ ! -d $LOGDIR     ]
then
    mkdir $LOGDIR || exit $INVALID_LOGDIR
fi

}

prepare_list()
{

IFS="
;"

if [ "$GR_STRING" = "" ]
then
    LBL="( All )"
    GR_STRING="all"
    FILTER="` awk '{print $LINE, ";" }' $LIST | grep -v '^#' `"
else
    LBL="( $GR_STRING )"
    FILTER="` awk '{print $LINE, ";" }' $LIST | grep -v "^#" | grep $GR_STRING `"
fi

}

myping()
{
    #   win32: ping -n $TIMEOUT $IP >> ping.txt
    # Solaris: ping -s $IP 1 $TIMEOUT  # 1: data_size
    #    perl: ping.pl $IP $TIMEOUT >> ping.txt  (Cygwin)
    #          myping  $IP $TIMEOUT >> ping.txt  (C wrapper for Unix)

    [ "$FORCE" = "YES" ] && return 0

    MYDIR="${0%/*}"
    MYPING="$MYDIR/ping.pl"             # ping.pl in Cygwin

    MYPING="/usr/local/bin/myping"      # ping.pl in Slackware

    $MYPING $1 $TIMEOUT
}

exec_task()
{

    echo ""
    echo "____________________________________________________________________________________"
    echo ""
    echo "       File : ${0##*/}"
    echo "   Bot mode : $MODE"
    echo "       List : $LIST $LBL"
    echo "       Task : `pwd`/$TASK"
    echo "        Log : $LOGDIR"
    echo "____________________________________________________________________________________"
    echo ""
    echo ""

    FORMAT="%24s %8s %12s %14s %20s %22s %17s %8s %7s %16s %16s %s \n"
    FMT0="  %15s : %22s : %7s %15s %10s %s\n"
    FMT1="  %15s : %22s : %s\n"

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

        printf $FMT0 `dt` $LABEL_1  $HOST  $IP $CD_MUN  $CD_UF

        myping $IP > ping.txt
        PING="$?"

        if [ "$PING" = "0" ]
        then

            #printf "  %15s : %20s : Connected\n"  `dt` $LABEL_1

            task $REC
            STATUS="$?"

        else
            STATUS="no connection"
        fi

        if [ "$STATUS" = "0" ]
        then
           #printf $FORMAT $LABEL_1 $LABEL_2 $HOST $IP $TNS $SERVICE $SCHEMA $CD_MUN $CD_UF $CNC $EST " ok"  >> $LOG
            printf $FORMAT $LINE " st_ok"    >> $LOG
        else
            printf $FORMAT $LINE " st_error" >> $LOG
            printf $FMT1 `dt` $LABEL_1 "Error..."
            touch "$LOGDIR/${LABEL_2}.log_${DT}"_erro
        fi

done

echo ""
echo "____________________________________________________________________________________"
echo ""
echo "# Started: ${DT}"   | tee -a $LOG | tee -a log/${MODE}_full.log
echo "#   Ended: `dt` "   | tee -a $LOG | tee -a log/${MODE}_full.log

}

task()
{
    LOG_PARCIAL="${LOGDIR}/${LABEL_2}.log_${DT}"
    touch ${LOG_PARCIAL}

    case $MODE in

        ant)
            if [ "$PARALLEL" = "YES" ]
            then
                task_ant &
            else
                task_ant
            fi
            ;;

        sql | sqlplus )
            if [ "$PARALLEL" = "YES" ]
            then
                task_sql &
            else
                task_sql
            fi
            ;;
    esac
}

task_ant()
{
    # parameters are case-sensitive
    ant -Dhost=$HOST            -DHOST=$HOST            \
        -Dip=$IP                -DIP=$IP                \
        -Dtns=$TNS              -DTNS=$TNS              \
        -Dlabel_1=$LABEL_1      -DLABEL_1=$LABEL_1      \
        -Dlabel_2=$LABEL_2      -DLABEL_2=$LABEL_2      \
        -Dservice=$SERVICE      -DSERVICE=$SERVICE      \
        -Dschema=$SCHEMA        -DSCHEMA=$SCHEMA        \
        -Dcd_mun=$CD_MUN        -DCD_MUN=$CD_MUN        \
        -Dcd_uf=$CD_UF          -DCD_UF=$CD_UF          \
        -Droot=$ROOT            -DROOT=$ROOT            \
        -Doracle=$ORACLE        -DORACLE=$ORACLE        \
        -f $TASK                                        \
    | tee -a $LOGFULL > ${LOG_PARCIAL}

}

task_sql()
{
    # parameters are case-INsensitive, positional
    sqlplus -s /nolog @${TASK}                        \
            $TNS                                      \
            $SCHEMA                                   \
            $CD_MUN                                   \
            $CD_UF                                    \
            $CNC                                      \
            $EST                                      \
            $SERVICE                                  \
    | tee -a $LOGFULL > ${LOG_PARCIAL}
}

###
### main
###

[ "$1" = "" ] && usage

cmd_params   $@
prepare_list $LIST $GR_STRING

DT=`dt`
LIST1="${LIST##*/}"
#LIST1="${LIST1%.*}"

LOG="${MODE}-${LIST1}-filter_${GR_STRING}_`dt`.log"
LOGFULL="${LOGDIR}/${MODE}-${LIST1}_full.log"

exec_task    $TASK $TIMEOUT

