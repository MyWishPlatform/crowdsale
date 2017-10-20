const TestRPC = require("ethereumjs-testrpc");
const ether = '0000000000000000000';
module.exports = {
    networks: {
        test: {
            network_id: "*",
            provider: TestRPC.provider({
                accounts: [10, 100, 10000, 1000000].map(function (v) {
                    return {balance: "" + v + ether};
                }),
                time: new Date("2017-10-10T15:00:00Z")
            })
        }
    },
    network: 'test',
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
};
