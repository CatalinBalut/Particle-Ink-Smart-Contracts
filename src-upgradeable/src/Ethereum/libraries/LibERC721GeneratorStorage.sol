// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import {ERC721AStorage} from '../../../../../src-upgradeable/contracts/ERC721AStorage';

import {ERC721ContractMetadataStorage} from '../../ERC721ContractMetadataStorage.sol';
import {ERC721SeaDropStorage} from '../../ERC721SeaDropStorage.sol';
import '../../lib/SeaDropStructsUpgradeable.sol';
import '../../lib/ERC721SeaDropStructsErrorsAndEventsUpgradeable.sol';

import {SlotGenerator} from './SlotGenerator.sol';

import "hardhat/console.sol";

struct ERC721CollectionConfig {
    string name;
    string symbol;
    string tokenURI;
}

struct ERC721Collection {
    //I can move all the structs inside this struct and it should work
    //or
    //I can concat the storage slot keccak of each storage with the generator.
    string name;
    string symbol;
    string tokenURI;
    
    ERC721ContractMetadataStorage.Layout metadataStorage;
    ERC721SeaDropStorage.Layout seaDropStorage;
    
}

library LibERC721GeneratorStorage {

    struct Layout {
        // mapping(address => ERC721Collection) erc721s;
        ERC721Collection erc721;
    }

    function layout() internal view returns (Layout storage l) {
        bytes32 slot = SlotGenerator.luminSlot().collectionName[msg.sender];
        assembly {
            l.slot := slot
        }
    }

}