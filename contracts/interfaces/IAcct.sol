// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

interface IAcct {
    event LogWithdraw(address indexed _from, address indexed _assetAddress, uint256 amount);
    event LogTimeLock(address indexed _from, uint256 oldTime, uint256 newTime);

    function setUnlockTime(uint256 newUnlockTime) external;

    function transferOwnershipToNFT() external;

    function withdrawETH(uint256 amount) external;

    function withdrawERC20(address _assetAddress, uint256 amount) external;
}
