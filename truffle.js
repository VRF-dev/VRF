const connectionConfig = require('frg-ethereum-runners/config/network_config.json');
const HDWalletProvider = require('truffle-hdwallet-provider');

require('dotenv').config();

module.exports = {
  networks: {
    ganacheUnitTest: connectionConfig.ganacheUnitTest,
    gethUnitTest: connectionConfig.gethUnitTest,
    testrpcCoverage: connectionConfig.testrpcCoverage,
    ropsten: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, process.env.ROPSTEN_PROVIDER),
      network_id: 3,
      gas: 2000000,
      gasPrice: 50000000000
    },
    mainnet: {
      ref: 'mainnet-prod',
      network_id: 1,
      provider: () => new HDWalletProvider(process.env.MNEMONIC, process.env.MAINNET_PROVIDER),
      gasPrice: 39000000000
    }
  },
  compilers: {
    solc: {
      version: '0.6.6',
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  },
  mocha: {
    enableTimeouts: false
  }
};
