# Trondev (Docker)

__A docker image exposing a full node, a solidity node and an event server, i.e., a complete private network for Tron developers.__


Run it with:
```
docker run -it -p 8091:8091 -p 8092:8092 -p 8090:8090 --rm --name trondev0 sullof/trondev
```

Notice the `--rm` option which will delete the container when you stop it.

If running a migration or a test you have an error, most likely it is because you did it too early and the nodes didn't sync yet.

If you are using [TronBox](https://www.npmjs.com/package/tronbox), you can config your `tronbox.js` file as:
```
module.exports = {
  networks: {
    development: {
      from: 'TPL66VK2gCXNCD7EJg9pgJRfqcRazjhUZY',
      privateKey: 'da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0',
      consume_user_resource_percent: 30,
      fee_limit: 100000000,
      fullNode: "http://127.0.0.1:8090",
      solidityNode: "http://127.0.0.1:8091",
      eventServer: "http://127.0.0.1:8092",
      network_id: "*"
    }
  }
};


```

If you need to expose different ports, you can set them running the container. For example:
```
docker run -it -p 3000:8090 -p 3001:8091 -p 3002:8092 --rm sullof/trondev
```

To verify that the docker is running correctly, execute
```
docker exec -it trondev0 ps aux
```
You should see something like this:
```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  20044  3604 pts/0    Ss+  12:13   0:00 bash ./start.sh
root        13  0.6  3.6 1103840 74600 pts/0   Sl+  12:13   0:03 mongod
root        15  0.0  0.0  20044   276 pts/0    S+   12:13   0:00 bash ./start.sh
root        16  6.7 18.7 4068380 384224 pts/0  Sl+  12:13   0:36 java -jar EventServer.jar
root        18  0.0  0.0  20044   276 pts/0    S+   12:13   0:00 bash ./start.sh
root        21  0.0  0.0  20044   276 pts/0    S+   12:13   0:00 bash ./start.sh
root        22  5.5 14.8 4162892 303812 pts/0  Sl+  12:13   0:29 java -jar SolidityNode.jar -c config.conf
root        23  0.1  2.1 891672 43412 pts/0    Sl+  12:13   0:01 node /tron/dev
root        24  7.2 18.6 4173968 382408 pts/0  Sl+  12:13   0:38 java -jar FullNode.jar -c config.conf --witness
root       100  0.0  0.1  20176  3796 pts/1    Ss   12:13   0:00 bash
root       336  0.0  0.1  36068  3184 pts/1    R+   12:22   0:00 ps aux
```
If mongod, some of the nodes or the event server are not running, restart the container:
```
docker restart trondev0
```
Be careful, since we used the `--rm` option, restarting the container you will reset the data, similarly to what happens when you stop and run `ganache-cli` again in Truffle.

To see the logs of the full node you can execute
```
docker exec -it trondev0 tail -f /tron/FullNode/logs/tron.log
```
and you can do the same for the solidity node
```
docker exec -it trondev0 tail -f /tron/SolidityNode/logs/tron.log
```

If you prefer to have a stable private network, you can run the image avoiding using the self removing option (`--rm`). Even better, you can set local volumes and run the container telling it to use them:
```
mkdir fullnode-logs
mkdir fullnode-output-directory
mkdir soliditynode-logs
mkdir soliditynode-output-directory
mkdir mongo-data
docker run -d -p 8091:8091 -p 8092:8092 -p 8090:8090 \
  --name trondev0 \
  -v $PWD/mongo-data:/data/db \
  -v $PWD/fullnode-logs:/tron/FullNode/logs \
  -v $PWD/fullnode-output-directory:/tron/FullNode/output-directory \
  -v $PWD/soliditynode-logs:/tron/SolidityNode/logs \
  -v $PWD/soliditynode-output-directory:/tron/SolidityNode/output-directory \
  sullof/trondev
```

If you like to check the event database, connect to mongo like:
```
mongo
use events
db.auth('trondev','vednort')
db.events.find()
```
