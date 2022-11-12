#!/bin/bash

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

echo Getting secret 1...
SECRET1=$(docker compose run --rm web bundle exec rake secret)
echo Getting secret 2...
SECRET2=$(docker compose run --rm web bundle exec rake secret)
echo Getting secret keypair....
VAPID_LINES=$(docker compose run --rm web bundle exec rake mastodon:webpush:generate_vapid_key)

sed -i "s/^SECRET_KEY_BASE=.*$/SECRET_KEY_BASE=$SECRET1/g" .env.production
sed -i "s/^OTP_SECRET=.*$/OTP_SECRET=$SECRET2/g" .env.production
sed -i "/^VAPID_PRIVATE_KEY=.*$/d" .env.production
sed -i "s/^VAPID_PUBLIC_KEY=.*$/VAPID_KEY_TMP_DELETEME=/g" .env.production
sed -i "/^VAPID_KEY_TMP_DELETEME=.*$/r /dev/stdin" .env.production <<< "$VAPID_LINES"
sed -i "/^VAPID_KEY_TMP_DELETEME=.*$/d" .env.production

echo OK
