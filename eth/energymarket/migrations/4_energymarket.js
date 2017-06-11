var EnergyMarketContract = artifacts.require("./EnergyMarketContract.sol");

module.exports = function(deployer) {
  deployer.deploy(EnergyMarketContract);
};
