#!/usr/bin/env bash

docker rm -f tron

(
# creating the local folders

mkdir tron-data
cd tron-data

mkdir data          # Mongodb and Proxy app data
mkdir -p fn/logs    # Logs of the full node
mkdir -p fn/output  # Data full node
mkdir -p sn/logs    # Logs solidity node
mkdir -p sn/output  # Data solidity node

# running the container using the local volumes

docker run -it -p 8091:8091 -p 8092:8092 -p 8090:8090 \
  --name tron \
  -v $PWD/data:/data \
  -v $PWD/fn/logs:/tron/FullNode/logs \
  -v $PWD/fn/output:/tron/FullNode/output-directory \
  -v $PWD/sn/logs:/tron/SolidityNode/logs \
  -v $PWD/sn/output:/tron/SolidityNode/output-directory \
  tron-quickstart

)