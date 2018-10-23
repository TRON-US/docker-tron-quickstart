#!/usr/bin/env bash

echo "Tron Quickstart v0.1.0
Running db..."

mkdir -p /data/db
mkdir /data/db/log
mkdir /tron/logs

nohup mongod >> mongod.log 2>&1 &

sleep 3

echo "Setting events db..."

mongo < conf/set-mongo

rm -rf /tron/conf

echo "User created in events db."

pid=`ps -ef |grep mongod |grep -v grep |awk '{print $2}'`
if [ -n "$pid" ]; then
  kill $pid
fi

echo "

security:
  authorization: enabled" >> /etc/mongod.conf

echo "Restarting db..."

#service mongodb start
#
#echo "" > /tron/logs/mongod.log
nohup mongod >> /tron/logs/mongod.log 2>&1 &

echo "Starting nodes and event server..."

#mkdir /tron/logs

(cd /tron/tron-grid/target && nohup java -jar EventServer.jar >> /tron/logs/eventserver-start.log 2>&1 &)

(cd /tron/FullNode && nohup java -jar FullNode.jar -c config.conf >> /tron/logs/fullnode-start.log 2>&1 &)

(cd /tron/SolidityNode && nohup java -jar SolidityNode.jar -c config.conf >> /tron/logs/soliditynode-start.log 2>&1 &)

echo "Wait 3 seconds and start the http proxy for dApps"

#sleep 3

(nohup bash /tron/app/scripts/accounts-generation.sh >> /tron/logs/accounts-generation.log 2>&1 &)

node /tron/app
