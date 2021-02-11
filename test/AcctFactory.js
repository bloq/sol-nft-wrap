const AcctFactory = artifacts.require("AcctFactory");
const Acct = artifacts.require("Acct");

const {expectRevert, expectEvent, BN, constants} = require('@openzeppelin/test-helpers');

contract("AcctFactory", async accounts => {
  let factory;

  beforeEach(async () => {
    factory = await AcctFactory.new();
  });

  it("initial acctCount is 0", async () => {
    let answer = await factory.acctCount();
    assert.equal(answer, 0);
  });

  it("createAcct should increase acctCount", async () => {
    await factory.createAcct();
    assert.equal(await factory.acctCount(), 1);
    await factory.createAcct();
    assert.equal(await factory.acctCount(), 2);
  });

  it("createAcct should emit AcctCreated", async () => {
    let answer = await factory.createAcct.call();
    let tx = await factory.createAcct();
    await expectEvent(tx, 'AcctCreated', {_from: accounts[0], newAcct: answer});
  });

  it("index out-of-bounds should revert", async () => {
    await expectRevert(factory.acctAt(0), "Index exceeds list length");
    await expectRevert(factory.acctAt(1), "Index exceeds list length");
    await factory.createAcct();
    await expectRevert(factory.acctAt(1), "Index exceeds list length");
  });

  it("new Acct should be owned by sender", async () => {
    let newAcctAddress = await factory.createAcct.call();
    await factory.createAcct();
    let newAcct = await Acct.at(newAcctAddress);
    assert.equal(await newAcct.owner(), accounts[0]);
  });

  it("ours() answers true with new Acct", async () => {
    let newAcctAddress = await factory.createAcct.call();
    await factory.createAcct();
    assert.equal(await factory.ours(newAcctAddress), true);
  });

  it("ours() answers false with Acct from other factory", async () => {
    let otherFactory = await AcctFactory.new();
    let newAcctAddress = await otherFactory.createAcct.call();
    await otherFactory.createAcct();
    assert.equal(await factory.ours(newAcctAddress), false);
  });
});
