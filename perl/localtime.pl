
# /bin/date
print scalar localtime, "\n";

# date "+%d %m %Y" - date "+%Y-%m-%d" - date "+%F"
my ($dd, $mm, $yy) = (localtime)[3,4,5];

# date "+%X" or date "+%H:%M:%S"
my ($hh, $mi, $ss) = (localtime)[2,1,0];

# date "+%u %j %Z"
my ($wday, $yday, $isdst) = (localtime)[6,7,8];

