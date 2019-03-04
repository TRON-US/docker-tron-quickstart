#!/usr/bin/env bash

if [[ $(docker inspect tron | grep NetworkSettings) != "" ]]; then
  docker rm -f tron
fi

docker run -it \
  -p 9090:9090 \
  -e "defaultBalance=100000" \
  -e "showQueryString=true" \
  -e "showBody=true" \
  -e "formatJson=true" \
  -e allowSameTokenName=1 \
  -e allowDelegateResource=1 \
  -e allowTvmTransferTrc10=1 \
  --name tron \
  trontools/quickstart
