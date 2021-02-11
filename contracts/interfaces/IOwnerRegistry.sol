// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

interface IOwnerRegistry {
    function mintTo(address acct, address newOwner) external returns (bool);

    function burnTo(uint256 tokenId, address newOwner) external;
}
