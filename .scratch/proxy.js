const express = require('express');
const proxy = require('http-proxy-middleware');

function onProxyRes(proxyRes, req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,Content-Type,Accept')
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS')
  console.log(req.originalUrl)
}

function onError(err, req, res) {
  res.writeHead(500, {
    'Content-Type': 'text/plain'
  });
  res.end('Something went wrong. And we are reporting a custom error message.');
}

const conf = {
  changeOrigin: true,
  onProxyRes,
  onError
}

const app = express();

app.use('/wallet', proxy({
  ...conf,
  target: 'http://127.0.0.1:8190/wallet'
}));

app.use('/walletsolidity', proxy({
  ...conf,
  target: 'http://127.0.0.1:8191/walletsolidity'
}));

app.use('/walletextension', proxy({
  ...conf,
  target: 'http://127.0.0.1:8191/walletextension'
}));

app.use('/', proxy({
  ...conf,
  target: 'http://127.0.0.1:18891'
}));

app.listen(8090);

