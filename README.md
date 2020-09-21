# sol-nft-wrap

This set of smart contracts presents an account abtraction that may
hold ERC20 tokens or ETH.  This on-chain account (aka wallet) may
be owned by
1. an owner address (EOA or another contract), or
2. the owner of an NFT, whose unique NFT id is the contract address
   owned by the NFT.
   
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
