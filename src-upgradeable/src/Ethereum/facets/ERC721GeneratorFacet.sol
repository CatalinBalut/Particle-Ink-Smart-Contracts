// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC721Facade} from '../facades/ERC721Facade.sol';
import {IERC721Facet} from '../interfaces/IERC721Facet.sol';

import {LibERC721GeneratorStorage, ERC721CollectionConfig, ERC721Collection} 
from '../libraries/LibERC721GeneratorStorage.sol';

import {SlotGenerator} 
from '../libraries/SlotGenerator.sol';

import {ERC721SeaDropUpgradeable} from '../../ERC721SeaDropUpgradeable.sol';

import 'hardhat/console.sol';

contract ERC721GeneratorFacet is ERC721SeaDropUpgradeable, IERC721Facet {
    using LibERC721GeneratorStorage for LibERC721GeneratorStorage.Layout;
    using SlotGenerator for SlotGenerator.LuminSlot;
    /**
     * @notice A token can only be burned by the set burn address.
     */
    error BurnIncorrectSender();

    /**
     * @notice Initialize the token contract with its name, symbol,
     *         and allowed SeaDrop addresses.
     */
    function init(
    ) external initializer initializerERC721A {
        ERC721SeaDropUpgradeable.__ERC721SeaDrop_init_once();
    }

    function erc721DeployCollection(string memory name, string memory symbol, address[] memory allowedSeaDrop) external{
        //enforce ownership
        //if libstring...
        SlotGenerator.createCollectionSlot(name, msg.sender);

        ERC721Collection storage t = LibERC721GeneratorStorage.layout().erc721;

        ERC721SeaDropUpgradeable.__ERC721SeaDrop_init(name, symbol, allowedSeaDrop);

        //TODO should i use this?
        //ERC721SeaDropUpgradeable.__ERC721SeaDrop_init(name, symbol, allowedSeaDrop);
    }

    //user -call> facade.sol -call> diamond -delegatecall-> ERC721GeneratorFacet (msg.sender ==facade.address) -> name(facade->)
    //diamond -> nft1facet -> tokenURI()
    //diamond -> nft2facet -> tokenURI()
    function erc721Name() external view returns (string memory){
        return LibERC721GeneratorStorage.layout().erc721.name;
    }

    function erc721Symbol() external view returns (string memory){
        return LibERC721GeneratorStorage.layout().erc721.symbol;
    }

    function erc721TokenURI(uint256 tokenId) public view returns (string memory){
        return LibERC721GeneratorStorage.layout().erc721.tokenURI;
    }

    function erc721BalanceOf(address owner) external view returns(uint256 balanace) {
        return 1;
    }

    function erc721OwnerOf(uint256 tokenId) external view returns (address owner){
        return msg.sender;
    }

    function erc721SafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{
    }

    function erc721SafeTransferFrom(address from, address to, uint256 tokenId) external{

    }

    function erc721TransferFrom(address from, address to, uint256 tokenId) external{

    }

    function erc721Approve(address to, uint256 tokenId) external{

    }
    function erc721SetApprovalForAll(address operator, bool approved) external{

    }

    function erc721GetApproved(uint256 tokenId) external view returns (address operator){
        return msg.sender;

    }

    function erc721IsApprovedForAll(address owner, address operator) external view returns (bool){
        return true;

    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        super.supportsInterface(interfaceId);
    }

}