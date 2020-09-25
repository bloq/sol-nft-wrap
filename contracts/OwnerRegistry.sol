
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import './interfaces/INFTOwnable.sol';

/**
     ERC721 registry for arbitrary contracts.

     Each "token id" is the contract's address.
 */

contract OwnerRegistry is ERC721("OwnerRegistry","OWNERS") {
    function mint(address acct) external returns (bool) {
	require(INFTOwnable(acct).NFTCanOwn() == true);		// quick ABI check
	require(INFTOwnable(acct).owner() == msg.sender);	// make sure sender owns contract in question

	// attempt to mint.  will fail if already minted.
	// The provided address is cast to uint256,
	// to be used as the NFT token-id.
	_safeMint(msg.sender, uint256(acct));
    }
}
