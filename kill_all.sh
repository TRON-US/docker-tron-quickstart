pkill -f -9 redis-server
pkill -f -9 FullNode
pkill -f -9 eventron
pkill -f -9 BlockParser
pkill -f -9 /tron/app

nohup ./quickstart > /dev/null 2>&1 &
