// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


library SlotGenerator {

    bytes32 internal constant LUMIN_STORAGE = keccak256("lumins.storage");

    struct LuminSlot{
        mapping(address => bytes32) collectionName;
    }

    function luminSlot() internal pure returns (LuminSlot storage s){
        bytes32 storageSlot = LUMIN_STORAGE;
        assembly {
            s.slot := storageSlot
        }
    }

    function createCollectionSlot(string memory name, address facade) internal {
        bytes32 NEW_STORAGE_SLOT = keccak256(abi.encode(name));
        SlotGenerator.luminSlot().collectionName[facade] = NEW_STORAGE_SLOT;
    }
}