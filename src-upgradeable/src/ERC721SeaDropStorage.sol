// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {SlotGenerator} from './Ethereum/libraries/SlotGenerator.sol';

library ERC721SeaDropStorage {
    struct Layout {
        /// @notice Track the allowed SeaDrop addresses.
        mapping(address => bool) _allowedSeaDrop;
        /// @notice Track the enumerated allowed SeaDrop addresses.
        address[] _enumeratedAllowedSeaDrop;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256("openzepplin.contracts.storage.ERC721SeaDrop");

    function layout() internal view returns (Layout storage l) {
        bytes memory concatenatedBytes = abi.encodePacked(STORAGE_SLOT, SlotGenerator.luminSlot().collectionName[msg.sender]);
        bytes32 slot = keccak256(concatenatedBytes);
        assembly {
            l.slot := slot
        }
    }
}

