#!/usr/bin/env bash

version=`cat version`
docker push trontools/quickstart:$version
docker push trontools/quickstart:latest