#!/bin/bash

dump_dir=/root/logstash
dump_dir=/mnt/dump
elasticdump=/root/node_modules/elasticdump/bin/elasticdump

host=10.0.2.250
port=9200

[ -z "$1" ] && {
  echo "Usage: $0 index_name"
  exit 1
}

idx="$1"

${elasticdump} \
  --input=http://${host}:${port}/${idx} --output=${dump_dir}/${idx}.dump.json --limit 10000

# --input=http://${host}:${port}/${idx} --output=${dump_dir}/${idx}.dump.json --bulk
# --input=http://${host}:${port}/${idx} --output=$ | gzip -c > ${dump_dir}/${idx}.dump.json.gz
# --input=http://${host}:${port}/${idx} --output=${dump_dir}/${idx}.dump.json

#gzip -v ${dump_dir}/${idx}.dump.json


