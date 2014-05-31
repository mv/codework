
es="http://localhost:9200"
dir="/mnt/dump"

es_dump() {
  echo es_dump_restore dump $es $1 ${dir}/${1}.zip
}

# 04
for d in  {1..9}
do
  es_dump logstash-2014.04.0${d}
done

for d in  {10..30}
do
  es_dump logstash-2014.04.${d}
done

# 05
for d in  {1..9}
do
  es_dump logstash-2014.05.0${d}
done

