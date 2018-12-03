#!/usr/bin/env bash

docker run -it \
  --rm \
  -p 8090:8090 \
  -p 8091:8091 \
  -p 8092:8092 \
  -e "defaultBalance=100000" \
  -e "showQueryString=true" \
  -e "showBody=true" \
  -e "formatJson=true" \
  -e "useDefaultPrivateKey=true" \
  -e "accounts=1" \
  --name tron \
  tronquickstart
