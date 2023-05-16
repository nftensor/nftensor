// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "solmate/tokens/ERC721.sol";
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

    constructor() ERC721("NFTensor", "NFTENSOR") Owned(OWNER_ADDRESS) { }

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
