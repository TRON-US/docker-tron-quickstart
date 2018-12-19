#!/usr/bin/env bash

# This script is here to support the development.
# If you like to use this with the actual image replace tronquickstart with trontools/quickstart

(

# creating the local folders if it do not exist yet
if [[ ! -d "tron-data" ]]; then
  mkdir tron-data
fi

# running the container using the local volumes
docker run -it -p 8091:8091 -p 8092:8092 -p 8090:8090 \
  --name tron \
  -v $PWD/tron-data:/config \
  tronquickstart
)