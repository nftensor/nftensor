# NFTensor
[Git Source](https://github.com/nftensor/nftensor/blob/975cf3c837f6ac6d7d347ddd097b8519de927d4e/src/NFTensor.sol)

**Inherits:**
ERC721, Owned

**Author:**
0xcacti

Below is the contract for handling saving queries from which to create NFTs using the response from the
Bittensor network


## State Variables
### OWNER_ADDRESS
The owner address.


```solidity
address constant OWNER_ADDRESS = 0xB95777719Ae59Ea47A99e744AfA59CdcF1c410a1;
```


### WTAO_ADDRESS
wTAO address.


```solidity
address constant WTAO_ADDRESS = 0x77E06c9eCCf2E797fd462A92B6D7642EF85b0A44;
```


### MINT_PRICE
The minimum amount of wTAO required to mint an NFT.


```solidity
uint256 constant MINT_PRICE = 1e9;
```


### MAX_SUPPLY
The maximum supply of NFTs that can be minted.


```solidity
uint256 constant MAX_SUPPLY = 500;
```


### MINT_LENGTH
The length of time during which minting is possible.


```solidity
uint256 constant MINT_LENGTH = 5 days;
```


### MINT_START
Blocktimestamp during construction that signals start of minting period._tokenID


```solidity
uint256 immutable MINT_START;
```


### tokenID
The tokenID for the next token to be minted.


```solidity
uint256 public tokenID;
```


### baseURI
The baseURI for the contract.


```solidity
string public baseURI;
```


### queries
The mapping of tokenID to query.


```solidity
mapping(uint256 => string) public queries;
```


## Functions
### constructor


```solidity
constructor() ERC721("NFTensor", "NFTENSOR") Owned(OWNER_ADDRESS);
```

### mint

Mints a token to the sender.

*Only callable during the minting period. User must approve the contract to spend their wTAO.*


```solidity
function mint(string calldata query) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`query`|`string`|The query to save for the token.|


### tokenURI

get the baseURI for the contract

*return empty string if the baseURI is not previously set*


```solidity
function tokenURI(uint256 _tokenID) public view virtual override returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_tokenID`|`uint256`|the tokenID for which to retrieve metadata|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|the tokenURI for the contract|


### setBaseURI

set the baseURI for the contract

*only callable by owner*


```solidity
function setBaseURI(string memory _baseURI) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_baseURI`|`string`|the baseURI to set|


### withdrawWTAO


```solidity
function withdrawWTAO() external onlyOwner;
```

## Errors
### MintingPeriodOver

```solidity
error MintingPeriodOver();
```

### AllNFTsMinted

```solidity
error AllNFTsMinted();
```

