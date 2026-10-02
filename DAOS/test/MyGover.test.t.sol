// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {GovToken} from "../src/GovToken.sol";
import {MyGovernor} from "../src/MyGovernor.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {Box} from "../src/Box.sol";
import {console} from "forge-std/console.sol";

contract MyGovernorTest is Test {
    
    MyGovernor governor;
    Box box;
    TimeLock timelock;
    GovToken govToken;

    address public USER = makeAddr("user");
    uint256 public constant INITIAL_SUPPLY = 100 ether;
    uint256 public constant VOTING_DELAY = 1;
    uint256 public constant VOTING_PERIOD = 50400;
    uint256 public constant MIN_DELAY = 1 hours;

    address[] proposers;
    address[] executors;
    uint256[] values;
    bytes[] calldatas;
    address[] targets;

    function setUp() public {
        govToken = new GovToken(address(this));
        govToken.mint(address(USER), INITIAL_SUPPLY);

        vm.startPrank(USER);
        govToken.delegate(USER);
        timelock = new TimeLock(MIN_DELAY, proposers, executors); 
        governor = new MyGovernor(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(governor));
        timelock.revokeRole(adminRole, USER);

        vm.stopPrank();

        box = new Box();
        box.transferOwnership(address(timelock));
    }

    function testCanUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
        box.store(1);
    }

    function testGovernanceUpdateBox() public {
        uint256 valueToStore = 888;
        string memory description = "Update box value";
        bytes memory encodedFunctionCall = abi.encodeWithSignature("store(uint256)", valueToStore);
        values.push(0);
        calldatas.push(encodedFunctionCall);
        targets.push(address(box));

        //1. purpose to DAO
        vm.startPrank(USER);
        uint256 proposalId = governor.propose(targets, values, calldatas, description);

        //view the state
        console.log("Proposal ID:", uint256(governor.state(proposalId)));

        vm.warp(block.timestamp + VOTING_DELAY + 1 );
        vm.roll(block.number + VOTING_DELAY + 1);

        console.log("Proposal ID:", uint256(governor.state(proposalId)));

        //2. vote
        string memory reason = "Idiot";
        uint8 voteWay = 1; //voting -> yes
        governor.castVoteWithReason(proposalId, voteWay, reason);

        vm.warp(block.timestamp + VOTING_PERIOD + 1 );
        vm.roll(block.number + VOTING_PERIOD + 1);
        
        //3.Queue the tx
        bytes32 descriptionHash = keccak256(bytes(description));
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + MIN_DELAY + 1 );
        vm.roll(block.number + MIN_DELAY + 1);

        //4. Execute the tx
        governor.execute(targets, values, calldatas, descriptionHash); 
        vm.stopPrank();
        assertEq(box.getNumber(), valueToStore);
    }

}