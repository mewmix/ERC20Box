pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title ERC20Box
 *
 * A tradable box (ERC-721), OpenSee.io compliant, which holds a portion of ERC-20 tokens,
 * that get credited to the owner upon 'opening' it
 */
contract ERC20Box is ERC721Tradable {

    ERC20 public token;

    uint256 tokensPerBox;

    /**
   * @dev Constructor function
   * Important! This ERC20Box is not functional until depositERC() is called
   */
    constructor(string memory _name, string memory _symbol, address _proxyRegistryAddress, address _tokenAddress,
    uint256 _tokensPerBox, string memory _baseTokenURI)
    ERC721Tradable(_name, _symbol, _proxyRegistryAddress, _baseTokenURI) public {
        token = ERC20(_tokenAddress);
        tokensPerBox = _tokensPerBox;
    }

    // Important! remember to call ERC20(address).approve(this, amount)
    // or this contract will not be able to do the transfer on your behalf.
    function depositERC(uint256 amount) public onlyOwner {
        require(amount % tokensPerBox == 0, "Wrong amount of tokens!");
        require(token.transferFrom(msg.sender, address this, amount), "Insufficient funds");
        for(uint i = 0; i < amount.div(tokensPerBox); i++) {
            mintTo(msg.sender);
        }
    }

    function unpack(uint256 _tokenId) public onlyOwner(_tokenId){
        require(token.balanceOf(address this) >= tokensPerBox, "Hmm, been opened already?");
        require(token.transfer(msg.sender, tokensPerBox), "Couldn't transfer token");

        // Burn the box.
        _burn(msg.sender, _tokenId);
    }

    /**
   * @dev OpenSee compatibility, expects user-friendly number
   */
    function itemsPerLootbox() public view returns (uint256) {
        return tokensPerBox.div(10**18);
    }
}
