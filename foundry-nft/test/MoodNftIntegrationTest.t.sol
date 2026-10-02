// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft moodNft;
    address USER = makeAddr("user");

    string constant HAPPY_SVG = "happy";
    string constant SAD_SVG = "sad";

    function setUp() public {
        moodNft = new MoodNft(SAD_SVG, HAPPY_SVG);
    }

    function testMintThenFlipThenCheckURI() public {
        vm.startPrank(USER);
        moodNft.mintNft();
        moodNft.flipMood(0);
        vm.stopPrank();

        string memory uri = moodNft.tokenURI(0);
        assertTrue(bytes(uri).length > 0);
    }
}
