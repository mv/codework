#!/bin/sh
# $Id$
# BSD/MacOS: default route for Claro-3g

PPP=`ifconfig ppp0 | grep inet | awk '{print $4}'`

if sudo route delete -net 0.0.0.0
then
    echo "    route deleted."
else
    echo "--- route del error: $?"
fi

echo
if sudo route add    -net 0.0.0.0 $PPP
then
    echo "    default route: $PPP"
else
    echo "--- route add erro: $?"
fi

