// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import '@openzeppelin/contracts/GSN/Context.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import './interfaces/INFTOwnable.sol';

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract NFTOwnable is INFTOwnable, Context {
    address private _owner;
    address private _nftOwnerRegistry;

    event OwnershipTransferred(address indexed from, address indexed previousOwner, address indexed newOwner, bool isNftOwned);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(_msgSender(), address(0), msgSender, false);
    }

    function NFTCanOwn() external override view returns (bool) {
        return true;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() external override view returns (address) {
        return _owner;
    }

    function nftRegistry() external override view returns (address) {
        return _nftOwnerRegistry;
    }

    function _nftOwned() internal view returns (bool) {
	return (_nftOwnerRegistry != address(0));
    }
    
    function nftOwned() external override view returns (bool) {
        return _nftOwned();
    }

    function _nftOwner() internal view returns (address) {
	if (!_nftOwned()) {
	    return address(0);
	} else {
            return IERC721(_nftOwnerRegistry).ownerOf(uint256(address(this)));
	}
    }

    function nftOwner() external override view returns (address) {
        return _nftOwner();
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
	bool isNftOwned = _nftOwned();
        require((!isNftOwned && (_owner == _msgSender())) ||
	        (isNftOwned && (_nftOwner() == _msgSender())), "NFTOwnable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_msgSender(), _owner, address(0), false);
        _owner = address(0);
	_nftOwnerRegistry = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "NFTOwnable: new owner is the zero address");
        emit OwnershipTransferred(_msgSender(), _owner, newOwner, false);
        _owner = newOwner;
	_nftOwnerRegistry = address(0);
    }

    function transferOwnershipNft(address newRegistry) public onlyOwner {
        emit OwnershipTransferred(_msgSender(), _owner, _nftOwnerRegistry, true);
	_owner = address(0);
	_nftOwnerRegistry = newRegistry;
    }

}
