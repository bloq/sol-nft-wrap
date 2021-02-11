
const OwnableMock = artifacts.require("OwnableMock");
const OwnerRegistry = artifacts.require("OwnerRegistry");

const {expectRevert, expectEvent, BN, constants} = require('@openzeppelin/test-helpers');

contract("OwnerRegistry", async accounts => {
  let owner = accounts[0], notOwner = accounts[1], nftOwner = accounts[2], newOwner = accounts[3], approved = accounts[4], registry;

  beforeEach(async () => {
    registry = await OwnerRegistry.new();
  });

  it("can mint", async () => {
    let ownable = await OwnableMock.new(owner);
    await ownable.transferOwnership(registry.address);
    await registry.mintTo(ownable.address, nftOwner);
    assert.equal(await ownable.owner(), registry.address);
    assert.equal(await registry.balanceOf(nftOwner), 1);
    assert.equal(await registry.ownerOf(ownable.address), nftOwner);
  });

  it("cannot mint if not owned by registry", async () => {
    let ownable = await OwnableMock.new(owner);
    await expectRevert(registry.mintTo(ownable.address, nftOwner), "OwnerRegistry: owner is not the registry");
  });

  it("cannot mint twice", async () => {
    let ownable = await OwnableMock.new(owner);
    await ownable.transferOwnership(registry.address);
    await registry.mintTo(ownable.address, nftOwner);
    await expectRevert(registry.mintTo(ownable.address, nftOwner), "ERC721: token already minted");
  });

  it("nft owner can burn", async () => {
    let ownable = await OwnableMock.new(owner);
    await ownable.transferOwnership(registry.address);
    await registry.mintTo(ownable.address, nftOwner);
    await registry.burnTo(ownable.address, newOwner, {from: nftOwner});
    assert.equal(await registry.balanceOf(nftOwner), 0);
    assert.equal(await ownable.owner(), newOwner);
  });

  it("approved can burn", async () => {
    let ownable = await OwnableMock.new(owner);
    await ownable.transferOwnership(registry.address);
    await registry.mintTo(ownable.address, nftOwner);
    await registry.approve(approved, ownable.address, {from: nftOwner});
    await registry.burnTo(ownable.address, newOwner, {from: approved});
    assert.equal(await registry.balanceOf(nftOwner), 0);
    assert.equal(await ownable.owner(), newOwner);
  });

  it("approved-for-all can burn", async () => {
    let ownable = await OwnableMock.new(owner);
    await ownable.transferOwnership(registry.address);
    await registry.mintTo(ownable.address, nftOwner);
    await registry.setApprovalForAll(approved, true, {from: nftOwner});
    await registry.burnTo(ownable.address, newOwner, {from: approved});
    assert.equal(await registry.balanceOf(nftOwner), 0);
    assert.equal(await ownable.owner(), newOwner);
  });

  it("not nft owner nor approved cannot burn", async () => {
    let ownable = await OwnableMock.new(owner);
    await ownable.transferOwnership(registry.address);
    await registry.mintTo(ownable.address, nftOwner);
    await expectRevert(registry.burnTo(ownable.address, newOwner, {from: notOwner}), "OwnerRegistry: caller is not owner nor approved");
  });
});
