
while(1) {
    $date=`/bin/date`;
    chomp $date;
    print "Date: $date ", time, "\r";
}

