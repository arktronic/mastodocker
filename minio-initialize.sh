#!/bin/bash

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"
source .env

docker compose run --rm minio-mc alias set main http://minio:9000 mastoadmin $MINIO_ADMIN_PASSWORD
docker compose run --rm minio-mc mb main/mastodon
docker compose run --rm minio-mc anonymous set-json /minio-conf/anonymous.json main/mastodon
docker compose run --rm minio-mc admin user add main mastouser $MINIO_USER_PASSWORD
docker compose run --rm minio-mc admin policy add main mastodonuser /minio-conf/mastodonuser.json
docker compose run --rm minio-mc admin policy set main mastodonuser user=mastouser

echo OK
