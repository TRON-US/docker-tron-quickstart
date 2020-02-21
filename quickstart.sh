#!/usr/bin/env bash

node app/version

bash pre-approve.sh

nohup redis-server > /dev/null 2>&1 &

(cd FullNode && nohup java -jar FullNode.jar -c fullnode.conf --witness >/dev/null 2>&1 &)

# run eventron
(cd eventron && SECRET=TNSpckEZhGfZ4ryidHG2fYWMARLpZ6U139 \
REDISDBID=0 \
REDISHOSTM=127.0.0.1 \
REDISHOST=127.0.0.1 \
REDISPORT=6379 \
NODE_ENV=development \
ONLY_REDIS=yes \
SHASTAURL=http://127.0.0.1:18190 \
PRIVATE_NETWORK=yes pm2 start process.json)

# run blockparser
(cd BlockParser && nohup ./run.sh >/dev/null 2>&1 &)

echo "Start the http proxy for dApps..."
nohup scripts/accounts-generation.sh > /dev/null 2>&1 &

node /tron/app
