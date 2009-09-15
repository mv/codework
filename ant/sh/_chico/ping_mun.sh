

echo /dev/null > ./ping.txt

for IP in `awk '{print $4}' dba_mun.txt|grep -v "^#"`
do

    echo "[ $IP ]"
    ping.exe -n 50 $IP | tee -a ping.txt

done

