#!/usr/bin/env bash

docker run -it \
  --rm \
  -p 18090:8090 \
  -p 18091:8091 \
  -p 18092:8092 \
  -p 19090:9090 \
  -e "accounts=10" \
  --name tron0 \
  trontools/quickstart:latest