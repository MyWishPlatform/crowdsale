pragma solidity ^0.4.7;

contract usingMyWishConsts {
    uint constant TOKEN_DECIMALS = 18;
    uint8 constant TOKEN_DECIMALS_UINT8 = 18;
    uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;

    uint constant TEAM_TOKENS =   1100000 * TOKEN_DECIMAL_MULTIPLIER;
    uint constant BOUNTY_TOKENS = 2000000 * TOKEN_DECIMAL_MULTIPLIER;
    uint constant PREICO_TOKENS = 3038800 * TOKEN_DECIMAL_MULTIPLIER;
    uint constant MINIMAL_PURCHASE = 0.05 ether;

    address constant TEAM_ADDRESS = 0xE4F0Ff4641f3c99de342b06c06414d94A585eFfb;
    address constant BOUNTY_ADDRESS = 0x76d4136d6EE53DB4cc087F2E2990283d5317A5e9;
    address constant PREICO_ADDRESS = 0x195610851A43E9685643A8F3b49F0F8a019204f1;
    address constant COLD_WALLET = 0x80826b5b717aDd3E840343364EC9d971FBa3955C;

    string constant TOKEN_NAME = "MyWish Token";
    bytes32 constant TOKEN_SYMBOL = "WISH";
}