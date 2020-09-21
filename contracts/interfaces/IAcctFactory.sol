
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.6;

interface IAcctFactory {
    event AcctCreated(address indexed _from, address indexed newAcct);

    function acctCount() external view returns (uint);
    function acctAt(uint idx) external view returns (address);

    function createAcct() external returns (address acctaddr);
}
