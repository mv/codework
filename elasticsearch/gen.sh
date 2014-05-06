

show_dump() {
  echo ./dump.1.sh ${1}
}

show_delete() {
  echo curl -XDELETE http://10.0.2.250:9200/${1}
}

# 02
for d in 09 11 14 {17..28}
do
# show_dump   logstash-2014.02.${d}
  show_delete logstash-2014.02.${d}
done

# 03
for d in  {1..9}
do
  show_delete logstash-2014.03.0${d}
done

for d in  {10..31}
do
  show_delete logstash-2014.03.${d}
done

