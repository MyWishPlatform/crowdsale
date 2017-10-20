let chai = require("chai");
let chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
chai.should();

// const utils = require('./utils')
const Crowdsale = artifacts.require("./MyWishCrowdsale.sol");
const Token = artifacts.require("./MyWishToken.sol");
const Rate = artifacts.require("./MyWishRateProvider.sol");

const NOW = Math.ceil(new Date("2017-10-10T15:00:00Z").getTime() / 1000);
const YESTERDAY = NOW - 24 * 3600;
const DAY_BEFORE_YESTERDAY = YESTERDAY - 24 * 3600;
const TOMORROW = NOW + 24 * 3600;
const DAY_AFTER_TOMORROW = TOMORROW + 24 * 3600;
const HARD_CAP_TOKENS = 22000000;

contract('Crowdsale', function(accounts) {
    const OWNER = accounts[0];
    const BUYER_1 = accounts[1];
    const REACH_MAN = accounts[3];
    const RATE_30 = 1950;

    it('#0', function() {
        accounts.forEach(function (account, index) {
            web3.eth.getBalance(account, function (_, balance) {
                console.info("Account " + index + " (" + account + ") balance is " + web3.fromWei(balance, "ether"));
            });
        });
    });

    it('#1 construct', async() => {
        const crowdsale = await Crowdsale.deployed();
        (await crowdsale.token()).should.have.length(42);
    });

    it('#2 check started', async() => {
        const crowdsale = await Crowdsale.new(YESTERDAY, TOMORROW, HARD_CAP_TOKENS);
        (await crowdsale.hasStarted()).should.be.equals(true);
    });

    it('#3 check not yet started', async() => {
        const crowdsale = await Crowdsale.new(TOMORROW, DAY_AFTER_TOMORROW, HARD_CAP_TOKENS);
        (await crowdsale.hasStarted()).should.be.equals(false);
    });

    it('#4 check already finished', async() => {
        const crowdsale = await Crowdsale.new(DAY_BEFORE_YESTERDAY, YESTERDAY, HARD_CAP_TOKENS);
        (await crowdsale.hasStarted()).should.be.equals(true);
        (await crowdsale.hasEnded()).should.be.equals(true);
    });

    it('#5 check simple buy token', async() => {
        const bonuses = {
            '10 ether': 0.025,
            '30 ether': 0.04,
            '50 ether': 0.05,
            '100 ether': 0.07,
            '500 ether': 0.1,
            '1000 ether': 0.13
        };

        const stages = [
            web3.toWei(1650, 'ether'),
            web3.toWei(1780, 'ether'),
            web3.toWei(1950, 'ether'),
        ];

        const rates = [
            1950,
            1800,
            1650,
            1500,
        ];
        
        const crowdsale = await Crowdsale.new(YESTERDAY, TOMORROW, HARD_CAP_TOKENS);
        const ETH = web3.toWei(1, 'ether');
        const TOKENS = ETH * RATE_30;
        await crowdsale.sendTransaction({from: BUYER_1, value: ETH});
        const token = Token.at(await crowdsale.token());
        (await token.balanceOf(BUYER_1)).toNumber().should.be.equals(TOKENS);

    });

    it('#6 check buy bonuses', async() => {
        const bonuses = {
            '10 ether': 0.025,
            '30 ether': 0.04,
            '50 ether': 0.05,
            '100 ether': 0.07,
            '500 ether': 0.1,
            '1000 ether': 0.13
        };

        const stages = [
            web3.toWei(1650, 'ether'),
            web3.toWei(1780, 'ether'),
            web3.toWei(1950, 'ether'),
        ];

        const amountsPerStage = [
            web3.toWei(3635775, 'ether'),
            web3.toWei(3635775 + 3620520, 'ether'),
            web3.toWei(3635775 + 3620520 + 3635775, 'ether'),
        ];

        const rates = [
            1950,
            1800,
            1650,
            1500,
        ];

        const crowdsale = await Crowdsale.new(YESTERDAY, TOMORROW, HARD_CAP_TOKENS);
        const token = Token.at(await crowdsale.token());

        for (let i = 0; i < stages.length; i ++) {
            const eth = stages[i];
            const tokens = amountsPerStage[i];
            console.info("buy tokens");
            await crowdsale.sendTransaction({from: REACH_MAN, value: eth});
            const r = (await token.balanceOf(REACH_MAN));
            console.info("result:", r,  "expected:", tokens);
            console.info("take number");
            (await crowdsale.soldTokens()).toNumber().should.be.equals(Number(tokens), 'soldTokens must be');
            console.info("take balance");
            (await token.balanceOf(REACH_MAN)).toNumber().should.be.equals(Number(tokens), 'balanceOf buyer must be');
            const total = (await token.totalSupply()).toNumber();
            console.info("total supply", total);
        }
    });

});