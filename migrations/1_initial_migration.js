var VORFaucet = artifacts.require("VORFaucet");

module.exports = function(developer, network, accounts) {
  console.log(network);
  console.log(accounts);
  developer.deploy(VORFaucet, '0x7c6bfc471d1a7f52ea1dc242936072944de97bdf', 'Rospten VOR Faucet');
};
