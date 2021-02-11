// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;

import "./interfaces/IAcctFactory.sol";
import "./Acct.sol";

contract AcctFactory is IAcctFactory {
    address[] private allAccts;
    mapping(address => bool) private isOurs;

    function ours(address a) external override view returns (bool) {
        return isOurs[a];
    }

    function acctCount() external override view returns (uint256) {
        return allAccts.length;
    }

    function acctAt(uint256 idx) external override view returns (address) {
        require(idx < allAccts.length, "Index exceeds list length");
        return allAccts[idx];
    }

    function createAcct() external override returns (address acctaddr) {
        // create new Acct contract, owned by user
        acctaddr = address(new Acct(msg.sender));

        // record and log new account
        allAccts.push(acctaddr);
        isOurs[acctaddr] = true;
        emit AcctCreated(msg.sender, acctaddr);
    }
}
