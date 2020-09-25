
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

interface IAcct {
    event LogWithdraw(address indexed _from, address indexed _assetAddress, uint256 amount);
    event LogTimeLock(address indexed _from, uint256 oldTime, uint256 newTime);
    event LogNftLock(address indexed _from, bool nftLock, bool newLock);

    function setNftLock(bool newLock) external;
    function setUnlockTime(uint256 newUnlockTime) external;
    function withdrawETH(uint256 amount) external;
    function withdrawErc20(address _assetAddress, uint256 amount) external;
}
