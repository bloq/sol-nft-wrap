const AcctFactory = artifacts.require('AcctFactory')
const Acct = artifacts.require('Acct')

const { expectRevert, expectEvent } = require('@openzeppelin/test-helpers')
const { expect } = require('chai')

contract('AcctFactory', async accounts => {
  let factory

  beforeEach(async () => {
    factory = await AcctFactory.new()
  })

  it('initial acctCount is 0', async () => {
    expect(await factory.acctCount()).to.be.bignumber.equal('0')
  })

  it('createAcct should increase acctCount', async () => {
    await factory.createAcct()
    expect(await factory.acctCount()).to.be.bignumber.equal('1')
    await factory.createAcct()
    expect(await factory.acctCount()).to.be.bignumber.equal('2')
  })

  it('createAcct should emit AcctCreated', async () => {
    const answer = await factory.createAcct.call()
    const tx = await factory.createAcct()
    await expectEvent(tx, 'AcctCreated', { _from: accounts[0], newAcct: answer })
  })

  it('index out-of-bounds should revert', async () => {
    await expectRevert(factory.acctAt(0), 'Index exceeds list length')
    await expectRevert(factory.acctAt(1), 'Index exceeds list length')
    await factory.createAcct()
    await expectRevert(factory.acctAt(1), 'Index exceeds list length')
  })

  it('new Acct should be owned by sender', async () => {
    const newAcctAddress = await factory.createAcct.call()
    await factory.createAcct()
    const newAcct = await Acct.at(newAcctAddress)
    expect(await newAcct.owner()).to.equal(accounts[0])
  })

  it('ours() answers true with new Acct', async () => {
    const newAcctAddress = await factory.createAcct.call()
    await factory.createAcct()
    expect(await factory.ours(newAcctAddress)).to.be.a('boolean').equal(true)
  })

  it('ours() answers false with Acct from other factory', async () => {
    const otherFactory = await AcctFactory.new()
    const newAcctAddress = await otherFactory.createAcct.call()
    await otherFactory.createAcct()
    expect(await factory.ours(newAcctAddress)).to.be.a('boolean').equal(false)
  })
})
