for (( x=-10 ; x<=50 ; x=x+1 )) ; do echo $x ; done
for (( x=-10 ; x<=20 ; x=x+1 )) ; do echo $x ; done
for (( x=-10 ; x<=20 ; x++ )) ; do echo $x ; done
for (( x=-10 ; x<=20 ; x=x+2 )) ; do echo $x ; done
for (( x=-10 ; x<=20 ; x=x+3 )) ; do echo $x ; done

x=0; while true; do (( x = x + 1 )); echo $x; sleep 1; done

for (( x=0 ; x<=20 ; x++ )) ;
do
    file=`printf "file_%02d.txt " $x`
    echo $file
    touch $file
done
