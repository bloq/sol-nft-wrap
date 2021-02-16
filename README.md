# sol-nft-wrap

This set of smart contracts presents an account abstraction, and an ERC721 NFT as
ownership registry and transfer mechanism for abitrary contracts.

## Components

### C1:   Acct, an asset container

Acct is a contract whose sole purpose is to hold assets, in order to
transfer those assets between owners, possibly including ownership
by an NFT marketplace.

An Acct contract holds ERC20 tokens or ETH.  This on-chain account (aka
on-chain wallet) may be owned by

1. An owner address (EOA or another contract), or
2. The NFT ownership registry contract.

TBD:  Holding NFTs.

### C2:   OwnerRegistry, an ERC721 NFT registry for contracts

OwnerRegistry is a standard ERC721 contract with 'OWNER' ticker symbol.

The Token-ID within this registry is the contract address of an Acct.

Ownership of an Acct may be transferred to the registry.  The Acct
may then be transferred via ERC721 standard means.

Ownership is transferred from the registry to the NFT owner by burning
the NFT.

## Features

### NFT Lock

While an Acct is owned by the registry, assets cannot be withdrawn
or transferred (unless prior approvals were granted).

### Time Lock

A non-revokable time lock can be applied to an Acct.  If the time lock's
timestamp is in the future, when withdrawals are disabled.  When the
timestamp is in the past, withdrawals are enabled.

## User stories

### Asset package and transfer

Alice provably locks up assets in a smart contract, and registers the
contract with an ERC721-compatible registry.  Alice deposits the NFT
on an NFT marketplace.

Bob examines the NFT on the marketplace, and inspects the assets
associated with the NFT.

Bob purchases the NFT on the marketplace, ownership of the NFT
transfers to Bob.  Bob unlocked the Acct by burning the NFT.  Bob may
then immediately withdraw any or all of the assets.  Alice cannot
access the assets, following NFT ownership transfer to Bob.

## Setup.
1. Install packages
   ```
   npm i -g truffle
   npm i
   ```
2. Update provider url in config/default.json
3. Set DEPLOYMENT_ACCOUNT_KEY in env
   ```
   create a .env file in root
   DEPLOYMENT_ACCOUNT_KEY =  "my mnemonic phrase"
   ```
4. Deploy you own contracts if want to do arb- 
   ``` 
   truffle migrate --reset --network mainnet/ropsten
   ```
