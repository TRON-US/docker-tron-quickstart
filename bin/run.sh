#!/usr/bin/env bash

if [[ $(docker inspect tron | grep NetworkSettings) != "" ]]; then
  docker rm -f tron
fi

docker run -it \
  -p 8090:8090 \
  -p 8091:8091 \
  -p 8092:8092 \
  -p 9090:9090 \
  -p 50051:50051 \
  -p 50052:50052 \
  -e "defaultBalance=100000" \
  -e "showQueryString=true" \
  -e "showBody=true" \
  -e "formatJson=true" \
  --name tron \
  tronquickstart
