var Adoption = artifacts.require("Adoption");
var power = artifacts.require("giving");

module.exports = function (deployer) {

  deployer.deploy(power);
};