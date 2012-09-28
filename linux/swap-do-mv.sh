
/proc/887/smaps:Swap:                  4 kB
/proc/887/smaps:Swap:                  4 kB
/proc/887/smaps:Swap:                 16 kB
/proc/887/smaps:Swap:                  4 kB
/proc/887/smaps:Swap:                 12 kB
/proc/887/smaps:Swap:                 12 kB
/proc/887/smaps:Swap:                  8 kB
/proc/887/smaps:Swap:                  4 kB
/proc/887/smaps:Swap:                  4 kB
/proc/887/smaps:Swap:                  4 kB
/proc/887/smaps:Swap:                  8 kB
/proc/889/smaps:Swap:                  4 kB
/proc/889/smaps:Swap:                  4 kB
/proc/889/smaps:Swap:                 16 kB
/proc/889/smaps:Swap:                  4 kB
/proc/889/smaps:Swap:                 12 kB
/proc/889/smaps:Swap:                 12 kB
/proc/889/smaps:Swap:                  8 kB
/proc/889/smaps:Swap:                  4 kB
/proc/889/smaps:Swap:                  4 kB
/proc/889/smaps:Swap:                  4 kB
/proc/889/smaps:Swap:                  4 kB


grep Swap /proc/[0-9]*/smaps | awk ' /proc\/([0-9]+)/   { swap[$1] += $2 } END { for (x in swap){print x,swap[x]}} '

grep Swap /proc/[0-9]*/smaps | awk ' /proc\/([0-9]+)/   { print $1,$2,$3 }'


time sudo grep Swap /proc/[0-9]*/smaps | awk ' /proc\/([0-9]+)/   { swap[$1] += $2 } END { for (x in swap){print x,swap[x]}} ' | column -t | sort -r -nk 2 | awk -F/ '{print $3,$4}' | awk '{print $1,$3}' | column -t

time sudo grep Swap /proc/[0-9]*/smaps | grep -v '0 kB' | awk '{ swap[$1] += $2 } END { for (x in swap){print x,swap[x]}} ' | column -t | sort -r -nk 2 | awk -F/ '{print $3,$4}' | awk '{print $1,$3}' | column -t


