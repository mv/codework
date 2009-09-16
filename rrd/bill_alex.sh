<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!-- saved from url=(0043)http://www.rrdtool.com/gallery/alex-01.bash -->
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=windows-1252">
<META content="MSHTML 6.00.2733.1800" name=GENERATOR></HEAD>
<BODY><PRE>#!/bin/bash

# Slightly modified version of my script to check the bill
# Alex van den Bogaerdt &lt;alex@ergens.op.Het.Net&gt; , oct 11, 2000
#
# It is hereby in the public domain.  Use at your own risk.
#
# Prices, bandwidth etcetera are not fetched from a database
# in this example.  You need to modify that anyway.
#
# To be useful, this script needs access to an RRD which covers
# at least two months worth of data, in the correct resolution.
#
# For an RRA which covers 62 days (2 months), 15 minutes per
# sample, 512kbps:
#
# rrdtool create internet.rrd --step 900
#       DS:int1in:COUNTER:1000:0:64000 \
#       DS:int1out:COUNTER:1000:0:64000 \
#       RRA:AVERAGE:0.5:1:6000

exec 2&gt;&amp;1

FIXEDk=64
LIMITk=512
FIXED=$((FIXEDk*1000))
LIMIT=$((LIMITk*1000))

ACCESSLINE=2585.05
FIXEDPRICE=530.00
PERinb=9.50
PERout=0.95

RRD=/home/rrdtool/rrddata/internet.rrd

/bin/rm -f /home/rrdtool/rrdpng/internet*.png

echo 'Content-Type: text/html'
echo ''

export DATUM=`/bin/date +date/time:\ %Y%m%d\ %H:%M:%S`
export FILENAME=`/bin/date +%s`$$

#
# Calculate 1st of the month
#
# Tip, use a script here that can parse QUERY_STRING.  This allows you
# to setup some links with varying time spans.  You will be interested
# in intermediate results; such as "what would the bill be like if the
# traffic would be like this the whole month long".
#
FIRST=`/bin/date +%Y%m01`
LAST=`date -d $FIRST +%s`
START=end-1m

#
# And finally the output:
#
echo '&lt;HTML&gt;&lt;HEAD&gt;&lt;TITLE&gt;Internet&lt;/TITLE&gt;&lt;/HEAD&gt;'
echo '&lt;BODY text="#FFFFFF" bgcolor="#000000" alink="#FFFF00" vlink="#FF00FF" link="#FFFF00"&gt;'
echo '&lt;TABLE border=0 align=center width=760 cellpadding=0 cellspacing=0&gt;'
echo -n '&lt;TR&gt;&lt;TD&gt;'
echo 'Our internet provider will bill us for the amount of bandwidth used
	per month.  Part of this bandwidth is prepaid, the rest is paid for
	on a kilobit-per-second basis.  Bandwidth used outside the red lines
	is expensive as this needs to be paid for separately in addition to
	the fee for the connection itself.'
echo '&lt;/TD&gt;&lt;/TR&gt;'

echo '&lt;TR&gt;&lt;TD&gt;&lt;HR&gt;&lt;/TR&gt;'

echo -n '&lt;TR&gt;&lt;TD&gt;'

# Easy workaround for avoiding caches.  Just alter the filename ...
/usr/local/bin/rrdtool graph "/home/rrdtool/rrdpng/internet-b-$FILENAME.png"		\
	--title="Internet Router, Fixed=$FIXED   $DATUM"		\
	--end "${LAST}" --start "${START}"				\
	--vertical-label "bits per second"				\
	--imginfo '&lt;IMG src="/rrdpng/%s" WIDTH="%lu" HEIGHT="%lu"&gt;'	\
	--imgformat PNG							\
	--y-grid 64000:2						\
	--lower-limit -$LIMIT						\
	--upper-limit  $LIMIT						\
	--color CANVAS#000000						\
	--color BACK#101010						\
	--color FONT#C0C0C0						\
	--color MGRID#80C080						\
	--color GRID#808020						\
	--color FRAME#808080						\
	--color ARROW#FFFFFF						\
	--color SHADEA#404040						\
	--color SHADEB#404040						\
	--height 256							\
	--width 480							\
	DEF:bytesinb="$RRD":int1in:AVERAGE				\
	DEF:bytesout="$RRD":int1out:AVERAGE				\
	CDEF:inb=bytesinb,8,*						\
	CDEF:out=bytesout,8,*						\
	CDEF:Iinb=inb,$FIXED,LE,inb,$FIXED,IF				\
	CDEF:Iout=out,$FIXED,LE,out,$FIXED,IF				\
	CDEF:Oinb=inb,$FIXED,LE,0,inb,$FIXED,-,IF			\
	CDEF:Oout=out,$FIXED,LE,0,out,$FIXED,-,IF			\
	CDEF:Pinb=Oinb,$PERinb,*,1000,/					\
	CDEF:Pout=Oout,$PERout,*,1000,/					\
	CDEF:Ptotal=Pinb,Pout,$FIXEDPRICE,$ACCESSLINE,+,+,+		\
	CDEF:NIinb=Iinb,0,EQ,Iinb,Iinb,-1,*,IF				\
	CDEF:NOinb=Oinb,0,EQ,Oinb,Oinb,-1,*,IF				\
	HRULE:$FIXED#FF0000:"Outside these lines costs extra per kbps"	\
	COMMENT:"F $PERout for outgoing, F $PERinb for incoming\n"	\
	COMMENT:"\n"							\
	COMMENT:"traffic      "						\
	COMMENT:"Max          Min         Average      UBB tarif  (  price   )    Last\n"\
	AREA:Iout#00C000:"from HC\:"					\
	STACK:Oout#C0FF00						\
	GPRINT:out:MAX:"%6.2lf %sbps"					\
	GPRINT:out:MIN:"%6.2lf %sbps"					\
	GPRINT:out:AVERAGE:"%6.2lf %sbps"				\
	GPRINT:Oout:AVERAGE:"%6.2lf %sbps"				\
	GPRINT:Pout:AVERAGE:"(Fl%8.2lf)"				\
	GPRINT:out:LAST:"%6.2lf %sbps\\n"				\
	AREA:NIinb#0000FF:"into HC\:"					\
	STACK:NOinb#C080FF						\
	GPRINT:inb:MAX:"%6.2lf %sbps"					\
	GPRINT:inb:MIN:"%6.2lf %sbps"					\
	GPRINT:inb:AVERAGE:"%6.2lf %sbps"				\
	GPRINT:Oinb:AVERAGE:"%6.2lf %sbps"				\
	GPRINT:Pinb:AVERAGE:"(Fl%8.2lf)"				\
	GPRINT:inb:LAST:"%6.2lf %sbps\\n"				\
	HRULE:$LIMIT#000000:"Access Line                              "	\
	COMMENT:"                    Fl $ACCESSLINE   $LIMITk.00 kbps\n"\
	HRULE:-$FIXED#FF0000:"Fixed tarif                              "\
	COMMENT:"                    Fl  $FIXEDPRICE    $FIXEDk.00 kbps\n"\
	COMMENT:"The bill should read, approximately,                 "	\
	GPRINT:Ptotal:AVERAGE:"         Fl %8.2lf\n"		\
	| sed 's/[0-9]*x[0-9]*//'
	echo '&lt;/TR&gt;&lt;/TABLE&gt;'
echo '&lt;/BODY&gt;&lt;/HTML&gt;'
----cut here----
</PRE></BODY></HTML>
