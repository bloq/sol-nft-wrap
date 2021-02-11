const OwnableMock = artifacts.require('OwnableMock')
const OwnerRegistry = artifacts.require('OwnerRegistry')

const { expectRevert } = require('@openzeppelin/test-helpers')
const { expect } = require('chai')

contract('OwnerRegistry', async accounts => {
  const owner = accounts[0]; const notOwner = accounts[1]; const nftOwner = accounts[2]; const newOwner = accounts[3]; const approved = accounts[4]; let registry

  beforeEach(async () => {
    registry = await OwnerRegistry.new()
  })

  it('can mint', async () => {
    const ownable = await OwnableMock.new(owner)
    await ownable.transferOwnership(registry.address)
    await registry.mintTo(ownable.address, nftOwner)
    expect(await ownable.owner()).to.equal(registry.address)
    expect(await registry.balanceOf(nftOwner)).to.be.bignumber.equal('1')
    expect(await registry.ownerOf(ownable.address)).to.equal(nftOwner)
  })

  it('cannot mint if not owned by registry', async () => {
    const ownable = await OwnableMock.new(owner)
    await expectRevert(registry.mintTo(ownable.address, nftOwner), 'Owner is not the registry')
  })

  it('cannot mint twice', async () => {
    const ownable = await OwnableMock.new(owner)
    await ownable.transferOwnership(registry.address)
    await registry.mintTo(ownable.address, nftOwner)
    await expectRevert(registry.mintTo(ownable.address, nftOwner), 'ERC721: token already minted')
  })

  it('nft owner can burn', async () => {
    const ownable = await OwnableMock.new(owner)
    await ownable.transferOwnership(registry.address)
    await registry.mintTo(ownable.address, nftOwner)
    await registry.burnTo(ownable.address, newOwner, { from: nftOwner })
    expect(await registry.balanceOf(nftOwner)).to.be.bignumber.equal('0')
    expect(await ownable.owner()).to.equal(newOwner)
  })

  it('approved can burn', async () => {
    const ownable = await OwnableMock.new(owner)
    await ownable.transferOwnership(registry.address)
    await registry.mintTo(ownable.address, nftOwner)
    await registry.approve(approved, ownable.address, { from: nftOwner })
    await registry.burnTo(ownable.address, newOwner, { from: approved })
    expect(await registry.balanceOf(nftOwner)).to.be.bignumber.equal('0')

    expect(await ownable.owner()).to.equal(newOwner)
  })

  it('approved-for-all can burn', async () => {
    const ownable = await OwnableMock.new(owner)
    await ownable.transferOwnership(registry.address)
    await registry.mintTo(ownable.address, nftOwner)
    await registry.setApprovalForAll(approved, true, { from: nftOwner })
    await registry.burnTo(ownable.address, newOwner, { from: approved })
    expect(await registry.balanceOf(nftOwner)).to.be.bignumber.equal('0')
    expect(await ownable.owner()).to.equal(newOwner)
  })

  it('not nft owner nor approved cannot burn', async () => {
    const ownable = await OwnableMock.new(owner)
    await ownable.transferOwnership(registry.address)
    await registry.mintTo(ownable.address, nftOwner)
    await expectRevert(registry.burnTo(ownable.address, newOwner, { from: notOwner }), 'Caller is not owner nor approved')
  })
})
