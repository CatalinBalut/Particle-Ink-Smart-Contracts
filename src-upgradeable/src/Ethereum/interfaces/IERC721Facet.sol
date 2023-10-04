// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct ERC721CollectionConfig {
    string name;
    string symbol;
    string tokenURI;
}

interface IERC721Facet{

    function erc721DeployCollection(string memory name, string memory symbol, address[] memory allowedSeaDrop) external;

    //IERC721 Metadata//

    function erc721Name() external view returns (string memory);

    function erc721Symbol() external view returns (string memory);

    function erc721TokenURI(uint256 tokenId) external view returns (string memory);

    //IERC721 Metadata//

    function erc721BalanceOf(address owner) external view returns(uint256 balanace);

    function erc721OwnerOf(uint256 tokenId) external view returns (address owner);

    function erc721SafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    function erc721SafeTransferFrom(address from, address to, uint256 tokenId) external;

    function erc721TransferFrom(address from, address to, uint256 tokenId) external;

    function erc721Approve(address to, uint256 tokenId) external;

    function erc721SetApprovalForAll(address operator, bool approved) external;

    function erc721GetApproved(uint256 tokenId) external view returns (address operator);

    function erc721IsApprovedForAll(address owner, address operator) external view returns (bool);

}