const TronWeb = require('tronweb')
const network = require('../config').network

let instance

module.exports = function () {
  if (!instance) {
    instance = new TronWeb(
        network.fullNode,
        network.solidityNode,
        network.eventServer,
        network.privateKey
    )
  }
  return instance
}
