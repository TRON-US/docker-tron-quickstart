const express = require('express')
const router = express.Router()
const accountsGeneration = require('../utils/accountsGeneration')
// const jsonParser = require('body-parser').json()

const tronWebBuilder = require('../utils/tronWebBuilder')

let testingAccounts;
let formattedTestingAccounts;

function formatAccounts() {
  const tronWeb = tronWebBuilder()
  formattedTestingAccounts = 'Available Accounts\n==================\n\n'
  for (let i = 0; i < testingAccounts.length; i++) {
    formattedTestingAccounts += `(${i}) ${tronWeb.address.fromPrivateKey(testingAccounts[i])} (~10000 TRX)\n`
  }
  formattedTestingAccounts += '\nPrivate Keys\n==================\n\n'
  for (let i = 0; i < testingAccounts.length; i++) {
    formattedTestingAccounts += `(${i}) ${testingAccounts[i]}\n`
  }
  console.log('\n', formattedTestingAccounts)
}


router.get('/accounts', function (req, res) {
  res.set('Content-Type', 'text/plain').send(formattedTestingAccounts);
});

router.get('/accounts-json', function (req, res) {
  res.json(testingAccounts);
});

router.get('/accounts-generation', async function (req, res) {

  testingAccounts = await accountsGeneration(
      process.env.accounts
          ? parseInt(process.env.accounts, 10)
          : 10
  )

  formatAccounts();

  res.send('');
});


module.exports = router
