/* eslint-disable */

// thanks to Trufflesuite/Ganache-core
// https://github.com/trufflesuite/ganache-core/blob/develop/lib/statemanager.js

const _ = require('lodash')
const utils = require("ethereumjs-util")
const seedrandom = require("seedrandom")
const bip39 = require("bip39")
const hdkey = require("ethereumjs-wallet/hdkey")
const tronWebBuilder = require('../utils/tronWebBuilder')
const config = require('../config')

function toHex(val) {
  if (typeof val === "string") {
    if (val.indexOf("0x") === 0) {
      return val.trim()
    } else {
      val = new utils.BN(val)
    }
  }

  if (typeof val === "boolean") {
    val = val ? 1 : 0
  }

  if (typeof val === "number") {
    val = utils.intToHex(val)
  }

  // Support Buffer, BigInteger and BN library
  // Hint: BN is used in ethereumjs
  if (typeof val === "object") {
    val = val.toString("hex")
  }

  return utils.addHexPrefix(val)
}


function randomBytes(length, rng) {
  let buf = []

  for (let i = 0; i < length; i++) {
    buf.push(rng() * 255)
  }

  return Buffer.from(buf)
}

function randomAlphaNumericString(length, rng) {
  const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

  let text = ""

  for (let i = 0; i < length; i++) {
    text += alphabet.charAt(Math.floor((rng || Math.random)() * alphabet.length))
  }

  return text
}

async function deriveAccountsFromSeedAndOrMnemonic(options) {

  const env = config.getEnv()

  if (!options) {
    options = env
  } else {
    options = _.defaults(options, env)
  }

  if (options.addAccounts) {
    for (let key of 'mnemonic,hdPath,seed,useDefaultPrivateKey'.split(',')) {
      delete options[key]
    }
  }

  const tronWeb = tronWebBuilder()

  const total_accounts = options.accounts

  const hdPath = options.hdPath || "m/44'/195'/0'/0/"

  let seed = options.seed
  let mnemonic = options.mnemonic

  if (!mnemonic) {
    seed = seed || randomAlphaNumericString(10, seedrandom())
    mnemonic = options.mnemonic || bip39.entropyToMnemonic(randomBytes(16, seedrandom(seed)).toString("hex"))
  }

  const wallet = hdkey.fromMasterSeed(bip39.mnemonicToSeed(mnemonic))

  const privateKeys = []

  for (let i = 0; i < total_accounts; i++) {
    let acct = wallet.derivePath(hdPath + i)
    let privateKey = acct.getWallet().getPrivateKey().toString('hex')
    if (!i && options.useDefaultPrivateKey) {
      privateKey = tronWeb.defaultPrivateKey
    }
    privateKeys.push(privateKey)
  }

  return Promise.resolve({
    hdPath,
    mnemonic,
    usingDefaultPrivateKey: options.useDefaultPrivateKey,
    privateKeys
  })
}


module.exports = deriveAccountsFromSeedAndOrMnemonic
