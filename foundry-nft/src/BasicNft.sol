//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BasicNft is ERC721 {
     uint256 private s_tokenCounter;
     mapping(uint256 => string) private s_tokenIdToUri;
    
    constructor() ERC721("Old King","KING") {
        s_tokenCounter = 0;
    }
    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _mint(msg.sender, s_tokenCounter);
        s_tokenCounter++; 
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
   