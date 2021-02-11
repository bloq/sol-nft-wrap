// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./interfaces/IAcct.sol";
import "./interfaces/IOwnerRegistry.sol";

/**
    Acct:  an abstract shell for ETH and ERC20 assets.

    The intended use of Acct is to be filled with assets.   Those
    assets may then be transferred to other owner(s), according to
    owner-specified rules.

    An Acct may be owned by an Ethereum EOA, a smart contract such as
    Gnosis Safe, or an NFT such as the provided Owner/OwnerRegistry,
    which uses a simple "token ID = contract address" mechanism
    via ERC721.

 */

contract Acct is Ownable, IAcct {
    using SafeERC20 for ERC20;

    uint256 public unlockTime;

    address private constant REGISTRY_ADDR = address(0x0);

    constructor(address owner) public {
        transferOwnership(owner);
    }

    modifier isUnlocked() {
        require(block.timestamp >= unlockTime, "Acct: time-locked");
        _;
    }

    receive() external payable {}

    /**
     * @dev Set unlock time
     * @param newUnlockTime Absolute time at which contract is unlocked
     */
    function setUnlockTime(uint256 newUnlockTime) external override onlyOwner isUnlocked {
        emit LogTimeLock(_msgSender(), unlockTime, newUnlockTime);
        unlockTime = newUnlockTime;
    }

    /**
     * @dev Transfer ownership control to NFT registry
     */
    function transferOwnershipToNFT() external override onlyOwner {
        transferOwnershipToNFT(REGISTRY_ADDR);
    }

    function transferOwnershipToNFT(address registry) public onlyOwner {
        address originalOwner = owner();
        transferOwnership(address(registry));
        IOwnerRegistry(registry).mintTo(address(this), originalOwner);
    }

    /**
     * @dev Withdraw ETH
     * @param amount Amount of asset to withdraw
     */
    function withdrawETH(uint256 amount) external override onlyOwner isUnlocked {
        // ascertain available balance
        address self = address(this); // workaround for a possible solidity bug
        uint256 assetBalance = self.balance;

        // handle withdraw-all
        if (amount == uint256(-1)) {
            amount = assetBalance;
        }
        // the following line is not strictly necessary, the transfer would fail anyways
        require(amount <= assetBalance, "Acct: transfer amount exceeds balance");

        // transfer to owner
        address payable msgSender = _msgSender();
        msgSender.transfer(amount);

        // log activity
        emit LogWithdraw(msgSender, address(0), amount);
    }

    /**
     * @dev Withdraw ERC20 asset.
     * @param _assetAddress Asset to be withdrawn.
     * @param amount Amount of asset to withdraw
     */
    function withdrawERC20(address _assetAddress, uint256 amount) external override onlyOwner isUnlocked {
        // ascertain available balance
        uint256 assetBalance = ERC20(_assetAddress).balanceOf(address(this));

        // handle withdraw-all
        if (amount == uint256(-1)) {
            amount = assetBalance;
        }
        // the following line is unnecessary because ERC20 transfer would fail anyways
        require(amount <= assetBalance, "Acct: transfer amount exceeds balance");

        // transfer to owner
        address msgSender = _msgSender();
        ERC20(_assetAddress).safeTransfer(msgSender, amount);

        // log activity
        emit LogWithdraw(msgSender, _assetAddress, amount);
    }
}
