#!/bin/bash

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

docker compose run --rm -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 web bundle exec rails db:setup

echo OK
