// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.6;

interface INFTOwnable {
    function NFTCanOwn() external view returns (bool);

    function owner() external view returns (address);

    function nftRegistry() external view returns (address);

    function nftOwned() external view returns (bool);

    function nftOwner() external view returns (address);
}
