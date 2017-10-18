const MyWishCrowdsale = artifacts.require("./MyWishCrowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(MyWishCrowdsale);
};
