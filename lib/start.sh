#!/usr/bin/env bash

(cd /tron/tron-grid/target && nohup java -jar infura-0.0.1-SNAPSHOT.jar >> start.log 2>&1 &)

(cd /tron/FullNode && nohup java -jar FullNode.jar -c config.conf >> start.log 2>&1 &)

(cd /tron/SolidityNode && nohup java -jar SolidityNode.jar -c config.conf >> start.log 2>&1 &)

cd /tron/lib
node proxy.js

