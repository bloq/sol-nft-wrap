// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// mock class using ERC20
contract ERC721Mock is ERC721 {
    uint256 private counter = 1;

    constructor(
        string memory name,
        string memory symbol,
        address initialAccount
    ) public ERC721(name, symbol) {
        mint(initialAccount);
    }

    function mint(address account) public {
        _mint(account, counter);
        counter = counter + 1;
    }
}
