#!/bin/bash
# $Id: pghome.sh 30 2004-10-15 12:46:49Z marcus $
# pghome.sh
#
# Set POSTGRES database cluster to use
#
# Created:
#    Marcus Vinicius Ferreira <marcus@mvway.com>    Out/2004
#

PGTAB="/var/opt/pgsql/pgtab"

unset LIST DBNAME

usage() {

    cat >&1 <<EOF

    Usage: . pghome               -- set first available database in "pgtab"
           . pghome [dbname]      -- set [dbname] as current database to operate
           . pghome -s |--select  -- list available databases
           . pghome -c |--current -- show current settings
           . pghome -h |--help    -- this display

      Obs: " . pghome " is needed to make all exported variables visible.

EOF
}

the_end() {

    unset LIST DBNAME PGTAB
    unset usage currdb set_first setdb selectdb
    unset the_end
}

currdb() {

    cat >&1 <<EOF

Postgres: Current Environment is:
---------------------------------

    PGDATABASE = $PGDATABASE
        PGDATA = $PGDATA
        PGHOME = $PGHOME

EOF
}

set_first() {

    DBNAME=`awk -F: '/^[a-zA-Z]/ {print $1}' $PGTAB | head -1`
    setdb $DBNAME
}

setdb() {

    LIST=`grep ^${1} $PGTAB | grep -v "^#"`
    if [  "$LIST" == "" ]
    then
        echo
        echo "Error!"
        echo "       dbname: $1 not in pgtab"
        echo
        usage
        __RET=2
    else
        PGDATABASE=`echo $LIST | awk -F: '{print $1}'`
            PGDATA=`echo $LIST | awk -F: '{print $2}'`
            PGHOME=`echo $LIST | awk -F: '{print $3}'`

        export PGDATABASE PGDATA PGHOME
        export PS1="\u@\h [ $PGDATABASE ] :\w\n\$ "

        [ `echo $PATH | /bin/egrep "(^|:)${PGHOME}/bin($|:)"` ] || \
                PATH=${PGHOME}/bin:${PATH}
        [ `echo $MANPATH | /bin/egrep "(^|:)${PGHOME}/man($|:)"` ] || \
                MANPATH=${PGHOME}/man:${MANPATH}
        [ `echo $LD_LIBRARY_PATH | /bin/egrep "(^|:)${PGHOME}/lib($|:)"` ] || \
                LD_LIBRARY_PATH=${PGHOME}/bin:${LD_LIBRARY_PATH}
        export PATH MANPATH LD_LIBRARY_PATH

        currdb
        __RET=0
    fi
}

selectdb() {

    for DBNAME in `grep -v "^#" $PGTAB | awk -F: '{print $1 }'`
    do
        LIST="$LIST $DBNAME"
    done

    echo
    echo "Postgres dabases:"
    echo "-----------------"
    echo
    PS3="
    # Option? "
    select DBNAME in $LIST "[Exit]"
    do
        case "$DBNAME" in
     "[Exit]")  #
                currdb
                break
                ;;
            *)  #
                if [ "$DBNAME" == "" ]
                then
                    echo
                    echo "    Must use a NUMBER option"
                else
                    setdb $DBNAME
                    break
                fi
                ;;
        esac
    done

}

###
### main
###

if [ ! -f $PGTAB ]
then
    echo
    echo "Error: pgtab NOT FOUND!"
    echo "       Nothing to do......"
    echo
    unset LIST DBNAME PGTAB
    the_end
    return 2
else

    case "$1" in
        "" )    #
                set_first
                the_end
                return 0
                ;;
        "--select" | "-s")
                selectdb
                the_end
                return 0
                ;;
        "--current" | "-c")
                currdb
                ;;
        "--help" | "-h")
                usage
                the_end
                return 0
                ;;
          *)    setdb $1
                the_end
                return $__RET
                ;;
    esac

fi

