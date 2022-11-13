#!/bin/bash

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

mkdir -p ./public/system
sudo chown -R 991:991 ./public

mkdir -p ./elasticsearch
sudo chown -R 1000:1000 ./elasticsearch

mkdir -p ./postgres
sudo chown -R 70:70 ./postgres

mkdir -p ./redis
sudo chown -R 999 ./redis

[ -f ./.env.production ] || cp ./env.production.example ./.env.production

MAXMAPCT=$(cat /proc/sys/vm/max_map_count)
[ "$MAXMAPCT" -lt "262144" ] && {
  echo WARNING: your vm.max_map_count is below 262144. ElasticSearch will not function.
  echo See https://www.elastic.co/guide/en/elasticsearch/reference/7.17/vm-max-map-count.html
  exit 1
}

echo OK
