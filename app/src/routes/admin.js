const express = require('express')
const router = express.Router()
const accountsGeneration = require('../utils/accountsGeneration')
// const jsonParser = require('body-parser').json()

let testingAccounts;
let formattedTestingAccounts;

router.get('/accounts', function (req, res) {
  res.set('Content-Type', 'text/plain').send(formattedTestingAccounts);
});

router.get('/accounts-json', function (req, res) {
  res.json(testingAccounts);
});

router.get('/accounts-generation', async function (req, res) {

  const accounts = await accountsGeneration(
      process.env.accounts
          ? parseInt(process.env.accounts, 10)
          : 10
  )

  formattedTestingAccounts = 'Available Accounts\n==================\n\n'
  for (let i = 0; i < accounts.length; i++) {
    formattedTestingAccounts += `(${i}) ${accounts[i].address.base58} (~10000 TRX)\n`
  }
  formattedTestingAccounts += '\nPrivate Keys\n==================\n\n'
  for (let i = 0; i < accounts.length; i++) {
    formattedTestingAccounts += `(${i}) ${accounts[i].privateKey}\n`
  }

  console.log('\n', formattedTestingAccounts)

  testingAccounts = accounts;
  res.send('');
});


module.exports = router
