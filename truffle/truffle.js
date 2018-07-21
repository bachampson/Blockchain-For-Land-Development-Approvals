var TestRPC = require("ganache-cli");

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
    }
  }
};
