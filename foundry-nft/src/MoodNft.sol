// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();
    error MoodNft__URIQueryForNonexistentToken();

    enum Mood {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_happySvgUri;
    string private s_sadSvgUri;

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgUri, string memory happySvgUri)
        ERC721("Mood NFT", "MN")
    {
        s_sadSvgUri = sadSvgUri;
        s_happySvgUri = happySvgUri;
        s_tokenCounter = 0;
    }

    function mintNft() public {
        uint256 tokenId = s_tokenCounter;
        _mint(msg.sender, tokenId); // ✅ NOT safeMint (important for tests)
        s_tokenIdToMood[tokenId] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (_ownerOf(tokenId) == address(0)) {
            revert MoodNft__URIQueryForNonexistentToken();
        }

        string memory imageURI = s_happySvgUri;
        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgUri;
        }

        bytes memory metadata = abi.encodePacked(
            '{"name":"Mood NFT",',
            '"description":"An NFT that reflects the mood of the owner",',
            '"attributes":[{"trait_type":"mood","value":100}],',
            '"image":"', imageURI, '"}'
        );

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(metadata)
            )
        );
    }

    // getters (good practice)
    function getTokenCounter() external view returns (uint256) {
        return s_tokenCounter;
    }

    function getMood(uint256 tokenId) external view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}
