const TestRPC = require("ethereumjs-testrpc");

module.exports = {
    networks: {
        test: {
            network_id: "*",
            provider: TestRPC.provider()
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
