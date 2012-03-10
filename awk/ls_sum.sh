
/bin/ls -l | \
    awk '{ sa += $2 ; sb += $5 ; print "-- ",$2,$5 } END{ print "==",sa,sb,"\n" }'

