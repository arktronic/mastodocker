#!/bin/bash

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

echo Getting secret 1...
SECRET1=$(openssl rand -hex 64)
echo Getting secret 2...
SECRET2=$(openssl rand -hex 64)
echo Getting secret 3...
SECRET3=$(openssl rand -hex 32)
echo Getting secret 4...
SECRET4=$(openssl rand -hex 32)
echo Getting secret 5...
SECRET5=$(openssl rand -hex 32)
echo Getting secret keypair....
VAPID_LINES=$(docker compose run --rm mastohelper bundle exec rake mastodon:webpush:generate_vapid_key)

sed -i "s/^SECRET_KEY_BASE=.*$/SECRET_KEY_BASE=$SECRET1/g" .env.production
sed -i "s/^OTP_SECRET=.*$/OTP_SECRET=$SECRET2/g" .env.production
sed -i "/^VAPID_PRIVATE_KEY=.*$/d" .env.production
sed -i "s/^VAPID_PUBLIC_KEY=.*$/VAPID_KEY_TMP_DELETEME=/g" .env.production
sed -i "/^VAPID_KEY_TMP_DELETEME=.*$/r /dev/stdin" .env.production <<< "$VAPID_LINES"
sed -i "/^VAPID_KEY_TMP_DELETEME=.*$/d" .env.production

sed -i "s/^POSTGRES_PASSWORD=.*$/POSTGRES_PASSWORD=$SECRET3/g" .env
sed -i "s/^ELASTICSEARCH_PASSWORD=.*$/ELASTICSEARCH_PASSWORD=$SECRET4/g" .env
sed -i "s/^MINIO_ADMIN_PASSWORD=.*$/MINIO_ADMIN_PASSWORD=$SECRET5/g" .env

echo OK
