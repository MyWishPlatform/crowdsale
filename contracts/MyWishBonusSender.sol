pragma solidity ^0.4.16;


import './zeppelin/token/ERC20.sol';
import './zeppelin/ownership/Ownable.sol';


contract AddressAndTokensProvider {
    function eachAddress(function (uint, address, uint) returns (bool) callback) internal returns (uint) {
        if (!callback(1, 0x01234567, 1234567000000)) return 1;
    }
}


contract MyWishBonusSender is AddressAndTokensProvider, Ownable {
    address constant CS_ADDRESS = 0x00ED6ab199F4bD44ea548709384aeb2783FE6507;
    address constant ADDRESS = 0x1b22C32cD936cB97C28C5690a0695a82Abf688e6;

    uint public lastIndex;

    uint summary;

    uint limit;

    function calcSummary(uint index, address adr, uint amount) internal returns (bool) {
        summary += amount;
        return true;
    }

    function sendToken(uint _limit) onlyOwner {
        limit = _limit;
        eachAddress(sendTokenInternal);
    }

    function sendTokenInternal(uint index, address adr, uint amount) internal returns (bool) {
        if (lastIndex >= index) {
            return true;
        }
        if (index > limit) {
            return false;
        }

        lastIndex = index;
        require(ERC20(ADDRESS).transferFrom(CS_ADDRESS, adr, amount));
        return true;
    }

    function getSummary() public constant returns (uint tokens) {
        eachAddress(calcSummary);
        return summary;
    }
}
