#!/usr/bin/env bash

docker rmi trontools/quickstart
docker tag tronquickstart trontools/quickstart:$1
docker tag tronquickstart trontools/quickstart:latest