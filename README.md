# Docker Trondev

A container exposing a full node, a solidity node and an event server.

To run it
```
docker run -d -p 8091:8091 -p 8092:8092 -p 8090:8090 --rm sullof/trondev
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


