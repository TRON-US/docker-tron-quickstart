#!/usr/bin/env bash

node app/version

echo "Start nodes and event server..."

if [[ $allowSameTokenName == '1' ]];then
  echo "Pre-approving allowSameTokenName"
  echo "  allowSameTokenName = 1" >> /tron/conf/fullnode.conf
fi


echo "}" >> /tron/conf/fullnode.conf

mv conf/fullnode.conf FullNode/config.conf

(cd FullNode && nohup java -jar FullNode.jar -c config.conf --witness >/dev/null 2>&1 &)

# run eventron

(cd eventron && source env && nohup node . >/dev/null 2>&1 &)

(cd BlockParser && nohup ./run.sh >/dev/null 2>&1 &)


echo "Wait 3 seconds..."
sleep 3

echo "Start the http proxy for dApps..."
nohup scripts/accounts-generation.sh 2>&1 &
node /tron/app

