const TronWeb = require('tronweb')

let fullNode = 'http://127.0.0.1:8090'
let solidityNode = 'http://127.0.0.1:8091'
let eventServer = 'http://127.0.0.1:8092'
let defaultPrivakeKey = 'da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0'

global.tronWeb = new TronWeb(
  fullNode,
  solidityNode,
  eventServer,
  defaultPrivakeKey
)

require('repl').start({})


