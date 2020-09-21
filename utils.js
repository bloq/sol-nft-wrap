'use strict'

const bip39 = require('bip39')
const hdkey = require('hdkey')
const Web3 = require('web3')

const GAS_OVERESTIMATION = 1.1

function mnemonicToKeyPair (mnemonic, derivationPath, password) {
  const seed = bip39.mnemonicToSeedSync(mnemonic, password)
  const { privateKey, publicKey } = hdkey
    .fromMasterSeed(seed)
    .derive(derivationPath)
  return { privateKey, publicKey }
}

function createWeb3 (url, mnemonic) {
  const web3 = new Web3(url)

  if (mnemonic) {
    const derivationPath = "m/44'/60'/0'/0/0"
    const privateKey = mnemonicToKeyPair(mnemonic, derivationPath).privateKey
    web3.eth.accounts.wallet.create(0).add(`0x${privateKey.toString('hex')}`)
  }

  return web3
}

function createGetContract (web3, contracts) {
  return function (contractName, contractAddr) {
    return web3.eth.getChainId().then(function (chain) {
      const { abi, address } = contracts[chain].find(
        c => c.name === contractName
      )
      return new web3.eth.Contract(abi, address || contractAddr)
    })
  }
}

function estimateGasAndSend (tx, options) {
  return tx
    .estimateGas(options)
    .then(gas =>
      tx.send({ ...options, gas: Math.ceil(gas * GAS_OVERESTIMATION) })
    )
}

module.exports = {
  createGetContract,
  createWeb3,
  estimateGasAndSend
}
