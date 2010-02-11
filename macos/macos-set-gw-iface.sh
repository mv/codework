#!/bin/sh
# $Id$
# BSD/MacOS

[ "$1" ] || {
    echo 
    echo "Usage: $0  [interface]"
    echo
    exit 2
}

ip=`ifconfig $1 | grep -w inet | awk '{print $2}'`
if [ "$?" != 0 ]
then
    echo
    echo "Interface $1 not found."
    exit 1
fi
if [ "$ip" == "" ]
then
    echo
    echo "Interface $1 has no IP."
    exit 3
fi

gw=`echo $ip | awk -F. '{print $1 "." $2 "." $3 ".1"}'`
if sudo route delete -net 0.0.0.0
then
    echo "    route deleted."
else
    echo "--- route del error: $?"
fi

echo
if sudo route add    -net 0.0.0.0 $gw
then
    echo "    default route: $gw"
else
    echo "--- route add erro: $?"
fi

