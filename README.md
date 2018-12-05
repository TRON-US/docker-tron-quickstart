# Tron Quickstart (Docker)
https://github.com/tronprotocol/docker-tron-quickstart

__A docker image exposing a full node, a solidity node and an event server, i.e., a complete private network for Tron developers.__

## Usage

If you are using TronBox 2.1.9+ and are setting just a `fullHost` in `tronbox.js` run

```
docker run -it \
  -p 9090:9090 \
  --rm \
  --name tron \
  trontools/quickstart
```
Notice the `--rm` option which will delete the container when you stop it.

With TronBox < 2.1.9, run instead:
```
docker run -it \
  -p 8091:8091 \
  -p 8092:8092 \
  -p 8090:8090 \
  --rm \
  --name tron \
  trontools/quickstart
```

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

In TronBox 2.1.9+ you can just set a `fullHost` like in:
```
module.exports = {
  networks: {
    development: {
      privateKey: 'da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0',
      consume_user_resource_percent: 30,
      fee_limit: 100000000,
      fullHost: "http://127.0.0.1:9090",
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
By default, it generates 10 accounts and waits until the transactions are mined. The final output is something like:
```
Available Accounts
==================

(0) THonCrSv2bkzXu4Azrc6L949YJHqRs4XYN (10000 TRX)
(1) TAWCqmAvjs1GdB39AgVZDo7sjuSCTQAg4T (10000 TRX)
(2) TMG1rifQBAABz4qKxZr4RqA8Zr4eCwgQvy (10000 TRX)
(3) TA76Y4dnKzD8BmmBaLBxtV2YqJHo4Jc7zZ (10000 TRX)
(4) TBhjRJc3btGMotw3vz7VpDcrfYs98DdQNA (10000 TRX)
(5) TQP9CT7w8mr9mmjhNyuaZpo3BJizoC6sM5 (10000 TRX)
(6) TBKaAgZfcbF9q1496uUjacEjBPLqb7djc4 (10000 TRX)
(7) THo2uD5CamAbhHjP6QTyj7RxPwTkbk6vse (10000 TRX)
(8) TWmBP7dTWQVcovrqZaaHerJWirdh7B6NJa (10000 TRX)
(9) TRBrPNWAkKGoXjYHLWdrvaqF49G2MYukp6 (10000 TRX)

Private Keys
==================

(0) 84d9f2d42a52839ca2ed6992af7f2e9617263a3eb9a358f25ccddf704f7826a4
(1) 086fe9467b9c2753eedf22abd88a6651de3d2fcdfbc0f1a8ce59829719a6031a
(2) 57de89ab1502d8d6f08a63342e7bf2e9d361ed0a0d6fe57733aba6010873839b
(3) 7605e63fc9c738268e86396d242389df2cdb2a3fbe17145b43fc238ef5cb4ac2
(4) 1f8fe4c1d38814c1868c5d76dda2afd7b7715c8a8382a458004502a6a0dd39d7
(5) a012ffd67845b0e189d627082d40d32c98cc4c5221a49f611f22f75a94ff1254
(6) 92294e76ba71dbb6e43a701596253857d6481867f8101f99b72125359d3ae28d
(7) 89e73d62ad9e74d6d725d020cd037ecbb590a7be52091e830f55717c98181590
(8) f3f38eacb1e32cb08642097ec0763e43d99aa7c5385dd4e3a85902c50ba66998
(9) 0e0ac6676ca312b88939584bebc0f279a3c13c9236846b95eaa9df8588538ad5

HD Wallet
==================
Mnemonic:      wage symptom exchange mask elder above wool later engine slot place rocket
Base HD Path:  m/44'/60'/0'/0//{account_index}

