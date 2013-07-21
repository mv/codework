#!/bin/bash
#
# iptables for a standalone public server.
#
# server scenario:
# ----------------
#   - a server on Rackspace, Linode, DigitalOcean....
#   - I have a public IP, on interface 'eth0'
#
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2013-07
#

###
### Begin
###
  iptables -F

###
### Default Policies
###
  iptables -P INPUT   ACCEPT   # see 'Inbound: final' below !!!!
  iptables -P FORWARD DROP
  iptables -P OUTPUT  ACCEPT

###
### Default stuff
###

  iptables -A INPUT -i lo                                -j ACCEPT -m comment --comment 'allow: loopback interface'
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT -m comment --comment 'keep previous connections'
                  # -m limit --limit 50/minute --limit-burst 100 \

###
### Rules for packet flags
###
  iptables -A INPUT -p tcp ! --syn -m state --state NEW                  -j DROP -m comment --comment 'force SYN check for all NEW packets'

  iptables -A INPUT -p tcp   --tcp-flags SYN,FIN         SYN,FIN         -j DROP -m comment --comment 'invalid SYN,FIN         flags'
  iptables -A INPUT -p tcp   --tcp-flags SYN,RST         SYN,RST         -j DROP -m comment --comment 'invalid SYN,RST         flags'
  iptables -A INPUT -p tcp   --tcp-flags SYN,FIN,PSH     SYN,FIN,PSH     -j DROP -m comment --comment 'invalid SYN,FIN,PSH     flags'
  iptables -A INPUT -p tcp   --tcp-flags SYN,FIN,RST     SYN,FIN,RST     -j DROP -m comment --comment 'invalid SYN,FIN,RST     flags'
  iptables -A INPUT -p tcp   --tcp-flags SYN,FIN,RST,PSH SYN,FIN,RST,PSH -j DROP -m comment --comment 'invalid SYN,FIN,RST,PSH flags'
  iptables -A INPUT -p tcp   --tcp-flags FIN FIN                         -j DROP -m comment --comment 'invalid FIN             flags'
  iptables -A INPUT -p tcp   --tcp-flags ALL NONE                        -j DROP -m comment --comment 'invalid NULL packet'
  iptables -A INPUT -p tcp   --tcp-flags ALL ALL                         -j DROP -m comment --comment 'invalid XMAS packet'
  iptables -A INPUT -p tcp   --tcp-flags ALL FIN,URG,PSH                 -j DROP -m comment --comment 'invalid ALL FIN,URG,PSH         flags'
  iptables -A INPUT -p tcp   --tcp-flags ALL SYN,RST,ACK,FIN,URG         -j DROP -m comment --comment 'invalid ALL SYN,RST,ACK,FIN,URG flags'


##
## Drop syn flood
##

# iptables -A INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 3 -j RETURN

  iptables -N SYNFLOOD  # create New chain, please.

  iptables -A INPUT    -p tcp   --syn                          -j SYNFLOOD  -m comment --comment 'check using SYNFLOOD chain'
  iptables -A SYNFLOOD -m limit --limit 90/s --limit-burst 150 -j RETURN    -m comment --comment 'SYN flood: attack?'
  iptables -A SYNFLOOD -j DROP                                              -m comment --comment 'SYN flood: block'

##
## Bogus packets
##
  iptables -A INPUT   -m state --state INVALID -j DROP -m comment --comment 'input: bogus packet'
  iptables -A FORWARD -m state --state INVALID -j DROP -m comment --comment 'forward: bogus packet'
  iptables -A OUTPUT  -m state --state INVALID -j DROP -m comment --comment 'output: bogus packet'

