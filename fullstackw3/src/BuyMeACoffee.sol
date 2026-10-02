// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BuyMeACoffee {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function buyCoffee() external payable {
        // Accept any amount of ETH sent
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        (bool sent, ) = owner.call{value: balance}("");
        require(sent, "Withdraw failed");
    }
}
