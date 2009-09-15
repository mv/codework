    for i in `echo "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40"`
    do
        ping -n 1 $IP >> ping.txt
        RESULT="$?"

        if [ "$RESULT" = "0" ]
        then
            echo "Conectado a $IP"
            break;
        fi
        echo -n "   ...tentativa $i/40"
    done

--------------------------------------

i="0"

while [ "$i" -lt "3000000" ]
do
   i=$(echo "$i+1" | bc)
   echo $i
done



----------------------------


i="0"
while [ "$i" -lt "30" ]
do
   i=`expr $i + 1`
   echo $i
done


------------------------------

factorial()
{
  if [ "$1" -gt "1" ]; then
    i=`expr $1 - 1`
    j=`factorial $i`
    k=`expr $1 \* $j`
    echo $k
  else
    echo 1
  fi
}


while :
do
  echo "Enter a number:"
  read x
  factorial $x
done

