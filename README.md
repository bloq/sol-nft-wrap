# sol-nft-wrap

This set of smart contracts presents an account abtraction, and an ERC721 NFT as
ownership registry and transfer mechanism for abitrary contracts.

## Components

### C1:   Acct, an asset container

Acct is a contract whose sole purpose is to hold assets, in order to transfer those
assets between owners, possibly including ownership by an NFT marketplace.

Acct contract hold ERC20 tokens or ETH.  This on-chain account (aka wallet) may
be owned by
1. an owner address (EOA or another contract), or
2. the owner of an NFT, whose unique NFT id is the contract address
   owned by the NFT.
   
TBD:  Holding NFTs.

### C2:   OwnerRegistry, an ERC721 NFT registry for contracts

OwnerRegistry is a standard ERC721 contract with 'OWNERS' ticker symbol.

The Token-ID within this registry is the contract address of an Acct.

Ownership of the assets within an Acct (or any other tracked contract) may then be transferred via normal
ERC721 transfer mechanisms.

## Features

### NFT Lock

If the "NFT Lock" is set, then withdrawals are disabled _when the Acct
is owned by an NFT.  This is intended to freeze the Acct while listed on
an NFT marketplace.  When ownership is transferred, the owner
unregisters the Acct from the registry to access the assets.

### Time Lock

A non-revokable time lock can be applied to an Acct.  If the time lock's
timestamp is in the future, when withdrawals are disabled.  When the
timestamp is in the past, withdrawals are enabled (modulo other locks,
such as the NFT lock, being unlocked also).

## User stories

### Asset package and transfer

Alice provably locks us assets in a smart contract, and registers the contract with an ERC721-compatible registry.  Alice deposits the NFT on an NFT marketplace.

Bob examines the NFT on the marketplace, and inspects the assets associated with the NFT.

Bob purchases the NFT on the marketplace, ownership of the NFT transfers to Bob.   Bob may immediately withdraw any or all of the assets.  Alice cannot access the assets, following NFT ownership transfer.

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
