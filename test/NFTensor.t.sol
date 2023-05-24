// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "solmate/tokens/ERC20.sol";
import "src/NFTensor.sol";

contract TestContract is Test {
    NFTensor nft;
    address owner;
    address wtaoAddress;
    ERC20 wtao;

    function setUp() public {
        nft = new NFTensor();
        owner = 0xB95777719Ae59Ea47A99e744AfA59CdcF1c410a1;
        wtaoAddress = 0x77E06c9eCCf2E797fd462A92B6D7642EF85b0A44;
        wtao = ERC20(wtaoAddress);
    }

    function testMint() public { }

    function testQueriesAreStoredCorrectly(string memory query) public {
        nft.mint(query);
        uint256 tokenId = nft.tokenID();
        string memory queryFromContract = nft.queries(tokenId);
        assertEq(query, queryFromContract);
    }

    // see gas snapshot
    function testRandomMintStringsForGas(string memory query) public {
        nft.mint(query);
    }

    function testSpecifiedMintStringsForGas() public {
        string memory queryOne = "What is the capital of France?";
        nft.mint(queryOne);

        string memory queryTwo = "What is a rigid designator?";
        nft.mint(queryTwo);

        string memory queryThree =
            "Liguistically, what would frege call the sense and reference of the terms hesperus and phosphorus?";

        nft.mint(queryThree);

        string memory queryFour = "Please explain the twin prime conjecture as childishly as possible.";
        nft.mint(queryFour);
    }

    // test minting is impossible after the minting period ends
    function testMintingPeriodOver() public { }

    // test transfer of wTAO deducts the correct amount of tokens
    function testWTAOMintPrice() public { }

    // test minting is impossible after all NFTs are minted
    function testAllNFTsMinted() public { }

    // test that the tokenURI is set correcty
    function testTokenURIString() public { }

    // test tokenURI can be updated correctly
    function testTokenURIUpdate() public { }

    // test that the owner can withdraw wTAO
    function testWithdraw() public { }

    // test mint fails without token approval
    function testMintRequiresWTAOApproval() public { }

    // test mint fails without sufficient wTAO
    function testMintRequiresSufficientWTAO() public { }
}