##
## Servers with a Public IP: Linode, Rackspace, DigitalOcean et al....
##   sanitize: local ip's DO NOT APPEAR from the outside, right?
##
  iptables -A INPUT -i eth0 -s 10.0.0.0/8       -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'
  iptables -A INPUT -i eth0 -s 172.16.0.0/12    -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'
  iptables -A INPUT -i eth0 -s 192.168.0.0/24   -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'
  iptables -A INPUT -i eth0 -s 169.254.0.0/16   -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'

  iptables -A INPUT -i eth0 -s 224.0.0.0/4      -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'
  iptables -A INPUT -i eth0 -d 224.0.0.0/4      -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'
  iptables -A INPUT -i eth0 -s 240.0.0.0/5      -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'
  iptables -A INPUT -i eth0 -d 240.0.0.0/5      -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'
  iptables -A INPUT -i eth0 -s 0.0.0.0/8        -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'
  iptables -A INPUT -i eth0 -d 0.0.0.0/8        -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'

  iptables -A INPUT -i eth0 -d 239.255.255.0/24 -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'
  iptables -A INPUT -i eth0 -d 255.255.255.255  -j DROP -m comment --comment 'Mr. Spoof, you do not fool me!'

###
### Inbound
###

##
## Ping, please.
##
  iptables -A INPUT  -p icmp --icmp-type 8 -j ACCEPT -m comment --comment 'allow: icmp ping: echo-request'
  iptables -A INPUT  -p icmp --icmp-type 0 -j ACCEPT -m comment --comment 'allow: icmp ping: echo-reply'


##
## All my servers have ssh
##

# iptables -A INPUT -p tcp --dport    22 -m state --state NEW                         -j ACCEPT -m comment --comment 'allow: ssh new from anywhere'
# iptables -A INPUT -p tcp --dport    22 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT -m comment --comment 'ddos on ssh?'

  iptables -A INPUT -p tcp --dport    22 -m state --state NEW                         \
                                         -m limit --limit 25/minute --limit-burst 100 \
                                         -j ACCEPT -m comment --comment 'ssh: prevent ddos'

##
## I am a server: webserver
##
  iptables -A INPUT -p tcp --dport    80 -m state --state NEW                         \
                                         -m limit --limit 25/minute --limit-burst 100 \
                                         -j ACCEPT -m comment --comment 'http: prevent ddos'

  iptables -A INPUT -p tcp --dport   443 -m state --state NEW                         \
                                         -m limit --limit 25/minute --limit-burst 100 \
                                         -j ACCEPT -m comment --comment 'https: prevent ddos'

# iptables -A INPUT -p tcp --dport    80 -m state --state NEW -j ACCEPT -m comment --comment 'allow: http new'
# iptables -A INPUT -p tcp --dport   443 -m state --state NEW -j ACCEPT -m comment --comment 'allow: https new'
# iptables -A INPUT -p tcp --dport    80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT -m comment --comment 'ddos on http?'
# iptables -A INPUT -p tcp --dport   443 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT -m comment --comment 'ddos on https?'

##
## I am a server: pick all that apply
##
# iptables -A INPUT -p udp --dport   123 -m state --state NEW -j ACCEPT -m comment --comment 'allow: ntp'
# iptables -A INPUT -p tcp --dport    53 -m state --state NEW -j ACCEPT -m comment --comment 'allow: dns'
# iptables -A INPUT -p udp --dport    53 -m state --state NEW -j ACCEPT -m comment --comment 'allow: dns'
# iptables -A INPUT -p tcp --dport    25 -m state --state NEW -j ACCEPT -m comment --comment 'allow: smtp'
# iptables -A INPUT -p tcp --dport   465 -m state --state NEW -j ACCEPT -m comment --comment 'allow: smtp SSL'
# iptables -A INPUT -p tcp --dport   587 -m state --state NEW -j ACCEPT -m comment --comment 'allow: smtp TLS'
# iptables -A INPUT -p tcp --dport   110 -m state --state NEW -j ACCEPT -m comment --comment 'allow: pop3'
# iptables -A INPUT -p tcp --dport   995 -m state --state NEW -j ACCEPT -m comment --comment 'allow: pop3 ssl'
# iptables -A INPUT -p tcp --dport   143 -m state --state NEW -j ACCEPT -m comment --comment 'allow: imap'
# iptables -A INPUT -p tcp --dport   993 -m state --state NEW -j ACCEPT -m comment --comment 'allow: imap ssl'
# iptables -A INPUT -p tcp --dport   873 -m state --state NEW -j ACCEPT -m comment --comment 'allow: rsync'
# iptables -A INPUT -p tcp --dport  1521 -m state --state NEW -j ACCEPT -m comment --comment 'allow: Oracle Listener'
# iptables -A INPUT -p tcp --dport  1526 -m state --state NEW -j ACCEPT -m comment --comment 'allow: Oracle Listener'
# iptables -A INPUT -p tcp --dport  3128 -m state --state NEW -j ACCEPT -m comment --comment 'allow: proxy'
# iptables -A INPUT -p tcp --dport  3306 -m state --state NEW -j ACCEPT -m comment --comment 'allow: mysql'
# iptables -A INPUT -p tcp --dport  6380 -m state --state NEW -j ACCEPT -m comment --comment 'allow: redis'
# iptables -A INPUT -p tcp --dport 11211 -m state --state NEW -j ACCEPT -m comment --comment 'allow: memcache'
# iptables -A INPUT -p tcp --dport   137 -m state --state NEW -j ACCEPT -m comment --comment 'allow: samba'
# iptables -A INPUT -p tcp --dport   138 -m state --state NEW -j ACCEPT -m comment --comment 'allow: samba'
# iptables -A INPUT -p tcp --dport   139 -m state --state NEW -j ACCEPT -m comment --comment 'allow: samba'
# iptables -A INPUT -p tcp --dport   445 -m state --state NEW -j ACCEPT -m comment --comment 'allow: samba'


