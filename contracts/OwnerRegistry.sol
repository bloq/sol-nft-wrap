// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interfaces/IOwnable.sol";
import "./interfaces/IOwnerRegistry.sol";

/**
     ERC721 registry for arbitrary contracts.

     Each "token id" is the contract's address.
 */

contract OwnerRegistry is ERC721("OwnerRegistry", "OWNER"), IOwnerRegistry {
    function mintTo(address ownable, address newOwner) external override returns (bool) {
        // Ownership has to be transfered to this contract before calling this function.
        // Both transferOwnership and the call to mintTo have to be made in a single
        // transaction, otherwise it would be possible for an attacker to front-run
        // the call to mintTo and steal the Ownable!
        // Note also that this contract should not be made the owner of any Ownable
        // (other than tokens), otherwise attackers could call mintTo to first mint
        // the Ownable to themselves and then burn it to steal ownership!
        require(IOwnable(ownable).owner() == address(this), "Owner is not the registry");

        // attempt to mint.  will fail if already minted.
        // The provided address is cast to uint256,
        // to be used as the NFT token-id.
        _safeMint(newOwner, uint256(ownable));

        return true;
    }

    function burnTo(uint256 tokenId, address newOwner) external override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved");
        IOwnable(address(tokenId)).transferOwnership(newOwner);
        _burn(tokenId);
    }
}
