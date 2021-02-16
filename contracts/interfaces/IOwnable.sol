// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;

interface IOwnable {
    function owner() external view returns (address);

    function transferOwnership(address newOwner) external;
}
