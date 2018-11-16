var express = require('express');
var proxy = require('http-proxy-middleware');
var morgan = require('morgan');
var chalk = require('chalk');
var _ = require('lodash');
var bodyParser = require('body-parser')

const admin = require('./src/routes/admin')

process.on('uncaughtException', function (error) {
  console.error(error.message)
})

var only = () => {
  return function (tokens, req, res) {
    const status = tokens.status(req, res)
    const color = status < 400 ? 'green' : 'red'
    return chalk[color]([' ',
      tokens.method(req, res),
      tokens.url(req, res),
      status,
      tokens.res(req, res, 'content-length'), '-',
      tokens['response-time'](req, res), 'ms'
    ].join(' '))
  }
}

const setHeaders = (who, verbose) => {

  return function onProxyRes(proxyRes, req, res) {

    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,Content-Type,Accept')
    res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS')

    if (verbose) {
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
        console.log('\n\n', chalk.cyan(`(${who})`), chalk.bold(req.path), '\n', body.replace(/\n+$/,''));

        oldEnd.apply(res, arguments);
      };
    }
  }
}

function onProxyReq(proxyReq, req, res) {
  if (process.env.showQueryString && _.keys(req.query).length) {
    console.log(chalk.gray(' QueryString:'),chalk.cyan(JSON.stringify(req.query)))
  }
  if (process.env.showBody && req.method == "POST" && _.keys(req.body).length) {
    let bodyData = JSON.stringify(req.body);
    console.log(chalk.gray(' Body:'),chalk.cyan(bodyData))
    proxyReq.setHeader('Content-Type','application/json');
    proxyReq.setHeader('Content-Length', Buffer.byteLength(bodyData));
    proxyReq.write(bodyData);
  }
}

function onError(err, req, res) {
  res.writeHead(500, {
    'Content-Type': 'text/plain'
  });
  res.end(err);
}

const setApp = (name, port0, port, verbose) => {
  var app = express();
  app.use(morgan(only()))
  app.use(bodyParser.json())
  app.use('/favicon.ico', function (req, res) {
    res.send('');
  });
  if (name === 'full-node') {
    app.use('/admin', admin);
  }
  app.use('/', proxy({
    changeOrigin: true,
    onProxyReq,
    onProxyRes: setHeaders(name, verbose),
    onError,
    target: `http://127.0.0.1:${port0}`
  }));
  app.listen(port);

}


const verbose = !process.env.quiet || process.env.verbose === 'verbose'

setApp('full-node', 18190, 8090, verbose);
setApp('solidity-node', 18191, 8091, verbose);
setApp('event-server', 18891, 8092, verbose);

const n = "\n"

console.log(n, 'Full Node listening on', chalk.bold('http://127.0.0.1:8090'),
    n, 'Solidity Node listening on', chalk.bold('http://127.0.0.1:8091'),
    n, 'Event Server listening on', chalk.bold('http://127.0.0.1:8092'), n)

