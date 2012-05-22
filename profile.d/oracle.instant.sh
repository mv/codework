#
# profile.d/oracle.instant.sh
#
# instant client installation
#
# Marcus Vinicius Ferreira               ferreira.mv[ at ]gmail.com
# 2010/06
#


export  ORACLE_HOME=/abd/tools/oracle
export    TNS_ADMIN=$ORACLE_HOME

export        NLS_LANG='AMERICAN_AMERICA.WE8ISO8859P1'
export NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'

echo $PATH            | egrep -q "(^|:)$ORACLE_HOME($|:)" || export            PATH=$PATH:$ORACLE_HOME/bin
echo $LD_LIBRARY_PATH | egrep -q "(^|:)$ORACLE_HOME($|:)" || export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib 

