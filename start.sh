#!/usr/bin/env bash

echo "
Run mongodb"
nohup mongod >> mongod.log 2>&1 &

echo "
Wait 3 seconds and set the events db"
sleep 3
mongo < conf/set-mongo
rm -rf /tron/conf

echo "
Shut down mongo"
pid=`ps -ef |grep mongod |grep -v grep |awk '{print $2}'`
if [ -n "$pid" ]; then
  kill $pid
fi

echo "
Wait 3 seconds and start mongo with --auth"
sleep 3
nohup mongod --auth >> mongod.log 2>&1 &

echo "
Wait 3 seconds and start nodes and event server"
sleep 3

(cd /tron/tron-grid/target && nohup java -jar EventServer.jar >> start.log 2>&1 &)

(cd /tron/FullNode && nohup java -jar FullNode.jar -c config.conf --witness >> start.log 2>&1 &)

(cd /tron/SolidityNode && nohup java -jar SolidityNode.jar -c config.conf >> start.log 2>&1 &)

node /tron/app "$@"

