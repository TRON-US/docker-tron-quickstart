const TronWeb = require('tronweb')
const conf = require('../config')

let instance

module.exports = function () {
  if (!instance) {
    instance = new TronWeb(
        conf.fullNode,
        conf.solidityNode,
        conf.eventServer,
        conf.privateKey
    )
  }
  return instance;
}
