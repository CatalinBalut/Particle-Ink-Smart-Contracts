// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";
import {IERC721Metadata} from "@openzeppelin/contracts/interfaces/IERC721Metadata.sol";
import {IERC721Facet} from "../interfaces/IERC721Facet.sol";

import "hardhat/console.sol";

contract ERC721Facade is IERC721, IERC721Metadata {

    IERC721Facet public facet;

    constructor(IERC721Facet _facet) {
        facet = _facet;

    }

    function name() external view returns (string memory){
        return facet.erc721Name(address(this));
    }

    function symbol() external view returns (string memory){
        return facet.erc721Symbol(address(this));
    }

    function tokenURI(uint256 tokenId) external view returns (string memory){
        return facet.tokenURI(address(this), tokenId);
    }

    function balanceOf(address owner) external view override returns (uint256 balanace) {
        return facet.erc721BalanceOf(address(this), owner);
    }

    function ownerOf(uint256 tokenId) external view override returns (address owner) {
        return facet.erc721OwnerOf(address(this), tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external override {
        return facet.erc721SafeTransferFrom(address(this), from, to, tokenId, data);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external override {
        return facet.erc721SafeTransferFrom(address(this), from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) external override {
        return facet.erc721TransferFrom(address(this), from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) external override {
        return facet.erc721Approve(address(this), to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external override {
        return facet.erc721SetApprovalForAll(address(this), operator, approved);
    }

    function getApproved(uint256 tokenId) external view override returns (address operator) {
        return facet.erc721GetApproved(address(this), tokenId);
    }

    function isApprovedForAll(address owner, address operator) external view override returns (bool) {
        return facet.erc721IsApprovedForAll(address(this), owner, operator);
    }

    function supportsInterface(bytes4 interfaceId) external view override returns (bool) {}
}