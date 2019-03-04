#!/usr/bin/env bash

version=`cat version`

docker run -it \
  --rm \
  -p 9090:9090 \
  -e "accounts=10" \
  --name tron0 \
  trontools/quickstart:$version
