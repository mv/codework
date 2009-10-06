#!/bin/bash
#
# jboss password
# Ref: http://www.jboss.org/community/wiki/EncryptingDataSourcePasswords
#
# Marcus Vinicius Ferreira 				ferreira.mv[ at ]gmai.com
# 2009/Out
#

[ -z "$1" ] && {
    printf "\n    Usage: $0 password\n\n"
    exit 1
}

JAVA_HOME=/app/jdk1.6.0_10/bin
JBOSS=/app/jboss-4.2.3.GA_1

cd $JBOSS

$JAVA_HOME/java -cp \
         lib/jboss-common.jar:lib/jboss-jmx.jar:server/default/lib/jbosssx.jar:server/default/lib/jboss-jca.jar \
         org.jboss.resource.security.SecureIdentityLoginModule "$1"


# Obs: v3 - funciona??
#
# java -cp lib/jboss-jmx.jar:lib/jboss-common.jar:server/default/deploy/jboss-jca.sar:server/default/lib/jbosssx.jar \
#          org.jboss.resource.security.SecureIdentityLoginModule "$1"

