// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/utils/cryptography/SignatureCheckerUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";

import {ERC721SeaDropUpgradeable} from "./ERC721SeaDropUpgradeable.sol";
import {LuminsStorage} from "./LuminsStorage.sol";

/*
 * @notice This contract uses ERC721PartnerSeaDrop,
 *         an ERC721A token contract that is compatible with SeaDrop.
 *         The set burn address is the only sender that can burn tokens.
 */
contract LuminsFacet is ERC721SeaDropUpgradeable {
    using LuminsStorage for LuminsStorage.Layout;

    /**
     * @notice Initialize the token contract with its name, symbol
     *         and allowed SeaDrop addresses.
     */
    function initialize(
        string memory name,
        string memory symbol,
        address administrator,
        address[] memory allowedSeaDrop
    ) external initializer initializerERC721A {
        ERC721SeaDropUpgradeable.__ERC721SeaDrop_init(
            name,
            symbol,
            allowedSeaDrop
        );
        //TODO: NFT configuration
    }

    // =============================================================
    //                       BRIDGE PART
    // =============================================================

    event BridgeMint(address indexed, address indexed, uint256, uint256);
    event BridgeBurn(address indexed, address indexed, uint256, uint256);

    function setBridgePause(bool _pauseBridge) external onlyOwner {
        LuminsStorage.layout().pauseBridge = _pauseBridge;
    }

    function getBridgePause() external view returns (bool) {
        return LuminsStorage.layout().pauseBridge;
    }

    function bridgeMint(address account, uint256 tokenIDBurned, bytes memory signature) external nonReentrant {
        require(LuminsStorage.layout().pauseBridge, "Lumins: Bridge is paused");
        require(validateSignature(account, tokenIDBurned, signature), "Lumins: invalid signature");

        _safeMint(msg.sender, 1);
        uint256 currentTotalSupply;
        ( ,currentTotalSupply, ) = getMintStats(msg.sender);
        emit BridgeMint(account, msg.sender, tokenIDBurned, currentTotalSupply);
    }

    function bridgeBurn(uint256 tokenID, address receiverAddress, uint256 targetChainId) public nonReentrant {
        require(LuminsStorage.layout().pauseBridge, "Lumins: Bridge is paused");

        super._burn(tokenID);

        emit BridgeBurn(msg.sender, receiverAddress, tokenID, targetChainId);
    }

    function validateSignature(address account, uint256 tokenID, bytes memory signature) public view returns (bool) {
        //TODO fix hash inheritance
        // bytes32 _hash = super._hashTypedDataV4(
        //     keccak256(
        //         abi.encode(
        //             keccak256("SignatureValidation(address verifyingContract,address account,address msgSender,uint256 tokenID)"),
        //             address(this),
        //             account,
        //             msg.sender,
        //             tokenID
        //         )
        //     )
        // );
        // return ERC721SeaDropUpgradeable.SignatureCheckerUpgradeable.isValidSignatureNow(LuminsStorage.layout().signer, _hash, signature);
    }

}
