const sleep = require('sleep')
const express = require('express')
const router = express.Router()
const chalk = require('chalk')
const accountsGeneration = require('../utils/accountsGeneration')

const tronWebBuilder = require('../utils/tronWebBuilder')

let testingAccounts;
let formattedTestingAccounts;


async function getBalances() {
  const tronWeb = tronWebBuilder()

  const balances = []
  for (let i = 0; i < testingAccounts.privateKeys.length; i++) {
    let address = tronWeb.address.fromPrivateKey(testingAccounts.privateKeys[i])
    balances[i] = await tronWeb.trx.getBalance(address)
  }
  return Promise.resolve(balances)
}

async function verifyAccountsBalance() {
  const tronWeb = tronWebBuilder()

  console.log(chalk.gray("...\nLoading the accounts and waiting for the node to mine the transactions..."))

  const amount = process.env.defaultBalance || 10000
  const balances = []
  let ready = 0
  const trxSent = []
  let count = 1
  let privateKeys = testingAccounts.privateKeys

  while (true) {
    console.log(chalk.gray(`(${count++}) Waiting for receipts...`))
    for (let i = 0; i < privateKeys.length; i++) {
      let address = tronWeb.address.fromPrivateKey(privateKeys[i])
      if (privateKeys[i] !== tronWeb.defaultPrivateKey && !trxSent[i]) {
        let result = await tronWeb.trx.sendTransaction(address, tronWeb.toSun(amount))
        if (result.result) {
          console.log(chalk.gray(`Sending ${amount} TRX to ${address}`))
          trxSent[i] = true
        }
      } else if (!balances[i]) {
        let balance = await tronWeb.trx.getBalance(address)
        if (balance > 0) {
          balances[i] = balance
          ready++
        }
      }
    }
    if (ready < privateKeys.length)
      sleep.sleep(3);
    else break;
  }
  console.log(chalk.gray('Done.\n'));
  return Promise.resolve(balances);
}

async function formatAccounts(balances) {
  const tronWeb = tronWebBuilder()

  let privateKeys = testingAccounts.privateKeys

  formattedTestingAccounts = 'Available Accounts\n==================\n\n'
  for (let i = 0; i < privateKeys.length; i++) {
    let address = tronWeb.address.fromPrivateKey(privateKeys[i])
    formattedTestingAccounts += `(${i}) ${address} (${tronWeb.fromSun(balances[i])} TRX)\n`
  }
  formattedTestingAccounts += '\nPrivate Keys\n==================\n\n'
  for (let i = 0; i < privateKeys.length; i++) {
    formattedTestingAccounts += `(${i}) ${privateKeys[i]}\n`
  }
  formattedTestingAccounts += '\nHD Wallet\n' +
      '==================\n' +
      'Mnemonic:      ' + testingAccounts.mnemonic + '\n' +
      'Base HD Path:  ' + testingAccounts.hdPath + '{account_index}\n'

  return Promise.resolve()
}


router.get('/accounts', async function (req, res) {
  console.log('\n\n', chalk.green('(tools)'), chalk.bold('/admin/accounts'));
  const balances = await getBalances()
  await formatAccounts(balances)
  res.set('Content-Type', 'text/plain').send(formattedTestingAccounts);
});

router.get('/accounts-json', function (req, res) {
  console.log('\n\n', chalk.green('(tools)'), chalk.bold('/admin/accounts-json'));
  res.json(testingAccounts);
});

router.get('/accounts-generation', async function (req, res) {
  console.log('\n\n', chalk.green('(tools)'), chalk.bold('/admin/accounts-generation'));

  testingAccounts = await accountsGeneration()
  const balances = await verifyAccountsBalance()
  // console.log('balances', balances)
  await formatAccounts(balances);
  console.log(formattedTestingAccounts);
  res.send();
});

router.get('/', function (req, res) {
  res.send('Welcome to Tron Quickstart')
})


module.exports = router
