# Tron Quickstart (Docker image)

__The following is a Tron Quickstart (v2.0.0). The purpose of it is to set up a complete private network for Tron development.__

The image exposes:
* FullNode
* SolidityNode
* EventServer

## Usage

__Pull the image using docker:__
```
docker pull trontools/quickstart
```

__Run the container:__
```
docker run -it \
  -p 9090:9090 \
  --rm \
  --name tron \
  trontools/quickstart
```
Notice the `--rm` option automatically removes the container after it exits.

__If the port 9090 causes conflicts, change the external port as follows (showing 9091 as alternative):__

```
docker run -it \
  -p 9091:9090 \
  --rm \
  --name tron \
  trontools/quickstart
```

__Verify the image is running correctly:__
```
docker exec -it tron ps aux
```
You should see something like this:

```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  18372  3048 pts/0    Ss+  20:31   0:00 bash ./quickstart v2.0.0
root        12  0.0  0.1  48504  3768 pts/0    Sl+  20:31   0:00 redis-server *:6379
root        14  0.0  0.0  18372   276 pts/0    S+   20:31   0:00 bash ./quickstart v2.0.0
root        15 22.6 19.5 4211400 400288 pts/0  Sl+  20:31   0:21 java -jar FullNode.jar -c fullnode.conf --witness
root        17  0.0  0.0  18372   276 pts/0    S+   20:31   0:00 bash ./quickstart v2.0.0
root        18  0.0  0.0   4624   812 pts/0    S+   20:31   0:00 /bin/sh ./run_eventron.sh
root        23  1.4  3.2 940756 66860 pts/0    Sl+  20:31   0:01 node /tron/app
root        33  0.6  3.1 1243216 65212 pts/0   Sl+  20:31   0:00 ./eventron
root        34  115 14.4 4130488 294876 pts/0  Sl+  20:31   1:50 java -jar BlockParser.jar --Node-list 127.0.0.1 --intial-block 1 -end -1 --event-server http://127.0.0.1:8060 --secret-key TNSpckEZhGfZ4ryidHG2fYWMARLpZ6U139
root       227  0.3  0.1  18504  3328 pts/1    Ss   20:33   0:00 bash
root       240  0.0  0.1  34396  2784 pts/1    R+   20:33   0:00 ps aux
```

If redis-server, nodes, or the event server are not running, exit and run the container again.

To see the logs of the full node you can execute
```
docker exec -it tron tail -f /tron/FullNode/logs/tron.log
```

### TronBox 2.1+ configuration

Configure your `tronbox.js` file as:

```
module.exports = {
  networks: {
    development: {
      privateKey: 'da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0',
      fullNode: "http://127.0.0.1:9090",
      solidityNode: "http://127.0.0.1:9090",
      eventServer: "http://127.0.0.1:9090",
      network_id: "*"
    }
  }
};
```

### TronWeb configuration

Instantiate tronWeb as in the following example:
```
const TronWeb = require('tronweb')

const tronWeb = new TronWeb(
    "http://127.0.0.1:9090",
    "http://127.0.0.1:9090",
    "http://127.0.0.1:9090",
    'da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0',
)

```

### Testing

Tron Quickstart sets up accounts to be used for tests with TronBox 2.1+ (10 accounts by default). Once the transactions are mined, the final output is printed out:
```
Available Accounts
==================

(0) TJdDmJVYa9TcMJvCc9WsdaEXEYgeJrGVPq (100000 TRX)
(1) TNmLX3rJZNdq7kxgxs1y39FP3hp8LWHLUX (100000 TRX)
(2) TASrJ76QANNPRgdDHHikWWApQzxh3HPku4 (100000 TRX)
(3) TNkzaPqNipxKbU5ecUZz7P7UdejiE82zc7 (100000 TRX)
(4) TWCcS3cAVeNWhX1J6LHMEsEkWGq43t4EXc (100000 TRX)
(5) TW1QH88er9UqUKhoHLdm8dQTG2NsYU6C2h (100000 TRX)
(6) TKJu6vpKAknBwzovm5NiBZ1j69nWmeXGyw (100000 TRX)
(7) TQUddX2gBhGV7d33a2kZchVsPuWLdZBeXY (100000 TRX)
(8) TXjdePoR6ZRfBeiaZ9QoUyGwdHGhTPdy6x (100000 TRX)
(9) TGJnVM3TcvsKaDL3zpNm92gw2YHrPx8s3Y (100000 TRX)

Private Keys
==================

(0) 86134c8a51446c21b501f3a05844e18fdb72d3a5420867737c8640ce0ec656ca
(1) 57e04ac5484dd2c3d97b44c5e232b6203c2759642f38c5ea6787b0e4044de165
(2) 138a22c03039e688daa2b7c785d1e8d6b9375d4413e6ea82471b1e7a61701a9d
(3) e83a4958e81654efb162cef269e323ac501aa81d850ba9aed5a7d4f3c26d5a0a
(4) 05cdb18a4638d21d3f1f18e6bdb601a60b4debc85ee9bf8b385a2613693da24f
(5) b66225af9b24c9eb92ef65e3ff540c5c260de9fc8bb01a51fc44490bafe7ab3e
(6) 0b75b702316f1dcb2c7ca5aee9e1cd9bbdcf747e27fc417c324971caaf59772c
(7) 15e2547daf170c6f0e0dd0d64c35c1259206bc481a0c9d571bac0b1197f51d11
(8) 858c97998d9bebddc9320157e538d248dfcc64cd4c5c8ea97dfcb5d8396b37a0
(9) 32d2d45c05758f7de37a542798aac91315bd269565c99eafb33ebfb3a54ac046

HD Wallet
==================
Mnemonic:      treat nation math panel calm spy much obey moral hazard they sorry
Base HD Path:  m/44'/60'/0'/0/{account_index}

```

