#!/usr/bin/env bash

docker rm -f tron0

docker run -it \
  --rm \
  -p 9090:8090 \
  -p 9091:8091 \
  -p 9092:8092 \
  -e "accounts=10" \
  --name tron0 \
  trontools/quickstart:0.0.6