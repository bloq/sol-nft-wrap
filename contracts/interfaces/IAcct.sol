
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

interface IAcct {
    event LogWithdraw(address indexed _from, address indexed _assetAddress, uint256 amount);

    function withdrawETH(uint256 amount) external;
    function withdrawErc20(address _assetAddress, uint256 amount) external;
}
