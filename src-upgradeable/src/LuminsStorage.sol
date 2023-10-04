// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;


library LuminsStorage {
    struct Layout {
        bool signer;
        bool pauseBridge;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256("seaDrop.contracts.storage.lumins");

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}