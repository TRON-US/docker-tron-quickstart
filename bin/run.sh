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
  -e "preapprove=multiSignFee:1,allowMultiSign:1,updateAccountPermissionFee:1,totalEnergyTargetLimit:1" \
  --name tron \
  tronquickstart
