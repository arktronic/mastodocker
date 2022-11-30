#!/bin/bash

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

source .env || {
  echo ERROR: You do not have a .env file.
  echo Please copy "env.example" to ".env" and make any necessary changes to it first.
  exit 1
}

sudo mkdir -p $MASTODON_DATA_LOCATION
sudo chown -R 991:991 $MASTODON_DATA_LOCATION

sudo mkdir -p $ELASTICSEARCH_DATA_LOCATION
sudo chown -R 1000:1000 $ELASTICSEARCH_DATA_LOCATION

sudo mkdir -p $POSTGRES_DATA_LOCATION
sudo chown -R 70:70 $POSTGRES_DATA_LOCATION

sudo mkdir -p $REDIS_DATA_LOCATION
sudo chown -R 999 $REDIS_DATA_LOCATION

sudo mkdir -p $NGINX_DATA_LOCATION

[ -f ./.env.production ] || cp ./env.production.example ./.env.production

MAXMAPCT=$(cat /proc/sys/vm/max_map_count)
[ "$MAXMAPCT" -lt "262144" ] && {
  echo WARNING: your vm.max_map_count is below 262144. ElasticSearch will not function.
  echo See https://www.elastic.co/guide/en/elasticsearch/reference/7.17/vm-max-map-count.html
  exit 1
}

echo OK
