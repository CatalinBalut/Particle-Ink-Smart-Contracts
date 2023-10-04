// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {
    ERC721ContractMetadataUpgradeable
} from "./ERC721ContractMetadataUpgradeable.sol";

import {
    ISeaDropTokenContractMetadataUpgradeable
} from "./interfaces/ISeaDropTokenContractMetadataUpgradeable.sol";

import {SlotGenerator} from './Ethereum/libraries/SlotGenerator.sol';

library ERC721ContractMetadataStorage {
    struct Layout {
        /// @notice Track the max supply.
        uint256 _maxSupply;
        /// @notice Track the base URI for token metadata.
        string _tokenBaseURI;
        /// @notice Track the contract URI for contract metadata.
        string _contractURI;
        /// @notice Track the provenance hash for guaranteeing metadata order
        ///         for random reveals.
        bytes32 _provenanceHash;
        /// @notice Track the royalty info: address to receive royalties, and
        ///         royalty basis points.
        ISeaDropTokenContractMetadataUpgradeable.RoyaltyInfo _royaltyInfo;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256("openzepplin.contracts.storage.ERC721ContractMetadata");

    function layout() internal view returns (Layout storage l) {
        bytes memory concatenatedBytes = abi.encodePacked(STORAGE_SLOT, SlotGenerator.luminSlot().collectionName[msg.sender]);
        bytes32 slot = keccak256(concatenatedBytes);
        assembly {
            l.slot := slot
        }
    }
}
