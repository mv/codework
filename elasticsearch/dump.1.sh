#!/bin/bash

dump_dir=/root/logstash
elasticdump=/root/node_modules/elasticdump/bin/elasticdump

host=10.0.2.250
port=9200

[ -z "$1" ] && {
  echo "Usage: $0 index_name"
  exit 1
}

idx="$1"

${elasticdump} \
  --input=http://${host}:${port}/${idx} \
  --bulk \
  --ouput=$ | gzip -c > ${idx}.dump.json.gz

