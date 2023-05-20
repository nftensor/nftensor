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

    /// @ notice The maximum supply of NFTs that can be minted.
    uint256 constant MAX_SUPPLY = 500;

    /*//////////////////////////////////////////////////////////////
                               STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    /// @notice The tokenID for the next token to be minted.
    uint256 public tokenID;

    /// @notice The mapping of tokenID to query.
    mapping(uint256 => string) public queries;

    constructor() ERC721("NFTensor", "NFTENSOR") Owned(OWNER_ADDRESS) { }

    /// @notice Mints a token to the sender.
    function mint() external { }

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
}
