// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.6;

interface IAcctFactory {
    event AcctCreated(address indexed _from, address indexed newAcct);

    function ours(address a) external view returns (bool);

    function acctCount() external view returns (uint256);

    function acctAt(uint256 idx) external view returns (address);

    function createAcct() external returns (address acctaddr);
}
