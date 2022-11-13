#!/bin/bash

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

docker compose run --rm web rails db:migrate
