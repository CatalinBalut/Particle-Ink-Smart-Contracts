const { expect, assert } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
// const { ethers } = require("ethers");
const chainId = hre.network.config.chainId

const {
  getSelectors,
  FacetCutAction,
  removeSelectors,
  findAddressPositionInFacets
} = require('../scripts/diamond')

const { deployDiamond } = require('../scripts/deploy.js')

describe.only("Particle INK - Lumins", function () {
  async function deployTokenFixture() {
    let diamondAddress, diamondCutFacet, diamondLoupeFacet, ownershipFacet, luminsNFTFacet;
    const [deployer, add1, add2, signer] = await ethers.getSigners();
  
    diamondAddress = await deployDiamond()
    diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress)
    diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress)
    ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
  
    const LibLStorage = await ethers.getContractFactory("LibERC721GeneratorStorage");
    const libLStorage = await LibLStorage.deploy();
    await libLStorage.deployed();
  
    const LuminsNFT = await ethers.getContractFactory("ERC721GeneratorFacet");
    luminsNFTFacet = await LuminsNFT.deploy();
    await luminsNFTFacet.deployed();
  
    const addresses = [];
    addresses.push(luminsNFTFacet.address)
    const selectors = getSelectors(luminsNFTFacet)
    // console.log("selectors:", selectors);

    ///////////////////////////////////////////////////////////////

    const luminsNFTFacetSelectors = getSelectors(luminsNFTFacet);

    const diamondCutFacetSelectors = getSelectors(diamondCutFacet);
    const diamondLoupeFacetSelectors = getSelectors(diamondLoupeFacet);
    const ownershipFacetSelectors = getSelectors(ownershipFacet);
    
    const allSelectors = [
      luminsNFTFacetSelectors,
      diamondCutFacetSelectors,
      diamondLoupeFacetSelectors,
      ownershipFacetSelectors,
    ];
    
    const hasDuplicateSelectors = allSelectors.some((selectors) => {
      return selectors.some((selector) => {
        return allSelectors.filter((otherSelectors) => selectors !== otherSelectors).some((otherSelectors) => selector === otherSelectors);
      });
    });
    
    if (hasDuplicateSelectors) {
      console.log("There are duplicate selectors");
    } else {
      console.log("There are no duplicate selectors");
    }

    ///////////////////////////////////////////////////////////////
  
  
    tx = await diamondCutFacet.diamondCut(
      [{
        facetAddress: luminsNFTFacet.address,
        action: FacetCutAction.Add,
        functionSelectors: selectors
      }],
      ethers.constants.AddressZero, '0x', { gasLimit: 8000000 })
    receipt = await tx.wait()
    if (!receipt.status) {
      throw Error(`Diamond upgrade failed: ${tx.hash}`)
    }
    result = await diamondLoupeFacet.facetFunctionSelectors(luminsNFTFacet.address)
    assert.sameMembers(result, selectors)
  
    //Initialize the Lumin Facet with predefined values
    // luminsNFTFacet = await ethers.getContractAt('ERC721GeneratorFacet', diamondAddress);
    // await luminsNFTFacet.initialize();
  
    return {luminsNFTFacet, deployer, add1, diamondAddress };
  }

  //deployer is the standard receiver
  //1000 is the standard fee => 10%

  it.only('Should change royalty', async () => {
    const {luminsNFTFacet, deployer, diamondAddress} = await loadFixture(deployTokenFixture);
    console.log('hi')
    // const ERC721Facade = await ethers.getContractFactory("ERC721Facade");
    // const erc721Facade = await ERC721Facade.deploy(diamondAddress);
    // await erc721Facade.deployed();

    // // let x = await luminsNFTFacet.erc721TokenURI(1);
    // // console.log("diamond adress", diamondAddress)
    // let x = await erc721Facade.tokenURI(1)
    // console.log(x);
    const selectors = getSelectors(luminsNFTFacet);


    });

    

});