```

#### Available options:

To set an option set an env variable, like for example `-e "accounts=20"` to set 20 default accounts.

List of options
* `accounts=12` sets the number of generated accounts
* `useDefaultPrivateKey=true` tells Quickstart to use the default account as `accounts[0]`
* `mnemonic=wrong bit chicken kitchen rat` uses a specified mnemonic
* `defaultBalance=100000` sets the initial balance for the generated accounts (in the example to 100,000 TRX)
* `seed=ushwe63hgeWUS` sets the seed to be used to generate the mnemonic (if none is passed)
* `hdPath=m/44'/60'/0'/0` sets a custom bit39 hdPath
* `formatJson=true` formats the output

#### Available accounts

At any moment, to see the generated accounts, run
```
curl http://127.0.0.1:8090/admin/accounts
```

If you prefer to see the addresses in hex format you can run
```
curl http://127.0.0.1:8090/admin/accounts?format=hex
```
And if you like to see both formats, you can run
```
curl http://127.0.0.1:8090/admin/accounts?format=all
```


#### More accounts?

Sometimes you must have new accounts any times that you run a test. For example, if you are testing a native token, after that you have created it for a certain account, you can't delete it. So, next time you repeat the test, the test will fail.

The obvious solution is to stop the container and run it again. Starting from Tron Quickstart 1.1.5 there is a better solution. You can use the following code to generate more addresses and retrieve them:

```js
async function newTestAccounts(amount) => {
    return await tronWeb.fullNode.request('/admin/temporary-accounts-generation?accounts=' + amount);
}

async function getTestAccounts() => {
    const accounts = {
        b58: [],
        hex: [],
        pks: []
    }
    const accountsJson = await tronWeb.fullNode.request('/admin/accounts-json');
    accounts.pks = accountsJson.more[accountsJson.more.length - 1].privateKeys
    for (let i = 0; i < accounts.pks.length; i++) {
        let addr = tronWeb.address.fromPrivateKey(accounts.pks[i]);
        accounts.b58.push(addr);
        accounts.hex.push(tronWeb.address.toHex(addr));
    }
    return accounts;
}
```


#### Persistency

If you like to use all the time the same accounts you can pass a mnemonic or let docker using a local `accounts.json` file, like in the following example:
```sh
if [[ ! -d "accounts-data" ]]; then mkdir accounts-data; fi

docker run -it -p 8091:8091 -p 8092:8092 -p 8090:8090 \
  --name tron \
  -v $PWD/accounts-data:/config \
  trontools/quickstart
```
In the example above, after the first time, running again the container, Tron Quickstart will use the file `accounts-data/accounts.json` for the accounts. If you need specific addresses, you can edit `accounts.json`, put your own private keys in the `privateKeys` array, and run again the container.

#### Logging

By default, the proxy server returns a verbose log, containing the response of any command. If you prefer just to know what has been called, you can add the option `-e "quiet=true"`. For consistency there is also the option `-e "verbose=true"` which is prioritary, i.e., `quiet` is ignored if `verbose` is specified.

In verbose mode, you have options for more details:

To see the queryString of any command, use the options `-e "showQueryString=true"`.

To see the parameter passed to a POST command, use the options `-e "showBody=true"`.


### Update environment variables

At any moment you can update env variables running a command like:
```
curl http://127.0.0.1:8090/admin/set-env?showBody=true
```

### Interacting with the private network

The easiest way to interact with the private network is using TronWeb from inside the container:
```
docker exec -it tron ./tronWeb
```
It will open a console with a `tronWeb` instance ready to use. Run any command — for example: `tronWeb.toHex("some")` — to verify that it works.

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

### Latest version is `1.2.3`

To be updated, take a look at https://hub.docker.com/r/trontools/quickstart/tags/

To see which version are you currently running, execute:
```
docker exec -it tron node app/version
```

### History

__1.2.3__
Adds CORS to any /admin routes that returns JSON objects.

__1.2.2__
Introduce compatibility with java-tron 3.2. It requires TronBox >= 2.2.1, because java-tron 3.2 requires the new parameter
`origin_energy_limit`. 


