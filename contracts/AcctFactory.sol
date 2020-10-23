// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.6;

import "./interfaces/IAcctFactory.sol";
import "./Acct.sol";

contract AcctFactory is IAcctFactory {
    address[] private allAccts;

    constructor() public {}

    function acctCount() external override view returns (uint256) {
        return allAccts.length;
    }

    function acctAt(uint256 idx) external override view returns (address) {
        require(idx < allAccts.length);
        return allAccts[idx];
    }

    function createAcct() external override returns (address acctaddr) {
        acctaddr = address(new Acct());
        allAccts.push(acctaddr);
        emit AcctCreated(msg.sender, acctaddr);
    }
}
