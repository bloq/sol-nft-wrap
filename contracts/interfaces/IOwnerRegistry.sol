// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

interface IOwnerRegistry {
    function mint(address acct) external returns (bool);

    function burnTo(uint256 tokenId, address newOwner) external;
}
