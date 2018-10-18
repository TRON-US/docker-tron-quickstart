var express = require('express');
var proxy = require('http-proxy-middleware');
var morgan = require('morgan');
var chalk = require('chalk')

process.on('uncaughtException', function (error) {
  console.error(error.message)
})

var only = who => {
  return function (tokens, req, res) {
    return chalk.bold([
      tokens.method(req, res),
      `[${who}]${tokens.url(req, res)}`,
      tokens.status(req, res),
      tokens.res(req, res, 'content-length'), '-',
      tokens['response-time'](req, res), 'ms'
    ].join(' '))
  }
}

const setHeaders = activeLog => {

  return function onProxyRes(proxyRes, req, res) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,Content-Type,Accept')
    res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS')

    if (activeLog) {
      var oldWrite = res.write,
          oldEnd = res.end;

      var chunks = [];

      res.write = function (chunk) {
        chunks.push(new Buffer(chunk));

        oldWrite.apply(res, arguments);
      };

      res.end = function (chunk) {
        if (chunk)
          chunks.push(new Buffer(chunk));

        var body = Buffer.concat(chunks).toString('utf8');
        console.log(req.path, body);

        oldEnd.apply(res, arguments);
      };
    }
  }
}

function onError(err, req, res) {
  res.writeHead(500, {
    'Content-Type': 'text/plain'
  });
  res.end(err);
}

const setApp = (name, port0, port, activeLog) => {
  var app = express();
  app.use(morgan(only(name)))
  app.get('/favicon.ico', function (req, res) {
    res.send('');
  });
  app.use('/', proxy({
    changeOrigin: true,
    onProxyRes: setHeaders(activeLog),
    onError,
    target: `http://127.0.0.1:${port0}`
  }));
  app.listen(port);

}

const verbose = !process.env.quiet || process.env.verbose === 'verbose'

setApp('full-node', 18190, 8090, verbose);
setApp('solidity-node', 18191, 8091, verbose);
setApp('event-server', 18891, 8092, verbose);
