// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interfaces/IOwnable.sol";
import "./interfaces/IOwnerRegistry.sol";

/**
     ERC721 registry for arbitrary contracts.

     Each "token id" is the contract's address.
 */

contract OwnerRegistry is ERC721("OwnerRegistry", "OWNER"), IOwnerRegistry {
    function mint(address acct) external override returns (bool) {
        require(IOwnable(acct).owner() == msg.sender, "Sender is not contract owner"); // make sure sender owns contract in question

        // attempt to mint.  will fail if already minted.
        // The provided address is cast to uint256,
        // to be used as the NFT token-id.
        _safeMint(msg.sender, uint256(acct));

        return true;
    }

    function burnTo(uint256 tokenId, address newOwner) external override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);

        address acct = address(tokenId);
        IOwnable(acct).transferOwnership(newOwner);
    }
}
