// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, Ownable {
    constructor() ERC721("MyToken", "MT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://mytoken.com/token/";
    }

    function safeMint(address to, uint256 tokenId) public payable {
        require(msg.value > 1 ether, "Not Enough Ether");
        _safeMint(to, tokenId);
    }

    function burn(uint _tokenId) public {
        require(msg.sender == ownerOf(_tokenId), "Cannot destroy token! Function caller is not token owner.");
        _burn(_tokenId);
    }
}
