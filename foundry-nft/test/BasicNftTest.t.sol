//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = vm.addr(1);
    string public constant KING_URI = "ipfs://Qmb95CHCny4GQSrXPnDiHXERpu4vjU4euPCEMe9HxdTtD4";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = new BasicNft();
    }

    function testName() public view {
        string memory expectedName = "Old King";
        string memory actualName = basicNft.name();
        //can't compare strings, use abi.encodePacked
        // assertEq(expectedName, actualName);
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testSymbol() public view {
        string memory expectedSymbol = "KING";
        string memory actualSymbol = basicNft.symbol();
        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }
     
    function testCanMintAndHaveBalance() public {
        vm.startPrank(USER);
        basicNft.mintNft(KING_URI);
        vm.stopPrank();
    
        assertEq(basicNft.balanceOf(USER), 1);
        assertEq(
            keccak256(bytes(basicNft.tokenURI(0))),
            keccak256(bytes(KING_URI))
        );
    }
}