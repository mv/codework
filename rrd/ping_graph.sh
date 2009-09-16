


rrdtool graph ping1.png  \
    --title "Packet trip times"    \
    DEF:time=ping.rrd:trip:AVERAGE  \
    LINE2:time\#0000ff

rrdtool graph ping2.png  \
    --title "Packet trip times"    \
    DEF:time=ping.rrd:trip:AVERAGE  \
    DEF:lost=ping.rrd:lost:AVERAGE  \
    LINE2:time\#0000ff              \
    LINE2:lost\#ff0000

