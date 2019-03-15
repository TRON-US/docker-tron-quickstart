#!/usr/bin/env bash

node app/version

echo "Start nodes and event server..."

if [[ $getTotalEnergyTargetLimit == '1' ]];then
  echo "Pre-approving getTotalEnergyTargetLimit"
  echo "getTotalEnergyTargetLimit = 1" >> /tron/FullNode/fullnode.conf
fi

if [[ $getUpdateAccountPermissionFee == '1' ]];then
  echo "Pre-approving getUpdateAccountPermissionFee"
  echo "getUpdateAccountPermissionFee = 1" >> /tron/FullNode/fullnode.conf
fi

if [[ $getMultiSignFee == '1' ]];then
  echo "Pre-approving getMultiSignFee"
  echo "getMultiSignFee = 1" >> /tron/FullNode/fullnode.conf
fi

echo "}" >> /tron/FullNode/fullnode.conf

nohup redis-server > /dev/null 2>&1 &

(cd FullNode && nohup java -jar FullNode.jar -c fullnode.conf --witness >/dev/null 2>&1 &)

# run eventron
(cd eventron && SECRET=TNSpckEZhGfZ4ryidHG2fYWMARLpZ6U139 \
REDISDBID=0 \
REDISHOSTM=127.0.0.1 \
REDISHOST=127.0.0.1 \
REDISPORT=6379 \
NODE_ENV=development \
ONLY_REDIS=yes pm2 start process.json)

# run blockparser
(cd BlockParser && nohup ./run.sh >/dev/null 2>&1 &)

echo "Start the http proxy for dApps..."
nohup scripts/accounts-generation.sh > /dev/null 2>&1 &

node /tron/app
