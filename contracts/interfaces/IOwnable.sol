// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.6;

interface IOwnable {
    function owner() external view returns (address);

    function transferOwnership(address newOwner) external;
}
