// This file is part of Truffle suite and helps keep track of your deployments
// SPDX-License-Identifier: MIT

pragma solidity >=0.4.21 <0.7.0;

contract Migrations {
    address public owner;
    uint256 public lastCompletedMigration;

    constructor() public {
        owner = msg.sender;
    }

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    function setCompleted(uint256 completed) public restricted {
        lastCompletedMigration = completed;
    }
}
