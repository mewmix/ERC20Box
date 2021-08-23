/*
Abstract contract which allows trading to some external (contract) party
Mostly copied from OpenSea https://github.com/ProjectOpenSea/opensea-creatures/blob/master/contracts/TradeableERC721Token.sol
*/
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // changed import
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";



contract OwnableDelegateProxy { }

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}

/**
 * @title TradeableERC721Token
 * TradeableERC721Token - ERC721 contract that whitelists a trading address, and has minting functionality.
 */
contract TradeableERC721Token is ERC721, Ownable, ERC721URIStorage, ERC721Enumerable {
    using SafeMath for uint256;
    using Strings for string;

    uint256 burnedCounter = 0;
    address proxyRegistryAddress;
    string baseURI;

    constructor(string memory _name, string memory _symbol, address _proxyRegistryAddress, string memory _baseTokenURI) ERC721(_name, _symbol) public {
        proxyRegistryAddress = _proxyRegistryAddress;
        baseURI = _baseTokenURI;
    }

    /**
      * @dev Mints a token to an address with a tokenURI.
      * @param _to address of the future owner of the token
      */
    function mintTo(address _to) public onlyOwner {
        uint256 newTokenId = _getNextTokenId();
        _mint(_to, newTokenId);
    }

    /**
   * @dev Approves another address to transfer the given array of token IDs
   * @param _to address to be approved for the given token ID
   * @param _tokenIds uint256[] IDs of the tokens to be approved
   */
    function approveBulk(address _to, uint256[] _tokenIds) public {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            approve(_to, _tokenIds[i]);
        }
    }

    /**
      * @dev calculates the next token ID based on totalSupply and the burned offset
      * @return uint256 for the next token ID
      */
    function _getNextTokenId() private view returns (uint256) {
        return totalSupply().add(1).add(burnedCounter);
    }

    /**
      * @dev extends default burn functionality with the the burned counter
      */
    function _burn(address _owner, uint256 _tokenId) internal {
        super._burn(_owner, _tokenId);
        burnedCounter++;
    }

    function baseTokenURI() public view returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        return Strings.strConcat(
            baseTokenURI(),
            Strings.uint2str(_tokenId)
        );
    }

    /**
     * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
     */
    function isApprovedForAll(
        address owner,
        address operator
    )
    public
    view
    returns (bool)
    {
        //Check optional proxy
        if (proxyRegistryAddress != address(0)) {
            // Whitelist OpenSea proxy contract for easy trading.
            ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
            if (proxyRegistry.proxies(owner) == operator) {
                return true;
            }
        }

        return super.isApprovedForAll(owner, operator);
    }

    /// @notice Returns a list of all tokens assigned to an address.
    /// @param _owner The owner whose tokens we are interested in.
    /// @dev This method MUST NEVER be called by smart contract code, due to the price
    function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 resultIndex = 0;

            uint256 _tokenIdx;

            for (_tokenIdx = 0; _tokenIdx < tokenCount; _tokenIdx++) {
                result[resultIndex] = tokenOfOwnerByIndex(_owner, _tokenIdx);
                resultIndex++;
            }

            return result;
        }
    }
}
