#!/bin/bash
#
# MacBook as a Client
#
# Marcus Vinicius Ferreira              ferreira.mv[ at ] gmail.com
#

if [ `which synergyc` ]
then
    synergyc -c ~/bin/synergy-client.conf -f --restart
else
    echo
    echo "Server synergyc NOT FOUND"
    echo
    exit 1
fi

