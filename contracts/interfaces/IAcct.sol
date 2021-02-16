// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

interface IAcct {
    event LogWithdraw(address indexed _from, address indexed _assetAddress, uint256 amount);
    event LogWithdrawNFT(address indexed _from, address indexed _assetAddress, uint256 tokenId);
    event LogTimeLock(address indexed _from, uint256 oldTime, uint256 newTime);

    function setUnlockTime(uint256 newUnlockTime) external;

    function transferOwnershipToNFT(address registry) external;

    function withdrawAllETH() external;

    function withdrawETH(uint256 amount) external;

    function withdrawAllERC20(address _assetAddress) external;

    function withdrawERC20(address _assetAddress, uint256 amount) external;

    function depositERC721(address _tokenAddress, uint256 _tokenId) external;

    function withdrawERC721(address _tokenAddress, uint256 _tokenId) external;
}
