// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "solmate/tokens/ERC721.sol";
import "solmate/tokens/ERC20.sol";
import "solmate/auth/Owned.sol";

/// @title NFTensor
/// @author 0xcacti
/// @notice Below is the contract for handling saving queries from which to create NFTs using the response from the
/// Bittensor network
contract NFTensor is ERC721, Owned {
    /*//////////////////////////////////////////////////////////////
                               CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice The owner address.
    address constant OWNER_ADDRESS = 0xB95777719Ae59Ea47A99e744AfA59CdcF1c410a1;

    /// @notice wTAO address.
    address constant WTAO_ADDRESS = 0x77E06c9eCCf2E797fd462A92B6D7642EF85b0A44;

    /// @notice The minimum amount of wTAO required to mint an NFT.
    uint256 constant MINT_PRICE = 1e9;

    /// @notice The maximum supply of NFTs that can be minted.
    uint256 constant MAX_SUPPLY = 500;

    /// @notice The length of time during which minting is possible.
    uint256 constant MINT_LENGTH = 5 days;

    /*//////////////////////////////////////////////////////////////
                               ERRORS
    //////////////////////////////////////////////////////////////*/

    error MintingPeriodOver();

    error AllNFTsMinted();

    /*//////////////////////////////////////////////////////////////
                               STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    /// @notice Blocktimestamp during construction that signals start of minting period._tokenID
    uint256 immutable mintStart;

    /// @notice The tokenID for the next token to be minted.
    uint256 public tokenID;

    /// @notice The mapping of tokenID to query.
    mapping(uint256 => string) public queries;

    constructor() ERC721("NFTensor", "NFTENSOR") Owned(OWNER_ADDRESS) {
        mintStart = block.timestamp;
    }

    /// @notice Mints a token to the sender.
    function mint(string calldata query) external {
        if (block.timestamp > mintStart + MINT_LENGTH) {
            revert MintingPeriodOver();
        }
        if (tokenID > MAX_SUPPLY) {
            revert AllNFTsMinted();
        }
        // make sure you are handling this correctly
        require(ERC20(WTAO_ADDRESS).transferFrom(msg.sender, address(this), MINT_PRICE));

        _safeMint(msg.sender, ++tokenID);
        queries[tokenID] = query;
    }

    /*//////////////////////////////////////////////////////////////
                               METADATA
    //////////////////////////////////////////////////////////////*/

    /// @notice get the baseURI for the contract
    /// @dev return metadata if baseURI is not previously set
    /// @param _tokenID the tokenID for which to retrieve metadata
    /// @return the tokenURI for the contract
    function tokenURI(uint256 _tokenID) public view virtual override returns (string memory) {
        return "temp string";
    }

    /*//////////////////////////////////////////////////////////////
                               ADMIN
    //////////////////////////////////////////////////////////////*/

    function withdrawWTAO() external onlyOwner {
        require(ERC20(WTAO_ADDRESS).transfer(msg.sender, ERC20(WTAO_ADDRESS).balanceOf(address(this))));
    }

    // function withdrawLink() external onlyOwner {
    //     LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    //     require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    // }
}
