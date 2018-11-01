const sleep = require('sleep')
const _ = require('lodash')
const fs = require('fs-extra')
const path = require('path')
const chalk = require('chalk')
const deriveAccountsFromSeedAndOrMnemonic = require('./deriveAccountsFromSeedAndOrMnemonic')

const isDev = process.platform === 'darwin'

const tronWebBuilder = require('../utils/tronWebBuilder')
let tronWeb
let count = 1
let done = false
let defSet = false
let printed = false
let amount

function waiting() {
  if (!printed) {
    console.log(`Waiting when nodes are ready to generate ${amount} accounts...`)
    printed = true
  }
  if (!done) {
    console.log(chalk.gray(`(${count++}) Waiting for sync...`))
    setTimeout(waiting, 5000)
  }
}

async function accountsGeneration() {

  if (!defSet) {
    tronWeb = tronWebBuilder()
    tronWeb.setDefaultBlock('latest');
    setTimeout(waiting, 1000)
    defSet = true
  }

  if (!await tronWeb.fullNode.isConnected()) {
    sleep.sleep(1)
    return await accountsGeneration(amount)
  }

  done = true;
  let accounts;

  const tmpDir = '/data/app'
  const jsonPath = path.join(tmpDir, 'accounts.json')

  if (!isDev && fs.existsSync(jsonPath)) {
    accounts = JSON.parse(fs.readFileSync(jsonPath, 'utf-8'))
    if (Array.isArray(accounts)) {
      // for retro-compatibility
      accounts = {
        privateKeys: accounts
      }
    } else if (typeof accounts !== 'object') {
      // wrong format
      accounts = null
    }
  }

  if (!accounts) {
    accounts = await deriveAccountsFromSeedAndOrMnemonic(process.env)
    if (process.env.useDefaultPrivateKey) {
      accounts.privateKeys = [tronWeb.defaultPrivateKey].concat(accounts.accounts)
    }
    if (!isDev) {
      fs.ensureDirSync(tmpDir)
      fs.writeFileSync(path.join(tmpDir, 'accounts.json'), JSON.stringify(accounts, null, 2))
    }
  }

  return Promise.resolve(accounts)
}


module.exports = accountsGeneration
