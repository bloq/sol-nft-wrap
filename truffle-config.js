'use strict'

const HDWalletProvider = require('@truffle/hdwallet-provider')
require('dotenv').config()
var config = require('config')
let provider
if (process.env.DEPLOYMENT_ACCOUNT_KEY) {
  provider = new HDWalletProvider(process.env.DEPLOYMENT_ACCOUNT_KEY, config.provider)
}
module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
      skipDryRun: true
    },
    ropsten: {
      provider,
      network_id: 3,
      gas: 7000000,
      gasPrice: 5000000000, // 5 Gwei
      skipDryRun: true
    },
    kovan: {
      provider,
      network_id: 42,
      gas: 5000000,
      gasPrice: 5000000000, // 5 Gwei
      skipDryRun: true
    },
    mainnet: {
      provider,
      network_id: 1,
      gas: 6000000,
      gasPrice: 42000000000
    }
  },
  compilers: {
    solc: {
      version: '^0.6.6'
    }
  }
}
