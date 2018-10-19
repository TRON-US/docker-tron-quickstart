const TronWeb = require('tronweb')
const sleep = require('sleep')
const fs = require('fs-extra')
const path = require('path')

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

  const tronWeb = new TronWeb(
      "http://127.0.0.1:8090",
      "http://127.0.0.1:8091",
      "http://127.0.0.1:8092",
      'da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0',
  )

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

    accounts = []

    for (let i = 0; i < amount; i++) {

      const account = await tronWeb.createAccount();
      if (tronWeb.isAddress(account.address.hex)) {
        accounts.push(account);
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
