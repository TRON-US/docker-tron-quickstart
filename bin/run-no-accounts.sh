#!/usr/bin/env bash

docker run -it \
  --rm \
  -p 9090:9090 \
  -e "defaultBalance=100000" \
  -e "showQueryString=true" \
  -e "showBody=true" \
  -e "formatJson=true" \
  -e "useDefaultPrivateKey=true" \
  -e "accounts=1" \
  --name tron \
  tronquickstart
