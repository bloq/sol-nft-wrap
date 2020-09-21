
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
import './NFTOwnable.sol';

/**
    Acct:  an abstract shell for ETH and ERC20 assets.

    The intended use of Acct is to be filled with assets.   Those
    assets may then be transferred to other owner(s), according to
    owner-specified rules.

    An Acct may be owned by an Ethereum EOA, a smart contract such as
    Gnosis Safe, or an NFT such as the provided OwnerRegistry, which
    uses a simple "token ID = contract address" mechanism via ERC721.

 */

contract Acct is NFTOwnable {
    using SafeERC20 for ERC20;
    address constant ETHER = address(0);

    event LogWithdraw(address indexed _from, address indexed _assetAddress, uint256 amount);

    /**
     * @dev Withdraw asset.
     * @param _assetAddress Asset to be withdrawn.
     * @param amount Amount of asset to withdraw
     */
    function withdraw(address _assetAddress, uint256 amount) public onlyOwner {
	bool isEther = (_assetAddress == ETHER);
        uint256 assetBalance;

	// ascertain available balance
        if (isEther) {
            address self = address(this); // workaround for a possible solidity bug
            assetBalance = self.balance;
        } else {
            assetBalance = ERC20(_assetAddress).balanceOf(address(this));
        }

	// handle withdraw-all
	if (amount == uint256(-1)) {
	    amount = assetBalance;
	}
	require(amount <= assetBalance, "Asset amount < Asset balance");

	// transfer to owner
	if (isEther) {
            msg.sender.transfer(amount);
	} else {
            ERC20(_assetAddress).safeTransfer(msg.sender, amount);
	}

	// log activity
        emit LogWithdraw(msg.sender, _assetAddress, assetBalance);
    }
}
