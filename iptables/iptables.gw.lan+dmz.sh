#!/bin/bash
#
# iptables for...
#
#
#   i--i--i--i-i-i
#   |            |
#   i  internet  i      L--L--L
#   |            |      |
#   i--i--i--i-i-i      L--L--L
#               \       |
#                g------L  local internal
#               /       |  network
#        d--d--d--d     L
#        |   dmz  |     |
#        d        |     L--L
#                 d
#
# g: gateway/firewall server: (this server)
# i: internet servers
# d: dmz servers
# L: local lan servers
#

# vim:ft=sh:

