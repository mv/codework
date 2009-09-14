#!/bin/bash
#
# $Id: sing_route.sh 6 2006-09-10 15:35:16Z marcus $
#
# Marcus Vinicius Ferreira  Jun/2003
#
# Conexao `a rede Singularity
#   via VPN, IPs Singularity sao 172.*

IP=`ipconfig | grep IP | grep 172 | awk -F": " '{print $2}'`

if [ "$IP" == "" ]
then
   echo ""
   echo "VPN: nao conectado."
   echo ""
   exit 1
fi

# Rota CNS
route add 10.0.0.0  mask 255.0.0.0 $IP

# Rota Singularity
route add 192.168.1.0 mask 255.255.255.0 $IP

echo ""
echo "VPN: $IP ok."
echo ""
exit 0
