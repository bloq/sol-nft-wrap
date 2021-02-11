// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";

contract OwnableMock is Ownable {
    constructor(address owner) public {
        transferOwnership(owner);
    }
}
