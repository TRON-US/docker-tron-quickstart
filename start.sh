#!/usr/bin/env bash

echo "Tron Quickstart v0.0.6
Run mongodb"

mkdir -p /data/db

nohup mongod >> mongod.log 2>&1 &

echo "Wait 3 seconds and set the events db"

sleep 3

mongo < conf/set-mongo

rm -rf /tron/conf

echo "Shut down mongo"

pid=`ps -ef |grep mongod |grep -v grep |awk '{print $2}'`
if [ -n "$pid" ]; then
  kill $pid
fi

echo "Start mongo with --auth"

nohup mongod --auth >> mongod.log 2>&1 &

echo "Start nodes and event server"

mkdir /tron/logs

(cd /tron/tron-grid/target && nohup java -jar EventServer.jar >> /tron/logs/eventserver-start.log 2>&1 &)

(cd /tron/FullNode && nohup java -jar FullNode.jar -c config.conf --witness >> /tron/logs/fullnode-start.log 2>&1 &)

(cd /tron/SolidityNode && nohup java -jar SolidityNode.jar -c config.conf >> /tron/logs/soliditynode-start.log 2>&1 &)

echo "Wait 3 seconds and start the http proxy for dApps"

#sleep 3

(nohup bash /tron/app/scripts/accounts-generation.sh >> /tron/logs/accounts-generation.log 2>&1 &)

node /tron/app
