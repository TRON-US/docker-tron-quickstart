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
  -e "getMultiSignFee=1" \
  -e "getUpdateAccountPermissionFee=1" \
  -e "getTotalEnergyTargetLimit=1" \
  --name tron \
  tronquickstart
