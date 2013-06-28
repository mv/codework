#!/bin/bash

#
# Ref:
#     https://www.digitalocean.com/community/articles/how-to-setup-a-basic-iptables-configuration-on-centos-6
#

#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2013-06
#


###
### Begin
###

# block null packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# block SYN flood attack
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# block XMAS packets
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Open loopback
iptables -A INPUT -i lo -j ACCEPT

###
### Inbound
###

# Open ssh (anywhere)
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT

# Allow ssh (specific IP)
#iptables -A INPUT -p tcp -s YOUR_IP_ADDRESS -m tcp --dport 22 -j ACCEPT

# Open http/https
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

# Allow SMTP
#iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 465 -j ACCEPT

# Allow POP3
#iptables -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT

# Allow IMAP
#iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT


###
### Outbound
###

# Allow to keep outgoing connections
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# block everything else
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP

# vim:ft=sh
