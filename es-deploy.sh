#!/bin/bash

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

docker compose exec web tootctl search deploy

echo OK
