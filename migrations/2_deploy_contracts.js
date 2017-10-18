const MyWishCrowdsale = artifacts.require("./MyWishCrowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(MyWishCrowdsale, new Date("2017-10-25T9:00:00Z+0300").getTime(), new Date("2017-11-26T11:00:00Z+0300").getTime(), 22000000);
};