##
## My Blacklist of IP's
##
# iptables -A INPUT -s "BLOCK_THIS_IP"    -j DROP   -m comment --comment 'Blocked: a specific ip-address'
# iptables -A INPUT -s "BLOCK_THIS_IP"    -j DROP   -m comment --comment 'Blocked: a specific ip-address'
# iptables -A INPUT -s "BLOCK_THIS_IP"    -j DROP   -m comment --comment 'Blocked: a specific ip-address'

##
## My Whitelist of IP's
##
# iptables -A INPUT -s "ALLOW_THIS_IP/32" -j ACCEPT -m comment --comment 'Allow this IP, man!'
# iptables -A INPUT -s "ALLOW_THIS_IP/32" -j ACCEPT -m comment --comment 'Allow this IP, man!'
# iptables -A INPUT -s "ALLOW_THIS_IP/32" -j ACCEPT -m comment --comment 'Allow this IP, man!'


###
### Inbound: FINAL
###

##
## And how many times did I locked my self OUT ??????
##   Because of that, default policy above is ACCEPT, so if anybody flushes \
##   iptables I/he/she will have access to fix it.
##
## Obs:
##   REJECT: refuse with an error: for internal clients. Any error will help troubleshooting.
##   DROP  : refuse silently     : for external accesses. An attacker will have no extra clues.
##

# iptables -A INPUT -j REJECT -m comment --comment 'CHAIN INPUT - FINAL RULE: reject with error [This must close INPUT CHAIN.]'
  iptables -A INPUT -j DROP   -m comment --comment 'CHAIN INPUT - FINAL RULE: drop! [This must close INPUT CHAIN.]'


###
### Outbound
###   These rules are optional because default policy for OUTPUT traffic is ACCEPT.
###   But when ruling your OUTPUT traffic this way you can see in details your
###   outbound traffic by typing in your command line:
###
###     $ alias iptop="watch -n 1 'iptables -L -v -n --line-numbers'"
###     $ iptop
###

  iptables -A OUTPUT -p tcp  --sport  22   -j ACCEPT -m comment --comment 'outbound: ssh   traffic'
  iptables -A OUTPUT -p tcp  --sport  80   -j ACCEPT -m comment --comment 'outbound: http  traffic'
  iptables -A OUTPUT -p tcp  --sport 443   -j ACCEPT -m comment --comment 'outbound: https traffic'

  iptables -A OUTPUT -p icmp --icmp-type 0 -j ACCEPT -m comment --comment 'outbound: icmp ping: echo-reply'
  iptables -A OUTPUT -p icmp --icmp-type 8 -j ACCEPT -m comment --comment 'outbound: icmp ping: echo-request'


###
### Simple check
###
###   If everything is good, do not forget:
###   $ service iptables save     # (or equivalent)
###

  iptables -L -v --line-numbers



# vim:ft=sh:

