const AcctFactory = artifacts.require('AcctFactory')
const OwnerRegistry = artifacts.require('OwnerRegistry')
module.exports = async function (deployer, network) {
  try {
    await deployer.deploy(AcctFactory)
    await deployer.deploy(OwnerRegistry)
  } catch (e) {
    console.log(`Error in migration: ${e.message}`)
  }
}
