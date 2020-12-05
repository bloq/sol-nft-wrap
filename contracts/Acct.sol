// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

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
        require(block.timestamp >= unlockTime, "Contract is time-locked");
        _;
    }

    /**
     * @dev Set unlock time
     * @param newUnlockTime Absolute time at which contract is unlocked
     */
    function setUnlockTime(uint256 newUnlockTime) external override onlyOwner isUnlocked {
        emit LogTimeLock(msg.sender, unlockTime, newUnlockTime);
        unlockTime = newUnlockTime;
    }

    /**
     * @dev Transfer ownership control to NFT registry
     */
    function transferOwnershipToNFT() external override onlyOwner {
        IOwnerRegistry(REGISTRY_ADDR).mint(address(this));
        transferOwnership(REGISTRY_ADDR);
    }

    /**
     * @dev Withdraw ETH
     * @param amount Amount of asset to withdraw
     */
    function withdrawETH(uint256 amount) external override onlyOwner isUnlocked {
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
    function withdrawErc20(address _assetAddress, uint256 amount) external override onlyOwner isUnlocked {
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
}
