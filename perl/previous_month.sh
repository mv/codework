#!/bin/bash
#
# previous_month
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2009/Set
#

perl -e '
# current day/month/year
my ($dd, $mm, $yy) = (localtime)[3,4,5];

# first day of current month/year to epoch
use Time::Local; #sec, min, hr, mday,  mm, $yy);
$time = timelocal(  0,   0,  0,    1, $mm, $yy);

# previous day, i.e., previous month
$time -= 60 * 60 * 24 * 1 ; # 24h = 1d

# epoch to my date
use Time::localtime;
$tm = localtime($time);
printf("%04d_%02d\n", $tm->year+1900, $tm->mon+1);

'

