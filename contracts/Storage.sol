pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // changed import
import "@openzeppelin/contracts/utils/Counters.sol";
import "./TradeableERC721Token.sol"
contract TradeableERC721 is ERC721URIStorage
