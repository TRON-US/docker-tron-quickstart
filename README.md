# Docker Trondev

__A container exposing a full node, a solidity node and an event server, i.e., a complete private network for Tron developers.__

### This is a work-in-progress and at the moment it does not work properly because when you try to deploy a contract, it fails. If you like to help me fixing the errors, fork this repo and propose improvements. Thanks :-)


To run it
```
docker run -d -p 8091:8091 -p 8092:8092 -p 8090:8090 --rm --name trondev0 sullof/trondev
```
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
docker run -d -p 3000:8090 -p 3001:8091 -p 3002:8092 --rm sullof/trondev
```

To verify that the docker is running correctly, execute
```
docker exec -it trondev0 bash
```
And there, execute `ps aux`, like in this example:
```
root@28d6355d5f9d:/tron# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  20044  3420 ?        Ss   14:36   0:00 bash ./start.sh
root         9  0.0  0.0  20044   268 ?        S    14:36   0:00 bash ./start.sh
root        10  1.6 20.1 4068380 412544 ?      Sl   14:36   0:43 java -jar infura-0.0.1-SNAPSHOT.jar
root        12  0.0  0.0  20044   272 ?        S    14:36   0:00 bash ./start.sh
root        13  2.1 14.4 4174604 295868 ?      Sl   14:36   0:57 java -jar FullNode.jar -c config.conf
root        15  0.0  0.0  20044   272 ?        S    14:36   0:00 bash ./start.sh
root        16  0.0  2.0 891172 41576 ?        Sl   14:36   0:00 node proxy.js
root        17  1.5 14.6 4162244 299864 ?      Sl   14:36   0:42 java -jar SolidityNode.jar -c config.conf
root       726  0.4  0.1  20176  3724 pts/0    Ss   15:22   0:00 bash
root       743  0.0  0.1  36068  3236 pts/0    R+   15:22   0:00 ps aux

```
If some of the node is not running, restart the container
```
docker restart trondev0
```
Be careful, because this will reset the data because the container will be deleted and rebuilt, similarly to what happens when you run `ganache-cli` for Ethereum.

If you prefer to have a stable private network, you can create a few local volumes and run the container telling it to use them:
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

To see the logs of the full node you can execute
```
docker exec -it trondev0 tail -f /tron/FullNode/logs/tron.log
```
and you can do the same for the solidity node
```
docker exec -it trondev0 tail -f /tron/SolidityNode/logs/tron.log
```