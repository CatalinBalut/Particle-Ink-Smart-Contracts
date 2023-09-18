// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC721Facet{

    //IERC721 Metadata//

    function erc721Name(address facet) external view returns (string memory);

    function erc721Symbol(address facet) external view returns (string memory);

    function tokenURI(address facet, uint256 tokenId) external view returns (string memory);

    //IERC721 Metadata//

    function erc721BalanceOf(address facet, address owner) external view returns(uint256 balanace);

    function erc721OwnerOf(address facet, uint256 tokenId) external view returns (address owner);

    function erc721SafeTransferFrom(address facet, address from, address to, uint256 tokenId, bytes calldata data) external;

    function erc721SafeTransferFrom(address facet, address from, address to, uint256 tokenId) external;

    function erc721TransferFrom(address facet, address from, address to, uint256 tokenId) external;

    function erc721Approve(address facet, address to, uint256 tokenId) external;

    function erc721SetApprovalForAll(address facet, address operator, bool approved) external;

    function erc721GetApproved(address facet, uint256 tokenId) external view returns (address operator);

    function erc721IsApprovedForAll(address facet, address owner, address operator) external view returns (bool);

}