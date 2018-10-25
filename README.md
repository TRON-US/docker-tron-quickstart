# Tron Quickstart (Docker)
https://github.com/tronprotocol/docker-tron-quickstart

__A docker image exposing a full node, a solidity node and an event server, i.e., a complete private network for Tron developers.__

## Usage

Run it with:
```
docker run -it \
  -p 8091:8091 \
  -p 8092:8092 \
  -p 8090:8090 \
  --rm \
  --name tron \
  trontools/quickstart
```

Notice the `--rm` option which will delete the container when you stop it.

If you need to expose different ports to avoid conflicts, for example the ports 9090, 9091 and 9092, you can set up them when you run the container, like in this example:
```
docker run -it \
  -p 9090:8090 \
  -p 9091:8091 \
  -p 9092:8092 \
  --rm \
  --name tron \
  trontools/quickstart
```
To verify that the image is running correctly, execute
```
docker exec -it tron ps aux
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
If mongod, some of the nodes or the event server are not running, exit and run the container again.

Be careful, since we used the `--rm` option, restarting the container you will reset the data, similarly to what happens when you stop and run `ganache-cli` again in Truffle.

To see the logs of the full node you can execute
```
docker exec -it tron tail -f /tron/FullNode/logs/tron.log
```
and you can do the same for the solidity node
```
docker exec -it tron tail -f /tron/SolidityNode/logs/tron.log
```

### Stable private networks

If you like to have a stable private network, you must set local volumes and run the container telling it to use them, like in the following example:
```sh
(
# creating the local folders

mkdir tron-data
cd tron-data

mkdir data          # Mongodb and Proxy app data
mkdir -p fn/logs    # Logs of the full node
mkdir -p fn/output  # Data full node
mkdir -p sn/logs    # Logs solidity node
mkdir -p sn/output  # Data solidity node

# running the container using the local volumes

docker run -it -p 8091:8091 -p 8092:8092 -p 8090:8090 \
  --name tron \
  -v $PWD/data:/data \
  -v $PWD/fn/logs:/tron/FullNode/logs \
  -v $PWD/fn/output:/tron/FullNode/output-directory \
  -v $PWD/sn/logs:/tron/SolidityNode/logs \
  -v $PWD/sn/output:/tron/SolidityNode/output-directory \
  trontools/quickstart
)
```

### Usage in TronBox 2.1+

Config your `tronbox.js` file as:
```
module.exports = {
  networks: {
    development: {
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

### Usage in TronWeb

Instantiate tronWeb as in the following example:
```
const TronWeb = require('tronweb')

const tronWeb = new TronWeb(
    "http://127.0.0.1:8090",
    "http://127.0.0.1:8091",
    "http://127.0.0.1:8092",
    'da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0',
)

```


### Testing

From version 1.0.0, Tron Quickstart sets up a certain number of accounts to be used for tests with TronBox 2.1+.
By default, it generates 10 accounts, but you can set more accounts setting en environment variable running the container. For example, to generate 20 accounts:
```
docker run -it \
  -p 8091:8091 \
  -p 8092:8092 \
  -p 8090:8090 \
  -e "accounts=20" \
  --name tron \
  trontools/quickstart
```
The generator waits until the nodes are ready, generates the accounts and wait until the transactions are mined. The final output is something like:
```
Available Accounts
==================
(0) TVbCeZECnkPJ4kvAAcHTBu6Q79QwEmndSE (10000 TRX)
(1) TDAf3Kn9BqdhGxApY6bQcbWgUbQ2N6hc1t (10000 TRX)
(2) TJVZmWvuXeydkTQxFezvXzKu9P3KywyP33 (10000 TRX)
(3) TRKCKCMxS2uuSEnZRh5gwKwmNQ7gKmSATv (10000 TRX)
(4) TZ2Pmn147pXMxZ3kVTziF7yQtcUvzmwZ4z (10000 TRX)
(5) TQEr9VppYnuWtE59pm1yVD3D7ojZUzHYC2 (10000 TRX)
(6) TJXzNLy4prmuodubYYmrKLF8uEmfU5Zeou (10000 TRX)
(7) TF5xFUrJYiinXTPY3RwTjwknR6QLDyevdD (10000 TRX)
(8) TPLuoh7nfDuEXChc3xVUopvWPiJq26Vi7V (10000 TRX)
(9) TSH8CpoQpTHpzVYNKarUP6dey79W5VJSs6 (10000 TRX)

Private Keys
==================
(0) 3E67AB8BC1455E07EFB5B810750CA281ED417290DC7579C8090DBBCF9B4F958A
(1) 72C0F16C69951ECAE37A781AABE69F4E6FA6C66CDC183765EFECAD0B2FE5AD39
(2) 93E06D087C0E9E3F5FD413597B0C14DDBE17FE51BA40A62AAFB98D6FDF0AF146
(3) 582C0624A030DEEBB531B8FAE8CE7FFF1530CA735FAE32B0349C580DB7F5B5A1
(4) DF4287D704E47312FE6B51E8EDF225F0E9FB8447B14516938E5ED2402380F56F
(5) DBC58F94E3BA5FEF923C0B2F89BBE290E35E9661AA0F979BD755C1EC7D895E70
(6) 9B2A400EDDCE6CBE60CD3CFBC5ED2903C42C5B0AFF5D0E701A403C3714AC7C21
(7) B1DE2461BD8E5C3B92E0ACE075B02DBE770A62E4B1C94307E7E4D46347A68B24
(8) CE6371A1662E31449EE2E79977C211AB595DD802D1AF0776456CC3797DCEC4FE
(9) CD538105279011140F85853EEC165F0ADA3BC965849DDACB03EA734AD958B1F6

```

At any moment, to see the generated accounts, run
```
curl http://127.0.0.1:8090/admin/accounts
```

If you like to use all the time the same accounts, you can set a local volume and let docker using it, like in the following example:
```sh
mkdir app-data

docker run -it -p 8091:8091 -p 8092:8092 -p 8090:8090 \
  --name tron \
  -v $PWD/app-data:/data/app \
  trontools/quickstart
```
After the first time, running again the container, it will use the file `app-data/accounts.json` for the accounts. If you need specific addresses, you can also edit `accounts.json`, put your own data and run again the container.

If you need to use as accounts[0] the default account in `tronbox.js`, add the option `-e useZion=true` when you run the image. For example:
```
docker run -it \
  -p 8091:8091 \
  -p 8092:8092 \
  -p 8090:8090 \
  -e "useZion=true" \
  --name tron \
  trontools/quickstart
```
By default, the proxy server returns a verbose log, containing the response of any command. If you prefer just to know what has been called, you can add the option `-e "quiet=true"`. For consistency there is also the option `-e "verbose=true"` which is prioritary, i.e., `quiet` is ignored if `verbose` is specified.



### Interacting with the private network

The easiest way to interact with the private network is using TronWeb.
In the folder `/app` there is a `tronWeb.js` file not used by the image, but useful for runtime debugging.

First, if you haven't done yet, clone this repo and install the dependences:
```
git clone https://github.com/tronprotocol/docker-tron-quickstart.git
cd docker-tron-quickstart
(cd app && npm i)
```
Now you can execute
```
node app/tronWeb
```
which will open a console with a `tronWeb` instance ready to use.

### What about RPC?

If you are running [Tron Wallet-cli](https://github.com/tronprotocol/wallet-cli) or any other tool which connects to the private network via RPC, you can just expose the ports . . . and voila!

```
docker run -it -p 50051:50051 -p 50052:50052 \
  --name tron \
  trontools/quickstart
```

### Known issues

__The "SERVER_BUSY" error__

Sometimes, for example running tests with TronBox, we ask the node to performe a lot of operatios. This can cause that the full node is busy and returns that error. If so, just repeat your command.

### Not good for main network

Unfortunately, you cannot use this image to create a node in the main Tron network because it uses a version of java-tron who is not the one required for a standard full node.
