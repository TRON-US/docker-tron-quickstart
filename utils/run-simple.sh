#!/usr/bin/env bash

docker run -it \
  --rm \
  -p 8090:8090 \
  -p 8091:8091 \
  -p 8092:8092 \
  --name tron \
  tronquickstart
