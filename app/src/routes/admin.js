const express = require('express')
const router = express.Router()
const chalk = require('chalk')
const accountsGeneration = require('../utils/accountsGeneration')
// const jsonParser = require('body-parser').json()

const tronWebBuilder = require('../utils/tronWebBuilder')

let testingAccounts;
let formattedTestingAccounts;

async function formatAccounts() {
  const tronWeb = tronWebBuilder()

  formattedTestingAccounts = 'Available Accounts\n==================\n\n'
  for (let i = 0; i < testingAccounts.length; i++) {

    let address = tronWeb.address.fromPrivateKey(testingAccounts[i])
    let balance = await tronWeb.trx.getBalance(address)

    formattedTestingAccounts += `(${i}) ${address} (${tronWeb.fromSun(balance)} TRX)\n`
  }
  formattedTestingAccounts += '\nPrivate Keys\n==================\n\n'
  for (let i = 0; i < testingAccounts.length; i++) {
    formattedTestingAccounts += `(${i}) ${testingAccounts[i]}\n`
  }
}


router.get('/accounts', async function (req, res) {
  console.log('\n\n', chalk.green('(tools)'), chalk.bold('/admin/accounts'));
  await formatAccounts()
  res.set('Content-Type', 'text/plain').send(formattedTestingAccounts);
});

router.get('/accounts-json', function (req, res) {
  console.log('\n\n', chalk.green('(tools)'), chalk.bold('/admin/accounts-json'));
  res.json(testingAccounts);
});

router.get('/accounts-generation', async function (req, res) {
  console.log('\n\n', chalk.green('(tools)'), chalk.bold('/admin/accounts-generation'));

  testingAccounts = await accountsGeneration(
      process.env.accounts
          ? parseInt(process.env.accounts, 10)
          : 10
  )

  await formatAccounts();

  res.send(formattedTestingAccounts);
});


module.exports = router
