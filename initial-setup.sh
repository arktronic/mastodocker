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

echo OK
