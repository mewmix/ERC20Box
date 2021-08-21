// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

contract TradeableERC721Token is ERC721URIStorage {
    string baseURI;
    
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}
    
    function mint(
        address account,
        uint256 tokenId
    ) external {
        _mint(account, tokenId);
    }
    
    function setTokenURI(
        uint256 tokenId, 
        string memory tokenURI
    ) external {
        _setTokenURI(tokenId, tokenURI);
    }
    
    function setBaseURI(string memory baseURI_) external {
        baseURI = baseURI_;
    }
    
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}
