const HDWalletProvider = require('@truffle/hdwallet-provider')
require('dotenv').config();

module.exports = {
  networks: {
    rinkeby: {
      provider: () => {
        return new HDWalletProvider(process.env.MNEMONIC, process.env.rinkeby_URL)
      },
      network_id: '4',
      skipDryRun: false,
    },
    mainnet: {
      provider: () => {
        return new HDWalletProvider(process.env.MAINNET_MNEMONIC, process.env.MAINNET_RPC_URL)
      },
      network_id: '1',
      skipDryRun: true,
    },
    ropsten: {
      provider: () => {
        return new HDWalletProvider(process.env.MNEMONIC, process.env.ropsten_URL)
      },
      network_id: '3',
      skipDryRun: true,
    },
    goerli: {
      provider: () => {
        return new HDWalletProvider(process.env.MNEMONIC, process.env.goerli_URL)
      },
      network_id: '5',
      skipDryRun: true,
    },
    kovan: {
      provider: () => {
        return new HDWalletProvider(process.env.MNEMONIC, process.env.kovan_URL)
      },
      network_id: '41',
      skipDryRun: true,
    },
    Bsctestnet: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, process.env.BscTestnet_URL),
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bsc: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, process.env.BscMainnet_URL),
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },ganache: {
      host: "localhost",
      port: 7545,
      network_id: "5777"
    },
  },
  compilers: {
    solc: {
      version: '0.6.6',
    },
  },
  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY
  },
  plugins: [
    'truffle-plugin-verify'
  ]
}
