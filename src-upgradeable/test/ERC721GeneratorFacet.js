const { expect, assert } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
// const { ethers } = require("ethers");
const chainId = hre.network.config.chainId

function diffSelectrors(){
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
}

const {
  getSelectors,
  FacetCutAction,
  removeSelectors,
  findAddressPositionInFacets
} = require('../scripts/diamond.js')

const { deployDiamond } = require('../scripts/deploy.js')

describe.only("Particle INK - Lumins", function () {
  async function deployTokenFixture() {
    let diamondAddress, diamondCutFacet, diamondLoupeFacet, ownershipFacet, luminsNFTFacet;
    const [deployer, add1, add2, signer] = await ethers.getSigners();
  
    console.log("AAAAAAAAAAAAAAA")
    diamondAddress = await deployDiamond()
    console.log("AAAAAAAAAAAAAAA")

    diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress)
    diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress)
    ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
    console.log("BBBBBBBBBBBBBB")
    const LibLStorage = await ethers.getContractFactory("LibERC721GeneratorStorage");
    const libLStorage = await LibLStorage.deploy();
    await libLStorage.deployed();
    console.log("CCCCCCCCCCCCCCCCC")
    const LuminsNFT = await ethers.getContractFactory("ERC721GeneratorFacet");
    luminsNFTFacet = await LuminsNFT.deploy();
    await luminsNFTFacet.deployed();
    console.log("DDDDDDDDDDDDDDd")
    const addresses = [];
    addresses.push(luminsNFTFacet.address)
    const selectors = getSelectors(luminsNFTFacet)
    // console.log("selectors:", selectors);

    tx = await diamondCutFacet.diamondCut(
      [{
        facetAddress: luminsNFTFacet.address,
        action: FacetCutAction.Add,
        functionSelectors: selectors.remove(['supportsInterface(bytes4)'])
      }],
      ethers.constants.AddressZero, '0x', { gasLimit: 8000000 })
    receipt = await tx.wait()
    if (!receipt.status) {
      throw Error(`Diamond upgrade failed: ${tx.hash}`)
    }
    result = await diamondLoupeFacet.facetFunctionSelectors(luminsNFTFacet.address)
    assert.sameMembers(result, selectors.remove(['supportsInterface(bytes4)']))
  
    // Initialize the Lumin Facet with predefined values
    luminsNFTFacet = await ethers.getContractAt('ERC721GeneratorFacet', diamondAddress);
    // await luminsNFTFacet.initialize("a","b",[deployer.address]);
  
    return {luminsNFTFacet, deployer, add1, diamondAddress };
  }

  //deployer is the standard receiver
  //1000 is the standard fee => 10%

  it('Should change royalty', async () => {
    const {luminsNFTFacet, deployer, diamondAddress} = await loadFixture(deployTokenFixture);
    console.log('hi')
    const ERC721Facade = await ethers.getContractFactory("ERC721Facade");

    const erc721Facade1 = await ERC721Facade.deploy(diamondAddress);
    await erc721Facade1.deployed();
    await luminsNFTFacet.erc721DeployCollection(erc721Facade1.address, "a",["a","a","a"]);

    let x = await erc721Facade1.name()
    let y = await luminsNFTFacet.erc721Namee(erc721Facade1.address);
    console.log("erc721Namee:", y);
    // console.log("XXXXXXXXXXXX", x);
    // console.log("facade1 address ",erc721Facade1.address);

    const erc721Facade2 = await ERC721Facade.deploy(diamondAddress);
    await erc721Facade2.deployed()
    await luminsNFTFacet.erc721DeployCollection(erc721Facade2.address, "b",["b","b","b"]);


    console.log("facade 1 name after:", await erc721Facade1.name());
    console.log("facade 2 name after: ", await erc721Facade2.name());
    // // let x = await luminsNFTFacet.erc721TokenURI(1);
    // // console.log("diamond adress", diamondAddress)
    // let x = await erc721Facade1.name()
    // console.log("XXXXXXXXXXXX", x);

    });

    it.only('Should deploy multiple colellections', async () => {
      const {luminsNFTFacet, deployer, diamondAddress} = await loadFixture(deployTokenFixture);
      
      const ERC721Facade = await ethers.getContractFactory("ERC721Facade");

      const erc721Facade1 = await ERC721Facade.deploy(diamondAddress);
      await erc721Facade1.deployed();
      
      const erc721Facade2 = await ERC721Facade.deploy(diamondAddress);
      await erc721Facade2.deployed()

      await luminsNFTFacet.init();

      //TODO fix the initializer to work with this storage arhitecture
      //note: the idea was to separate the initializer in 2: one for
      //functions like reentrancy, one for collection initializer.

      // await erc721Facade1.deployCollection("ABC","A",[diamondAddress])
      
      // await erc721Facade2.deployCollection("XYZ","X",[diamondAddress])
      // console.log("erc721Facade1.erc721Name: ", await erc721Facade1.name());
      // // console.log("erc721Facade2.erc721Name: ", await erc721Facade2.name());
      
      });

});
