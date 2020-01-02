const _ = require('lodash')
const fs = require('fs-extra')
const path = require('path')
const chalk = require('chalk')
const wait = require('./wait')
const deriveAccountsFromSeedAndOrMnemonic = require('./deriveAccountsFromSeedAndOrMnemonic')
const config = require('../config')

const isDev = process.platform === 'darwin'

const tronWebBuilder = require('../utils/tronWebBuilder')
let tronWeb
let count = 1
let done = false
let defSet = false
let printed = false

function waiting() {
  const env = config.getEnv()
  if (!printed) {
    console.log(chalk.gray(`Waiting when nodes are ready to generate ${env.accounts} accounts...`))
    printed = true
  }
  if (!done) {
    console.log(chalk.gray(`(${count++}) Waiting for sync...`))
    setTimeout(waiting, 5000)
  }
}

async function accountsGeneration(options) {

  const env = config.getEnv()

  if (!options) {
    options = env
  } else {
    options = _.defaults(options, env)
  }

  if (!defSet) {
    tronWeb = tronWebBuilder()
    tronWeb.setDefaultBlock('latest')
    setTimeout(waiting, 1000)
    defSet = true
  }

  if (!await tronWeb.fullNode.isConnected()) {
    await wait(1)
    return await accountsGeneration()
  }

  done = true
  let accounts

  const tmpDir = '/config'
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

  if (!accounts || options.addAccounts) {
    const newAccounts = await deriveAccountsFromSeedAndOrMnemonic(options)

    if (!accounts) {
      accounts = newAccounts
      accounts.more = []
    } else {
      accounts.more.push(newAccounts)
    }
    if (!isDev) {
      fs.ensureDirSync(tmpDir)
      fs.writeFileSync(path.join(tmpDir, 'accounts.json'), JSON.stringify(accounts, null, 2))
    }
  }

  return Promise.resolve(accounts)
}


module.exports = accountsGeneration
