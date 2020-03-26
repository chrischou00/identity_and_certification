var HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    ropsten: {
      provider: function () {
        return new HDWalletProvider("nothing virus couch install priority expand off orchard street earn answer guess", "https://ropsten.infura.io/v3/35a4a486158b470d96ca8a8711b648d7");
      },
      network_id: '3',
      skipDryRun: true,
      gas: 4700000
    },
    kovan: {
      provider: function(){
        return new HDWalletProvider("nothing virus couch install priority expand off orchard street earn answer guess", "https://kovan.infura.io/v3/ee27b8862b7441dbbceefa0cdf34768f");
      },
      network_id: '42',
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
