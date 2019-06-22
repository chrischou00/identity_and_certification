var HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    ropsten: {
      provider: function () {
        return new HDWalletProvider("nothing virus couch install priority expand off orchard street earn answer guess", "https://ropsten.infura.io/v3/35a4a486158b470d96ca8a8711b648d7");
      },
      network_id: '3',
      skipDryRun: true
    },
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 6721975
    }
  }
};
//0x1ce421937a6f59bf58faafe316d23aaed690da18