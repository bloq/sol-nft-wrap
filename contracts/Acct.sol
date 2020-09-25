
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
import './NFTOwnable.sol';
import './interfaces/IAcct.sol';

/**
    Acct:  an abstract shell for ETH and ERC20 assets.

    The intended use of Acct is to be filled with assets.   Those
    assets may then be transferred to other owner(s), according to
    owner-specified rules.

    An Acct may be owned by an Ethereum EOA, a smart contract such as
    Gnosis Safe, or an NFT such as the provided OwnerRegistry, which
    uses a simple "token ID = contract address" mechanism via ERC721.

    Guarantees:
    * if nftLock is enabled, withdraw and set-lock-time are disabled
      if-and-only-if the owner is an NFT.  This is intended to freeze the
      account while on an NFT marketplace, then unfreeze when transferred
      to a new owner, who then calls transferOwnership() to remove the lock
      and access the assets.
    * If unlockTime is in the future, withdraw and set-lock-time are disabled
    * Only the owner may withdraw or set-lock-time
    * If the owner is set to EOA, that Ethereum EOA is the owner; NFT has
      no access.
    * If the owner is set to NFT, the owner listed in the ERC721 registry
      is the owner; Ethereum EOA has no access.
    * No other entities are permitted to withdraw.

 */

contract Acct is NFTOwnable, IAcct {
    using SafeERC20 for ERC20;

    uint256 public unlockTime;
    bool public nftLock;

    /**
     * @dev Set unlock time
     * @param newUnlockTime Absolute time at which contract is unlocked
     */
    function setUnlockTime(uint256 newUnlockTime) external override onlyOwner {
	_checkLocks();

        emit LogTimeLock(msg.sender, unlockTime, newUnlockTime);
        unlockTime = newUnlockTime;
    }

    /**
     * @dev Set NFT lock
     * @param newLock New nftLock setting
     */
    function setNftLock(bool newLock) external override onlyOwner {
	_checkLocks();

	emit LogNftLock(msg.sender, nftLock, newLock);
	nftLock = newLock;
    }

    /**
     * @dev Withdraw ETH
     * @param amount Amount of asset to withdraw
     */
    function withdrawETH(uint256 amount) external override onlyOwner {
	_checkLocks();

        uint256 assetBalance;

        // ascertain available balance
        address self = address(this); // workaround for a possible solidity bug
        assetBalance = self.balance;

        // handle withdraw-all
        if (amount == uint256(-1)) {
            amount = assetBalance;
        }
        require(amount <= assetBalance, "Asset amount < Asset balance");

        // transfer to owner
        msg.sender.transfer(amount);

        // log activity
        emit LogWithdraw(msg.sender, address(0), assetBalance);
    }

    /**
     * @dev Withdraw ERC20 asset.
     * @param _assetAddress Asset to be withdrawn.
     * @param amount Amount of asset to withdraw
     */
    function withdrawErc20(address _assetAddress, uint256 amount) external override onlyOwner {
	_checkLocks();

        uint256 assetBalance;

        // ascertain available balance
        assetBalance = ERC20(_assetAddress).balanceOf(address(this));

        // handle withdraw-all
        if (amount == uint256(-1)) {
            amount = assetBalance;
        }
        require(amount <= assetBalance, "Asset amount < Asset balance");

        // transfer to owner
        ERC20(_assetAddress).safeTransfer(msg.sender, amount);

        // log activity
        emit LogWithdraw(msg.sender, _assetAddress, assetBalance);
    }

    /////////////////////////////////////////////////////////////

    function _checkLocks() internal view {
        require(block.timestamp >= unlockTime, "Contract is time-locked");
	require(!nftLock || !_nftOwned(), "NFT locked");
    }
}
