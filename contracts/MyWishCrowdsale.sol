pragma solidity ^0.4.16;

import "./MyWishToken.sol";
import "./MyWishConsts.sol";
import "./MyWishRateProvider.sol";
import "./zeppelin/crowdsale/FinalizableCrowdsale.sol";

contract MyWishCrowdsale is usingMyWishConsts, FinalizableCrowdsale {
    MyWishRateProviderI public rateProvider;

    function MyWishCrowdsale(
            uint _startTime,
            uint _endTime,
            uint _softCapWei,
            uint _hardCapTokens
    )
            Crowdsale(_startTime, _endTime, _hardCapTokens * TOKEN_DECIMAL_MULTIPLIER, COLD_WALLET) {

        token.mint(TEAM_ADDRESS, TEAM_TOKENS);
        token.mint(BOUNTY_ADDRESS, BOUNTY_TOKENS);
        token.mint(PREICO_ADDRESS, PREICO_TOKENS);

        MyWishToken(token).addExcluded(TEAM_ADDRESS);
        MyWishToken(token).addExcluded(BOUNTY_ADDRESS);
        MyWishToken(token).addExcluded(PREICO_ADDRESS);

        MyWishRateProvider provider = new MyWishRateProvider();
        provider.transferOwnership(owner);
        rateProvider = provider;
    }

    /**
     * @dev override token creation to integrate with MyWill token.
     */
    function createTokenContract() internal returns (MintableToken) {
        return new MyWishToken();
    }

    /**
     * @dev override getRate to integrate with rate provider.
     */
    function getRate(uint _value) internal constant returns (uint) {
        return rateProvider.getRate(msg.sender, soldTokens, _value);
    }

    function getBaseRate() internal constant returns (uint) {
        return rateProvider.getRate(msg.sender, soldTokens, MINIMAL_PURCHASE);
    }

    /**
     * @dev override getRateScale to integrate with rate provider.
     */
    function getRateScale() internal constant returns (uint) {
        return rateProvider.getRateScale();
    }

    /**
     * @dev Admin can set new rate provider.
     * @param _rateProviderAddress New rate provider.
     */
    function setRateProvider(address _rateProviderAddress) onlyOwner {
        require(_rateProviderAddress != 0);
        rateProvider = MyWishRateProviderI(_rateProviderAddress);
    }

    /**
     * @dev Admin can move end time.
     * @param _endTime New end time.
     */
    function setEndTime(uint _endTime) onlyOwner notFinalized {
        require(_endTime > startTime);
        endTime = _endTime;
    }

    function setHardCap(uint _hardCapTokens) onlyOwner notFinalized {
        hardCap = _hardCapTokens * TOKEN_DECIMAL_MULTIPLIER;
    }

    function addExcluded(address _address) onlyOwner notFinalized {
        MyWishToken(token).addExcluded(_address);
    }

    function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {
        if (_amountWei < MINIMAL_PURCHASE) {
            return false;
        }
        return super.validPurchase(_amountWei, _actualRate, _totalSupply);
    }

    function finalization() internal {
        super.finalization();
        token.finishMinting();
        MyWillToken(token).crowdsaleFinished();
        token.transferOwnership(owner);
    }
}