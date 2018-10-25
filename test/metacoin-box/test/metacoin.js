var MetaCoin = artifacts.require("./MetaCoin.sol");

// this tests require TronBox >= 2.1.0

contract('MetaCoin', function (accounts) {

  it("should verify that the contract has been deployed by accounts[0]", async function () {
    const instance = await MetaCoin.deployed();
    assert.equal(await instance.getOwner(), tronWeb.address.toHex(accounts[0]))
  });

  it("should put 10000 MetaCoin in the first account", async function () {
    const instance = await MetaCoin.deployed();
    const balance = await instance.getBalance(accounts[0], {from: accounts[0]});
    assert.equal(balance, 10000, "10000 wasn't in the first account");
  });

  it("should call a function that depends on a linked library", async function () {
    const meta = await MetaCoin.deployed();
    const metaCoinBalance = (await meta.getBalance.call(accounts[0])).toNumber();
    const metaCoinEthBalance = (await meta.getBalanceInEth.call(accounts[0])).toNumber();
    assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, "Library function returned unexpected function, linkage may be broken");
  });

  it("should send coins from account 0 to 1", async function () {
    const meta = await MetaCoin.deployed();
    const account_one_starting_balance = (await meta.getBalance.call(accounts[0])).toNumber();
    const account_two_starting_balance = (await meta.getBalance.call(accounts[1])).toNumber();
    await meta.sendCoin(accounts[1], 10, {
      from: accounts[0]
    });
    assert.equal(await meta.getBalance.call(accounts[0]), account_one_starting_balance - 10, "Amount wasn't correctly taken from the sender");
    assert.equal(await meta.getBalance.call(accounts[1]), account_two_starting_balance + 10, "Amount wasn't correctly sent to the receiver");
  });

  it("should send coins from account 1 to 2", async function () {
    const meta = await MetaCoin.deployed();
    const account_two_starting_balance = (await meta.getBalance.call(accounts[1])).toNumber();
    const account_three_starting_balance = (await meta.getBalance.call(accounts[2])).toNumber();
    await meta.sendCoin(accounts[2], 5, {
      from: accounts[1]
    });
    assert.equal(await meta.getBalance.call(accounts[1]), account_two_starting_balance - 5, "Amount wasn't correctly sent to the receiver");
    assert.equal(await meta.getBalance.call(accounts[2]), account_three_starting_balance + 5, "Amount wasn't correctly sent to the receiver");
  });
});
