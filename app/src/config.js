let port0 = 18190
let port1 = 18191
let port2 = 18891

if (process.platform === 'darwin') {
  port0 = 8090
  port1 = 8091
  port2 = 8092
}

module.exports = {
  from: 'TPL66VK2gCXNCD7EJg9pgJRfqcRazjhUZY',
  privateKey: 'da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0',
  consume_user_resource_percent: 30,
  fee_limit: 100000000,
  fullNode: `http://127.0.0.1:${port0}`,
  solidityNode: `http://127.0.0.1:${port1}`,
  eventServer: `http://127.0.0.1:${port2}`,
  network_id: "*"
}