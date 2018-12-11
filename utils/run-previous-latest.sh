#!/usr/bin/env bash

version=`cat version`

docker run -it \
  --rm \
  -p 88090:8090 \
  -p 88091:8091 \
  -p 88092:8092 \
  -p 89090:9090 \
  -e "accounts=10" \
  --name tron0 \
  trontools/quickstart:$version
