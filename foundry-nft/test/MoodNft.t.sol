// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    address USER = makeAddr("user");

    string constant HAPPY_SVG =
        "data:image/svg+xml;base64,HAPPY";
    string constant SAD_SVG =
        "data:image/svg+xml;base64,SAD";

    function setUp() public {
        moodNft = new MoodNft(SAD_SVG, HAPPY_SVG);
    }

    function testMintIncreasesBalance() public {
        vm.prank(USER);
        moodNft.mintNft();

        assertEq(moodNft.balanceOf(USER), 1);
    }

    function testTokenURIOnMintIsHappy() public {
        vm.prank(USER);
        moodNft.mintNft();

        string memory uri = moodNft.tokenURI(0);
        console.log(uri);

        assertTrue(bytes(uri).length > 0);
    }

    function testFlipMood() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        assertEq(uint256(moodNft.getMood(0)), 1); // SAD
    }

    function testFlipMoodRevertsIfNotOwner() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.expectRevert();
        moodNft.flipMood(0);
    }
}
