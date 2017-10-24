pragma solidity ^0.4.16;

import "./MyWishToken.sol";
import "./MyWishCrowdsale.sol";
import "./MyWishRateProvider.sol";
import "./zeppelin/math/SafeMath.sol";

contract MyWishBtcBuyer is usingMyWishConsts {
    using SafeMath for uint;
    address constant SERVER = 0x1eee4c7d88aadec2ab82dd191491d1a9edf21e9a;
    MyWishToken private token;
    MyWishRateProviderI private rateProvider;
    MyWishCrowdsale private crowdsale;

    function MyWishBtcBuyer(MyWishToken _token, MyWishRateProviderI _rateProvider, MyWishCrowdsale _crowdsale){
        token = _token;
        rateProvider = _rateProvider;
        crowdsale = _crowdsale;
    }

    function buy(address _buyer, uint _amount) external {
        require(msg.sender == SERVER);

        uint rate = rateProvider.getRate(_buyer, crowdsale.soldTokens(), _amount);
        uint scale = rateProvider.getRateScale();
        uint tokens = _amount.mul(rate).div(scale);
        token.transferFrom(TEAM_ADDRESS, _buyer, tokens);
    }
}
