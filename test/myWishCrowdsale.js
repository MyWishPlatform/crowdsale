let chai = require("chai");
let chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
chai.should();

// const utils = require('./utils')
const Crowdsale = artifacts.require("./MyWishCrowdsale.sol");
const Token = artifacts.require("./MyWishToken.sol");
const Rate = artifacts.require("./MyWishRateProvider.sol");
let crowdsale, token, rate;

contract('Crowdsale', function(accounts) {
    it('#0', async() => {
        console.log("Accounts " + accounts.length);
        accounts.forEach(function (account) {
            web3.eth.getBalance(account, function (_, balance) {
                console.info("Account " + account + " balance is " + web3.fromWei(balance, "ether"));
            });
        });
    });

});