// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/NFTensor.sol";
import { wTAO } from "test/wtao/wTAO.sol";

contract TestContract is Test {
    uint256 constant MINT_PRICE = 1e9;
    NFTensor nft;
    address owner;
    address wtaoAddress;
    address minter;
    address wtaoBridgeAddress;
    wTAO wtao;

    function setUp() public {
        nft = new NFTensor();
        owner = 0xB95777719Ae59Ea47A99e744AfA59CdcF1c410a1;
        minter = address(0xc0ffee);
        wtaoAddress = 0x77E06c9eCCf2E797fd462A92B6D7642EF85b0A44;
        wtaoBridgeAddress = 0x5DB4b98e3deF62f0fce1267Db1d77639C43C3B14;
        wtao = wTAO(wtaoAddress);
    }

    // check storage to tokenID is proper
    function testQueriesAreStoredCorrectly(string memory query) public {
        if (bytes(query).length == 0) {
            return;
        }
        getTAO(minter, MINT_PRICE);
        vm.startPrank(minter);
        wtao.approve(address(nft), MINT_PRICE);
        nft.mint(query);
        uint256 tokenID = nft.tokenID();
        string memory queryFromContract = nft.queries(tokenID);
        assertEq(query, queryFromContract);
    }

    // see gas snapshot
    function testRandomMintStringsForGas(string memory query) public {
        if (bytes(query).length == 0) {
            return;
        }
        getTAO(minter, MINT_PRICE);
        vm.startPrank(minter);
        wtao.approve(address(nft), MINT_PRICE);
        nft.mint(query);
    }

    // test various strings for more calls to gas
    function testSpecifiedMintStringsForGas() public {
        getTAO(minter, MINT_PRICE * 4);
        vm.startPrank(minter);
        wtao.approve(address(nft), MINT_PRICE * 4);

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
    function testMintingPeriodOver() public {
        vm.startPrank(minter);
        vm.warp(block.timestamp + 6 days);
        vm.expectRevert(NFTensor.MintingPeriodOver.selector);
        nft.mint("What is the capital of France?");
    }

    // test minting is impossible after all NFTs are minted
    function testAllNFTsMinted() public {
        getTAO(minter, MINT_PRICE * 501);

        vm.startPrank(minter);
        for (uint256 i = 0; i < 500; i++) {
            wtao.approve(address(nft), MINT_PRICE);
            nft.mint("What is the capital of France?");
        }
        vm.expectRevert(NFTensor.AllNFTsMinted.selector);
        nft.mint("What is the capital of France?");
    }

    // test helper function to get tao
    function testGetTAO() public {
        getTAO(address(this), 100);
        assertEq(wtao.balanceOf(address(this)), 100);
    }

    // test transfer of wTAO deducts the correct amount of tokens
    function testWTAOMintPrice() public {
        getTAO(minter, MINT_PRICE);
        vm.startPrank(minter);
        assertEq(wtao.balanceOf(minter), MINT_PRICE);
        wtao.approve(address(nft), MINT_PRICE);
        nft.mint("what is the capital of France?");
        assertEq(wtao.balanceOf(minter), 0);
        assertEq(wtao.balanceOf(address(nft)), MINT_PRICE);
    }

    // test tokenURI can be updated correctly
    function testTokenURIUpdate() public {
        string memory uri = nft.baseURI();
        assertEq(uri, "");
        vm.prank(owner);
        nft.setBaseURI("https://nftensor.com/api/");
        assertEq(nft.baseURI(), "https://nftensor.com/api/");
    }

    // test that the tokenURI is set correcty
    function testTokenURIString() public {
        string memory uri = nft.baseURI();
        assertEq(uri, "");
        vm.prank(owner);
        nft.setBaseURI("https://nftensor.com/api/");
        nft.tokenURI(1);
        assertEq(nft.tokenURI(1), "https://nftensor.com/api/1");
    }

    // test that the owner can withdraw wTAO
    function testWithdraw() public {
        getTAO(address(minter), MINT_PRICE);
        vm.startPrank(minter);
        wtao.approve(address(nft), MINT_PRICE);
        nft.mint("what is the capital of France?");
        assertEq(wtao.balanceOf(address(nft)), MINT_PRICE);
        vm.stopPrank();

        vm.prank(owner);
        nft.withdrawWTAO();
        assertEq(wtao.balanceOf(address(nft)), 0);
        assertEq(wtao.balanceOf(owner), MINT_PRICE);
    }

    // test mint fails without sufficient wTAO
    function testMintRequiresSufficientWTAO() public {
        getTAO(minter, MINT_PRICE - 1);
        vm.startPrank(minter);
        wtao.approve(address(nft), MINT_PRICE);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        nft.mint("what is the capital of France?");
    }

    // check allowances
    function testMintRequiresSufficientAllowance() public {
        getTAO(minter, MINT_PRICE);
        vm.startPrank(minter);
        wtao.approve(address(nft), MINT_PRICE - 1);
        vm.expectRevert("ERC20: insufficient allowance");
        nft.mint("what is the capital of France?");
    }

    // Get TAO util
    function getTAO(address recipient, uint256 amount) public {
        string[] memory _froms = new string[](1);
        _froms[0] = "hi";
        address[] memory _tos = new address[](1);
        _tos[0] = recipient;
        uint256[] memory _amounts = new uint256[](1);
        _amounts[0] = amount;

        vm.prank(wtaoBridgeAddress);
        wtao.bridgedTo(_froms, _tos, _amounts);
    }

    // test the owner can revoke ownership
    function testRevokeOwnership() public {
        vm.prank(owner);
        nft.transferOwnership(address(0));
        assertEq(nft.owner(), address(0));
    }

    // test "" rejected
    function testEmptyStringRejected() public {
        getTAO(minter, MINT_PRICE);
        vm.startPrank(minter);
        wtao.approve(address(nft), MINT_PRICE);
        vm.expectRevert(NFTensor.RejectEmptyString.selector);
        nft.mint("");
    }
}
