//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

import "hardhat/console.sol";


contract NFTs is ERC721 {
    using Counters for Counters.Counter;

    Counters.Counter private tokenId;
    Counters.Counter private itemsSold;

    uint initialPrice = 1 ether;
    address payable owner;

    mapping (uint => NFTs) public marketItems;
    mapping (uint => bool) public tokenListed;

    struct NFTs {
        uint id;
        address seller;
        address owner;
        uint price;
        bool sold;
    }
   
   constructor() ERC721("MyToken", "MT") {
       owner = payable(msg.sender);
   }

   modifier onlyOwner() {
       require(owner == msg.sender, "Only Owner of contract can call this function.");
       _;
   }

    function _baseURI() internal pure override returns (string memory) {
        return "https://mytoken.com/token/";
    }

   function listingPrice() public view returns(uint) {
       return initialPrice;
   }

   function updateInitialPrice(uint _updatedPrice) public onlyOwner {
       initialPrice = _updatedPrice;
   }

   function mintTokens(uint price) public payable returns(uint) {
       tokenId.increment();
       uint currentId = tokenId.current();
       _mint(msg.sender, currentId);
       createNFTItems(currentId, price);
       tokenListed[currentId] = true;
   }

   function createNFTItems(uint _tokenId, uint _price) private {
       marketItems[_tokenId] = NFTs(
           _tokenId,
           payable(msg.sender),
           payable(address(this)),
           _price,
           false
       );
       _transfer(msg.sender, address(this), _price);
   }

   function buyTokens(uint _tokenId) public payable {
       require(tokenListed[_tokenId], "Invalid Token ID. No Token with ID minted.");
    //    console.log(marketItems[_tokenId].id);
       uint price = marketItems[_tokenId].price;
       address seller = marketItems[_tokenId].seller;

       require(msg.value == price, "Please pay the asking price.");

       marketItems[_tokenId].owner = msg.sender;
       marketItems[_tokenId].price = 0;
       marketItems[_tokenId].seller = address(0);

       itemsSold.increment();

       _transfer(address(this), msg.sender, _tokenId);
        payable(owner).transfer(initialPrice);
        payable(seller).transfer(price);
   }

    function fetchNFTsMarketItems() public view returns(NFTs[] memory) {
        uint totalTokens = tokenId.current();
        uint totalTokensUnsold = totalTokens - itemsSold.current();
        uint index = 0;

        NFTs[] memory items = new NFTs[](totalTokensUnsold);
        for (uint i; i < totalTokens; i++) {
             if (marketItems[i + 1].owner == address(this)) {
                 uint currentId = i + 1;
                 NFTs storage currentItem = marketItems[currentId];
                 items[index] = currentItem;
                 index += 1;
            }
        }

    }
}