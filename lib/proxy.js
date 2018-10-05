var express = require('express');
var proxy = require('http-proxy-middleware');

function onProxyRes(proxyRes, req, res) {
  res.setHeader('Access-Control-Allow-Origin','*');
  res.setHeader('Access-Control-Allow-Headers','X-Requested-With,Content-Type,Accept')
  res.setHeader('Access-Control-Allow-Methods','GET,POST,PUT,DELETE,OPTIONS')
  console.log(req.originalUrl)
}

function onError(err, req, res) {
  res.writeHead(500, {
    'Content-Type': 'text/plain'
  });
  res.end('Something went wrong. And we are reporting a custom error message.');
}

var fullnode = express();
fullnode.use('/', proxy({
  target: 'http://127.0.0.1:16667',
  changeOrigin: true,
  onProxyRes,
  onError
}));
fullnode.listen(8090);

var soliditynode = express();
soliditynode.use('/', proxy({
  target: 'http://127.0.0.1:16668',
  changeOrigin: true,
  onProxyRes,
  onError
}));
soliditynode.listen(8091);

var eventserver = express();
eventserver.use('/', proxy({
  target: 'http://127.0.0.1:18891',
  changeOrigin: true,
  onProxyRes,
  onError
}));
eventserver.listen(8092);

