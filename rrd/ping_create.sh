#!/bin/bash
#
# $Id: ping_create.sh 6 2006-09-10 15:35:16Z marcus $
#
# Exemplo from ESA 3rd ed.
#
# $ ./rra_calc.pl 300 1 600
#
#     Sample Resolution:          0y   0d   0h   5m   0s (300 secs)
#     Data Retention Timeframe:   0y   2d   2h   0m   0s (180000 secs)
#
# $ ./rra_calc.pl 300 6 700
#
#     Sample Resolution:          0y   0d   0h  30m   0s (1800 secs)
#     Data Retention Timeframe:   0y  14d  14h   0m   0s (1260000 secs)
#
# $ ./rra_calc.pl 300 24 775
#
#     Sample Resolution:          0y   0d   2h   0m   0s (7200 secs)
#     Data Retention Timeframe:   0y  64d  14h   0m   0s (5580000 secs)
#
# $ ./rra_calc.pl 300 288 750
#
#     Sample Resolution:          0y   1d   0h   0m   0s (86400 secs)
#     Data Retention Timeframe:   2y  20d   0h   0m   0s (64800000 secs)
#
# $ ./rra_calc.pl 300 288 797
#
#     Sample Resolution:          0y   1d   0h   0m   0s (86400 secs)
#     Data Retention Timeframe:   2y  67d   0h   0m   0s (68860800 secs)
#

[ -f ping.rrd ] && /bin/rm ping.rrd

rrdtool create ping.rrd \
    --start `perl -e "print time() - 60 * 60 * 24 * 2"` \
    --step 300          \
    DS:trip:GAUGE:600:U:U   \
    DS:lost:GAUGE:600:U:U   \
    RRA:AVERAGE:0.5:1:600   \
    RRA:AVERAGE:0.5:6:700   \
    RRA:AVERAGE:0.5:24:775  \
    RRA:AVERAGE:0.5:288:750 \
    RRA:MAX:0.5:1:600       \
    RRA:MAX:0.5:6:700       \
    RRA:MAX:0.5:24:775      \
    RRA:MAX:0.5:288:797
