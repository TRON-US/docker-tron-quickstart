const sleep = require('sleep')
const fs = require('fs-extra')
const path = require('path')

const tronWebBuilder = require('../utils/tronWebBuilder')

let count = 1
let done = false
let defSet = false

function waiting() {
  if (!done) {
    console.log(`(${count++}) Waiting for sync...`)
    setTimeout(waiting, 5000)
  }
}

async function accountsGeneration(amount) {

  setTimeout(waiting, 1000)

  const tronWeb = tronWebBuilder()

  if (!defSet) {
    tronWeb.setDefaultBlock('latest');
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
  if (fs.existsSync(jsonPath)) {

    accounts = JSON.parse(fs.readFileSync(jsonPath, 'utf-8'))

  } else {

    accounts = [ tronWeb.defaultPrivateKey ]

    for (let i = 0; i < amount - 1; i++) {

      const account = await tronWeb.createAccount();
      if (tronWeb.isAddress(account.address.hex)) {
        accounts.push(account.privateKey);
        await tronWeb.transactionBuilder.sendTrx(account.address.base58, 10000);
      } else {
        i--;
      }
    }

    fs.ensureDirSync(tmpDir)
    fs.writeFileSync(path.join(tmpDir, 'accounts.json'), JSON.stringify(accounts, null, 2))
  }

  return accounts

}



module.exports = accountsGeneration
