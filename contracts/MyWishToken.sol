pragma solidity ^0.4.16;

import "./MyWishConsts.sol";
import "./zeppelin/token/MintableToken.sol";
import "./zeppelin/token/BurnableToken.sol";

contract MyWishToken is usingMyWishConsts, MintableToken, BurnableToken {
    /**
     * @dev Pause token transfer. After successfully finished crowdsale it becomes true.
     */
    bool public paused = true;
    /**
     * @dev Accounts who can transfer token even if paused. Works only during crowdsale.
     */
    mapping(address => bool) excluded;

    function name() constant public returns (string _name) {
        return TOKEN_NAME;
    }

    function symbol() constant public returns (bytes32 _symbol) {
        return TOKEN_SYMBOL;
    }

    function decimals() constant public returns (uint8 _decimals) {
        return TOKEN_DECIMALS_UINT8;
    }

    function crowdsaleFinished() onlyOwner {
        paused = false;
        finishMinting();
    }

    function addExcluded(address _toExclude) onlyOwner {
        excluded[_toExclude] = true;
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
        require(!paused || excluded[_from]);
        return super.transferFrom(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) returns (bool) {
        require(!paused || excluded[msg.sender]);
        return super.transfer(_to, _value);
    }

    /**
     * @dev Burn tokens from the specified address.
     * @param _from     address The address which you want to burn tokens from.
     * @param _value    uint    The amount of tokens to be burned.
     */
    function burnFrom(address _from, uint256 _value) returns (bool) {
        require(_value > 0);
        var allowance = allowed[_from][msg.sender];
        balances[_from] = balances[_from].sub(_value);
        totalSupply = totalSupply.sub(_value);
        allowed[_from][msg.sender] = allowance.sub(_value);
        Burn(_from, _value);
        return true;
    }
}