#!/usr/bin/env bash

docker run -it \
  --rm \
  -p 9090:9090 \
  --name tron \
  tronquickstart