#### Quickstart options:
Use `-e` flag to pass environmental variables to the docker.
Example:
```
docker run -it \
  -p 9090:9090 \
  --rm \
  --name tron \
  -e "accounts=20" \
  trontools/quickstart
```

__List of options:__
* `accounts=12` sets the number of generated accounts
* `useDefaultPrivateKey=true` tells Quickstart to use the default account as `accounts[0]`
* `mnemonic=wrong bit chicken kitchen rat` uses a specified mnemonic
* `defaultBalance=100000` sets the initial balance for the generated accounts (in the example to 100,000 TRX)
* `seed=ushwe63hgeWUS` sets the seed to be used to generate the mnemonic (if none is passed)
* `hdPath=m/44'/60'/0'/0` sets a custom bit39 hdPath
* `formatJson=true` formats the output
* `allowSameTokenName=1`
* `allowDelegateResource=1`
* `allowTvmTransferTrc10=1`

Pre-approved options:
* `getMultiSignFee=1`
* `getUpdateAccountPermissionFee=1`
* `getTotalEnergyTargetLimit=1`

Example use of pre-approved:
```
docker run -it \
  -p 9090:9090 \
  --rm \
  --name tron \
  -e "getMultiSignFee=1" \
  trontools/quickstart
```

For a complete list of option proposals check out https://tronscan.org/#/sr/committee.

#### Available accounts

At any moment, to see the generated accounts, run
```
curl http://127.0.0.1:9090/admin/accounts
```

If you prefer to see the addresses in hex format you can run
```
curl http://127.0.0.1:9090/admin/accounts?format=hex
```
And if you like to see both formats, you can run
```
curl http://127.0.0.1:9090/admin/accounts?format=all
```


#### More accounts?

If your test requires additional accounts, use the following code to generate new addresses and retrieve them:

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

If you would like to use the same accounts each time, there are two ways to do that:
1. By passing a mnemonic to the docker
2. By using `accounts.json`

Example use of `accounts.json`:
```sh
if [[ ! -d "accounts-data" ]]; then mkdir accounts-data; fi

docker run -it -p 9090:9090 \
  --name tron \
  -v $PWD/accounts-data:/config \
  trontools/quickstart
```

If `accounts-data/accounts.json` exists, Tron Quickstart will use it each time it runs. If you need specific addresses, you can edit `accounts.json`, put your own private keys in the `privateKeys` array, and run the container.

#### Logging

By default, the proxy server returns a verbose log, containing the response of any command. If you prefer just to know what has been called, you can add the option `-e "quiet=true"`. For consistency there is also the option `-e "verbose=true"`. In case both `"quiet=true"` and  `"verbose=true"` options are passed, the `"verbose=true"` takes precedence, with `quiet` being ignored.

__verbose mode options:__

* `-e "showQueryString=true"`: shows the queryString of any command
* `-e "showBody=true"`: shows the parameter passed to a POST command


### Update environment variables

You can update environmental variables, at any time, with `curl` as follows:
```
curl http://127.0.0.1:9090/admin/set-env?showBody=true
```

### Interacting with the private network

The easiest way to interact with the private network is by using TronWeb from the container:
```
docker exec -it tron ./tronWeb
```
It opens a console with a `tronWeb` instance ready to use. Run any command — for example: `tronWeb.toHex("some")` — to verify that it works.

### What about RPC?

If you are running [Tron Wallet-cli](https://github.com/tronprotocol/wallet-cli) or any other tool which connects to the private network via RPC, you can just expose the ports . . . and voila!

```
docker run -it -p 50051:50051 -p 50052:50052 \
  --name tron \
  trontools/quickstart
```

### Known issues

__The "SERVER_BUSY" error__

Running TronBox can put a lot of stress on the local network. If the FullNode is busy, it returns the "SERVER_BUSY" error. If it does, just repeat your command.

### Latest version is `2.0.0`

To be updated, take a look at https://hub.docker.com/r/trontools/quickstart/tags/

You can see which version you currently running executing
```
docker ps
```
If you want also to know which version of JavaTron is used by Tron Quickstart, run
```
docker exec -it tron ./info
```
### Selected recent history

__2.0.0__
* Updated to JavaTron 3.5.0.1

__1.2.8__
* Supports pre-approved proposals, to be set using env variables (see above)
  * allowSameTokenName
  * allowDelegateResource
  * allowTvmTransferTrc10


__1.2.7__
* Updates to JavaTron v3.2.2.
* Supports events emitted by internal transactions.

__1.2.6__
* Uses JavaTron v3.2.1.2.
* Adds a script to have info about the current version of Tron Quickstart and JavaTron.

__1.2.5__
* Uses JavaTron v3.2.1.1.

__1.2.4__
* Allow to see the version of the current image from `docker ps`.

__1.2.3__
* Add CORS to any /admin routes that returns JSON objects.

__1.2.2__
* Introduce compatibility with JavaTron 3.2. It requires TronBox >= 2.2.1, because JavaTron 3.2 requires the new parameter
`origin_energy_limit`.
