var TestRPC = require("ganache-cli");

var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat";

module.exports = {
  mocha: {
    reporter: "spec",
    //reporter: "mocha-junit-reporter",
    reporterOptions: {
      mochaFile: 'TEST-truffle.xml'
    }
  },
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    // add a new network definition that will self host TestRPC
    localtest: {
      provider: TestRPC.provider(),
      network_id:"*"
    },
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
