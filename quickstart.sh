#!/usr/bin/env bash

node app/version

echo "Run MongoDB..."

nohup mongod >> mongod.log 2>&1 &

sleep 1
ps aux

echo "Set the events db..."
sleep 3
mongo < conf/set-mongo

echo "Shut down MongoDB..."
pid=`ps -ef |grep mongod |grep -v grep |awk '{print $2}'`
if [ -n "$pid" ]; then
  kill $pid
fi

echo "Wait 3 seconds..."
sleep 3

echo "Start MongoDB with --auth"
nohup mongod --auth >> mongod.log 2>&1 &

echo "Wait 3 seconds..."
sleep 3

echo "Start nodes and event server..."

if [[ $allowSameTokenName == '1' ]];then
  echo "Pre-approving allowSameTokenName"
  echo "  allowSameTokenName = 1" >> /tron/conf/fullnode.conf
  echo "  allowSameTokenName = 1" >> /tron/conf/soliditynode.conf
fi
#if [[ $allowUpdateAccountName == '1' ]];then
#  echo "Pre-approving allowUpdateAccountName"
#  echo "  allowUpdateAccountName = 1" >> /tron/conf/fullnode.conf
#  echo "  allowUpdateAccountName = 1" >> /tron/conf/soliditynode.conf
#fi
if [[ $allowDelegateResource == '1' ]];then
  echo "Pre-approving allowDelegateResource"
  echo "  allowDelegateResource = 1" >> /tron/conf/fullnode.conf
  echo "  allowDelegateResource = 1" >> /tron/conf/soliditynode.conf
fi
if [[ $allowTvmTransferTrc10 == '1' ]];then
  echo "Pre-approving allowTvmTransferTrc10"
  echo "  allowTvmTransferTrc10 = 1" >> /tron/conf/fullnode.conf
  echo "  allowTvmTransferTrc10 = 1" >> /tron/conf/soliditynode.conf
fi
echo "}" >> /tron/conf/fullnode.conf
echo "}" >> /tron/conf/soliditynode.conf

mv /tron/conf/fullnode.conf /tron/FullNode/config.conf
mv /tron/conf/soliditynode.conf /tron/SolidityNode/config.conf

(cd /tron/tron-grid/target && nohup java -jar EventServer.jar >/dev/null 2>&1 &)
(cd /tron/FullNode && nohup java -jar FullNode.jar -c config.conf --witness >/dev/null 2>&1 &)
(cd /tron/SolidityNode && nohup java -jar SolidityNode.jar -c config.conf >/dev/null 2>&1 &)

echo "Wait 3 seconds..."
sleep 3

echo "Start the http proxy for dApps..."
nohup bash /tron/scripts/accounts-generation.sh 2>&1 &
node /tron/app

