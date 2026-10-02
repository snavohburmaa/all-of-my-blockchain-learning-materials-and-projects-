//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

 contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); //makeAddr - create user address
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE); //give USER 10 ether
    }
    function testUserCanFundInteractions() public {
        // Give ETH to the FundFundMe contract so it can send ETH
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), 1 ether); // Give the contract ETH to send
        
        // Fund the contract - FundFundMe will send 0.01 ether
        fundFundMe.fundFundMe(address(fundMe));

        // Check that FundMe received the funds
        assertGt(address(fundMe).balance, 0, "FundMe should have received funds");

        // Withdraw (owner is the test contract, so it can withdraw)
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0, "FundMe balance should be 0 after withdraw");
    }
 }