#!/bin/bash -x
#
# MacBook as a Server
#
# Marcus Vinicius Ferreira              ferreira.mv[ at ] gmail.com
#

PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin

if [ ! `which synergys` ]
then
    echo
    echo "Server synergys NOT FOUND"
    echo
    exit 1
fi

ip0=$( ifconfig en0 | awk '/inet / {print $2}' )
ip1=$( ifconfig en1 | awk '/inet / {print $2}' )

case $ip0 in
    '10.73.92.102')
        /usr/local/bin/synergys -c ~/bin/synergy-server.conf -f --restart
        ;;
    *)
        echo "ip0: $ip0"
        ;;
esac

case $ip1 in
    *)
        echo "ip1: $ip1"
        ;;
esac

