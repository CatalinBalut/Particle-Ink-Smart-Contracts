// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import {ERC721AStorage} from '../../../../../src-upgradeable/contracts/ERC721AStorage';

import {ERC721ContractMetadataStorage} from '../../../ERC721ContractMetadataStorage.sol';
import {ERC721SeaDropStorage} from '../../../ERC721SeaDropStorage.sol';

import {SlotGenerator} from './SlotGenerator.sol';

import "hardhat/console.sol";

struct ERC721CollectionConfig {
    string name;
    string symbol;
    string tokenURI;
}

struct ERC721Collection {
    bytes32 STORAGE_SLOT;
    
    string name;
    string symbol;
    string tokenURI;
    
    ERC721ContractMetadataStorage.Layout metadataStorage;
    // ERC721SeaDropStorage.Layout seaDropStorage;
    
}

library LibERC721GeneratorStorage {

    struct Layout {
        //optimization: ERC721Collection erc721
        mapping(address => ERC721Collection) erc721s;
    }

    function layout() internal view returns (Layout storage l) {
        bytes32 slot = SlotGenerator.luminSlot().collectionName[msg.sender];
        assembly {
            l.slot := slot
        }
    }

    function getName(address facade) internal view returns (string memory) {
        ERC721Collection storage collection = LibERC721GeneratorStorage.layout().erc721s[facade];
        return collection.name;
    }

}