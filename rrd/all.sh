
rrdtool create all.rrd 
    --start 978300900 \
    DS:a:COUNTER:600:U:U \
    DS:b:GAUGE:600:U:U \
    DS:c:DERIVE:600:U:U \
    DS:d:ABSOLUTE:600:U:U \
    RRA:AVERAGE:0.5:1:10

rrdtool update all.rrd \
    978301200:300:1:600:300 \
    978301500:600:3:1200:600 \
    978301800:900:5:1800:900 \
    978302100:1200:3:2400:1200 \
    978302400:1500:1:2400:1500 \
    978302700:1800:2:1800:1800 \
    978303000:2100:4:0:2100 \
    978303300:2400:6:600:2400 \
    978303600:2700:4:600:2700 \
    978303900:3000:2:1200:3000

rrdtool graph all.png \
    -s 978300600 -e 978304200 -h 400 \
    DEF:linea=all.rrd:a:AVERAGE LINE3:linea#FF0000:"Line A" \
    DEF:lineb=all.rrd:b:AVERAGE LINE3:lineb#00FF00:"Line B" \
    DEF:linec=all.rrd:c:AVERAGE LINE3:linec#0000FF:"Line C" \
    DEF:lined=all.rrd:d:AVERAGE LINE3:lined#000000:"Line D"

