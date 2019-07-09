#!/usr/bin/env bash

if [[ $(docker inspect tron | grep NetworkSettings) != "" ]]; then
  docker rm -f tron
fi

docker run -it --rm \
  -p 9090:9090 \
  -e "defaultBalance=100000" \
  -e "showQueryString=true" \
  -e "showBody=true" \
  -e "formatJson=true" \
  --name tron \
  trontools/quickstart:2.0.15
