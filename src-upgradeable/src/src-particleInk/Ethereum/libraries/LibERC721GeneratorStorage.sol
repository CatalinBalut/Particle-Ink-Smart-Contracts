// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import {ERC721AStorage} from '../../../../../src-upgradeable/contracts/ERC721AStorage';

import {ERC721ContractMetadataStorage} from '../../../ERC721ContractMetadataStorage.sol';
import {ERC721SeaDropStorage} from '../../../ERC721SeaDropStorage.sol';

struct ERC721CollectionConfig {
    string name;
    string symbol;
    string tokenURI;
}

struct ERC721Collection {
    string name;
    string symbol;
    string tokenURI;
    
    ERC721ContractMetadataStorage.Layout metadataStorage;
    ERC721SeaDropStorage.Layout seaDropStorage;
    
}

library LibERC721GeneratorStorage {
    struct Layout {
        /// @notice The only address that can burn tokens on this contract.
        address burnAddress;
        mapping(address => ERC721Collection) erc721s;
    }

    //mapping facade->storageslot(keccak256(nume diferit)
    bytes32 internal constant STORAGE_SLOT =
        keccak256("seaDrop.contracts.storage.exampleToken");

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
