#!/usr/bin/env bash

if [[ $(docker inspect tron | grep NetworkSettings) != "" ]]; then
  docker rm -f tron
fi

docker run -it --rm \
  -p 9090:9090 \
  -e "preapprove=maxCpuTimeOfOneTx:20" \
  --name tron \
  tronquickstart
