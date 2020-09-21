var CronJob = require('cron').CronJob
const express = require('express')
const BN = require('bn.js')
require('dotenv').config()
var config = require('config')
const { createWeb3 } = require('./utils')
const ethAddrs = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE'
// TODO: try different amount here.
const amount = '500000000000000000'
// TODO: Estimate gas.
const gas = new BN('632700')
// TODO: Find safe price from gas station.
const gasPrice = config.gasPrice.toString()
const web3 = createWeb3(config.provider, process.env.DEPLOYMENT_ACCOUNT_KEY)
const from = web3.eth.accounts.wallet[0].address
console.log('from', from)
var app = express()
const arbFinder = new web3.eth.Contract(config.contracts.arbFinder.abi, config.contracts.arbFinder.address)
const metFlash = new web3.eth.Contract(config.contracts.metFlash.abi, config.contracts.metFlash.address)

// Run job in every 5 minute?
var job = new CronJob('*/50 * * * * *', async function () {
  console.log('Checking arb opportunity')
  arbFinder.methods.findBestArbOpportunity(ethAddrs, amount).call()
    .then(data => {
      console.log('data', data)
      let input = new BN(amount)
      let expectedReturn = new BN(data.bestReturn)
      let loanFee = new BN('900000000000000')
      let netReturn = expectedReturn
        .sub((new BN(gasPrice)
          .mul(gas))
          .add(loanFee))
      console.log('net expected return', netReturn.toString())
      // netReturn.gt(input)
      if (netReturn.gt(input)) {
        console.log('########### Hurrrrey its arb opportunity########')
        // Execute tx.
        let src = web3.utils.hexToUtf8(data.srcExchange)
        let dest = web3.utils.hexToUtf8(data.destExchange)
        let pair = `${src}-${dest}`
        console.log('exchange pair', pair)
        pair = web3.utils.utf8ToHex(pair)
        metFlash.methods
          .flashArb(amount, pair).send({from, gasPrice, gas})
          .then(console.log)
      }
    })
    .catch(console.log)
}, null, true, 'America/Los_Angeles')

job.start()

app.listen('3128')
