const TronWeb = require('tronweb')
const network = require('../config').network

let instance

module.exports = function () {
  if (!instance) {
    instance = new TronWeb(network)
  }
  return instance
}
