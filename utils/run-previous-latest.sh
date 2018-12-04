#!/usr/bin/env bash

docker run -it \
  --rm \
  -p 8090:8090 \
  -p 8091:8091 \
  -p 8092:8092 \
  -p 9090:9090 \
  -e "accounts=10" \
  --name tron0 \
  trontools/quickstart:1.2.1