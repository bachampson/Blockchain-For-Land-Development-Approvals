var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    ganache: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    livelocal: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    azure: {
      host: "blchcu-dns-reg1.australiasoutheast.cloudapp.azure.com",
      gas: 5000000,
      port: 8545,
      network_id: "10101010",
      provider: function() {
        return new HDWalletProvider(mnemonic, "http://blchcu-dns-reg1.australiasoutheast.cloudapp.azure.com:8545", 0);
      }
    }
  }
};
