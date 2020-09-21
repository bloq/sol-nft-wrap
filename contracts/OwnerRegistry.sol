
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import './interfaces/INFTOwnable.sol';

/**
    Ensures that any contract that inherits from this contract is able to
    withdraw funds that are accidentally received or stuck.
 */

contract OwnerRegistry is ERC721("OwnerRegistry","NFTOWN") {
    function mint(address acct) external returns (bool) {
	// quick ABI check
	require(INFTOwnable(acct).NFTCanOwn() == true);
	require(INFTOwnable(acct).owner() == msg.sender);

	// attempt to mint.  will fail if already minted.
	_safeMint(msg.sender, uint256(acct));
    }
}
