//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); //makeAddr - create user address
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
       //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
       DeployFundMe deployFundMe = new DeployFundMe();
       fundMe = deployFundMe.run();
       vm.deal(USER, STARTING_BALANCE); //give USER 10 ether
    }

    function testMinDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(),5e18);
    }
    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }
    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertGt(version, 0, "Price feed version should be greater than 0");
    }
    function testWithoutEnoughEth() public{
        vm.expectRevert(); //should revert next line/next line supposed to fail
        fundMe.fund();
    }
     function testFundUpdatesFundedDataStructure() public{
        vm.prank(USER); //nx tx will be sent by USER
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
     }
     function testAddsFunderToArrayOfFunders() public{
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
     }
     modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
     }
     function testOnlyOwnerCanWithdraw() public funded {
         vm.prank(USER);
         vm.expectRevert(); 
         fundMe.withdraw();
     }
     function testWithdrawFromASingleFunder() public funded {
        //arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //action 
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
        assertEq(endingFundMeBalance, 0);
     }
     function testWithdrawFromMultipleFunders() public funded {
        //arrange
        uint160 numOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for(uint160 i = startingFunderIndex; i < numOfFunders; i++){
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //action

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //assert
        assertEq(address(fundMe).balance, 0);
        assertEq(fundMe.getOwner().balance, startingOwnerBalance + startingFundMeBalance);
     }

     //cheap 
     function testCheapWithdrawFromMultipleFunders() public funded {
        //arrange
        uint160 numOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for(uint160 i = startingFunderIndex; i < numOfFunders; i++){
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //action

        vm.prank(fundMe.getOwner());
        fundMe.cheapWithdraw();
        //assert
        assertEq(address(fundMe).balance, 0);
        assertEq(fundMe.getOwner().balance, startingOwnerBalance + startingFundMeBalance);
     }
} 